%{
	#define SIBLINGS 5
	#define CHILDREN 15
	#include <stdlib.h>
	#include <stdio.h>
	#include <string.h>
	#include <math.h>
	#include "structs.h"

	int yylex();
	void yyerror(char* s);

	char* getNumberFormat(float number); 	// gets format for a number, checking if it is an int or a float
	void solve_coord_flags(); 				// checks if coordination is at sentence or argument level
	

	int ccFlag = -1; 		// flag - tells us if we need to solve coorindation level
	int sentenceFlag = -1; 	// flag - tells us if we found a new sentence

	int toolFlag = -1; 		// flag - tells us if a tool was mentioned
	int containerFlag = -1; // flag - tells us if a container was mentioned
	int heatFlag = -1; 		// flag - tells us if heat was mentioned
	int dimensionFlag = -1; // flag - tells us a dimension was found
	int subActionFlag = -1; // flag - tells us a verb is introduced by another verb 

	int arg3Flag = -1; 		// flag - tells us if we found an arg3 that maybe needs a coupling with an arg4

	node* makeNode(char* level, char* label, char* value); 	// creates a new node

	void addChild(node* parent, node* child); 			// adds a new child
	void addSibling(node* current, node* sibling); 		// adds a new sibling 

	children* saveChild(children* children, node* newChild);  	// save child to a children structure to attach later 
	void attachChildren(node* parent, children* children); 		// attach children to parent
	void attachSiblings(node* parent, node* child); 			// attach siblings to parent

	void printNode(node* current); 								// prints a node and all its descendants
	void printNodeTab(node* current, int tabs); 				// prints a node and all its decendants with tabs corresponding to the tree level


	char* nodeToJSON(node* node); 	// converts a node to JSON
	void saveJSON(char* json); 		// saves a JSON string to a file

	void resetFlags(); 		// resets the flags

	char* getNumberTag();

	char* concat2(char* a1, char* a2, char* split);
	
%}

%union {
	float number; 
	char* text;
	struct Node* node;
	struct Pair* pair;
	struct Children* children;
}


%start program

%token <text> SECOND HOUR MIN DAY WEEK MONTH YEAR RELATIVE_TIME
%token <text> AUX_UNIT DIMENSION 
%token <text> UNK_WORD NL DASH SLASH EOS

%token <pair> L M G CUP INCH 
%token <pair> DIGIT TENS TEENS HUNDRED THOUSAND DOZEN 

%token <text> TO IN CC CC2 CC3 OF ON FOR AT FROM INTO ONTO TO_Q TO_T DIGITS_NUMBER 
%token <text> WHILE WHEN UNTIL AFTER BEFORE ABOVE BELOW AROUND AT_A_TIME
%token <text> WITH  OVER UNDER ABOUT IF BETWEEN NOT 
%token <text> DET JJ RB ACTION PRP BY GERUND GERUND2 JJ_TEMP 
%token <text> LOC_PREP SUB_ACTION TIME_PREP
%token <text> HEAT TEMPERATURE CONTAINER TOOL DIR FRACTION_NUMBER 

%token <text> DUAL_VN DUAL_VJ DUAL_VR DUAL_VJR DUAL_VN_TOOL DUAL_VN_HEAT DUAL_VN_CONTAINER DUAL_VC DUAL_VNJ
%token <text> DUAL_JR DUAL_NJ DUAL_NR DUAL_VNR 

%type <number> number number_thousands number_hundreds number_tens val_hundreds

%type <children> adjDet adjPQs adjPQ

%type <text> unkP unk noun 
%type <text> adverb verb adjective
%type <text> tool container heat

%type <text> time_unit ingredient_unit quantity
%type <text> arg2_prep loc_prep time_prep_relative time_prep temperature_prep loc_prep_solo

%type <children> time ingredient_quantity  
%type <children> advP unkPJs adjP

%type <node> unkPJ
%type <node> argAux argm arg arg0 arg1 arg2 arg3 arg4 argm_adv argm_gol argm_mnr argm_loc argm_neg argm_tmp argm_ext argm_dir argm_prp
%type <node> induced_sentence gerund_frame argm_tmp_frame temperature_ext
%type <node> v sentenceV sentenceNotV sentence

%type <children> argmChain args arguments 
%type <children> step recipe

%right UNTIL
%nonassoc CC OF

%left THOUSAND
%left HUNDRED
%left TENS 
%left TEENS
%left DASH
%left DIGIT

%left UNK_WORD DUAL_VN 
%left DUAL_VN_TOOL DUAL_VN_CONTAINER DUAL_VN_HEAT

%%

program : program recipe NL 							{ node* nod = makeNode("RECIPE", "", ""); attachChildren(nod, $2); printNode(nod); char* json = nodeToJSON(nod); saveJSON(json); free(json);}
		|
		;

recipe 	: recipe step EOS 								{ node* nod = makeNode("STEP", "", ""); attachChildren(nod, $2); $$ = saveChild($1, nod);}
		| step EOS 										{ node* nod = makeNode("STEP", "", ""); attachChildren(nod, $1); $$ = saveChild(NULL, nod);}
		;

step	: sentence 										{ $$ = saveChild(NULL, $1); }
		| step sentence_cc sentence 					{ $$ = saveChild($1, $3); }
		| step sentenceV 								{ if (subActionFlag == -1) {$$ = saveChild($1, $2);} else {node* nod = makeNode("ARG","ARG1",""); addChild(nod, $2); addChild($1->children[$1->nrChildren-1], nod); subActionFlag = -1;} }
		;
		
sentence_cc	: CC2 									
			| CC 										
			;

sentence 	: sentenceV 									{ if (subActionFlag == -1) {$$ = $1;} else {node* nod = makeNode("ARG","ARG1",""); addChild(nod, $1); $$ = nod; subActionFlag = -1;} resetFlags();}
			| sentenceNotV  								{ $$ = $1; resetFlags();}
			;

sentenceV	: v args 											{ attachChildren($1, $2); $$ = $1; }
			| v 												{ $$ = $1; }
			;

sentenceNotV 	: gerund_frame sentenceV 						{ node* nod = makeNode("ARG", "ARGM-MNR", ""); addChild(nod, $1); addChild($2, nod); $$ = $2;}
				| arguments sentenceV 							{ attachChildren($2, $1); $$ = $2;}
				;


args 	: arg1 													{ $$ = saveChild(NULL, $1);}
		| arg1 gerund_frame 									{ $$ = saveChild(NULL, $1);node* nod = makeNode("ARG","ARGM-MNR",""); addChild(nod, $2); saveChild($$,nod);}
		| arg1 argmChain 										{ $$ = saveChild($2, $1);}
		| argmChain arg1 										{ $$ = saveChild($1, $2);}
		| argmChain 											{ $$ = $1; solve_coord_flags(); }
		;

arg1 	: unkPJs       										{ resetFlags();$$ = makeNode("ARG", "ARG1", ""); attachChildren($$,$1); }
		| gerund_frame 		 								{ node* nod = makeNode("ARG", "ARG1", ""); addChild(nod, $1); $$ = nod; }
		;

advP 	: advP DASH adverb 									{ $$ = $1; $1->children[$1->nrChildren-1]->value = concat2($1->children[($1->nrChildren)-1]->value,$3,"-"); }
		| adverb 											{ node* nod = makeNode("SUBARG","ADV",$1); $$ = saveChild(NULL,nod);}
		| advP adverb 										{ node* nod = makeNode("SUBARG","ADV",$2); $$ = saveChild($1,nod);}
		;

adverb 	: RB
		| DUAL_JR
		| DUAL_NR
		| DUAL_VJR
		| DUAL_VNR
		;

unkPJs 	: unkPJs OF unkPJ 								{ strcat($1->children[$1->nrChildren-1]->value," of"); addChild($1->children[$1->nrChildren-1],$3); $$=$1; }
		| unkPJ 										{ continuousCC = 0; $$ = saveChild(NULL,$1); }									
		| unkPJs CC unkPJ 								{ continuousCC++; $$ = saveChild($1,$3); }
		| unkPJs CC 									{ ccFlag = 1; $$ = $1; }
		;


unkPJ 	: adjDet unkP 									{ $$ = makeNode("SUBARG","OBJECT",$2); attachChildren($$,$1); }
		| unkP 											{ $$ = makeNode("SUBARG","OBJECT",$1); }	
		| GERUND 										{ $$ = makeNode("SUBARG","GERUND",$1); }	
		;

unkP 		: unk 									{ $$ = $1;  }	
			| unkP unk							{ $$ = concat2($1,$2," "); }	
			;

unk 	: UNK_WORD 																				
		| noun 																					
		| PRP 														
		;

noun 	: DUAL_VN 																		
		| DUAL_VNJ										
		| DUAL_NJ										
		| DUAL_VNR										
		| FRACTION_NUMBER								
		| tool 											
		| container 									{ containerFlag  = 1; }
		| heat 											{ heatFlag = 1; }
		;

verb	: DUAL_VN
		| DUAL_VJ
		| DUAL_VJR
		| DUAL_VN_TOOL
		| DUAL_VN_CONTAINER 								
		| DUAL_VN_HEAT
		| DUAL_VR
    	| DUAL_VC
    	| DUAL_VNJ
    	| DUAL_VNR
    	| ACTION
    	| SUB_ACTION 								{ subActionFlag = 1;}
    	;

v 		: verb 										{ $$ = makeNode("V", "V", $1);}
		;

argmChain 	: arguments 							{ $$ = $1; }
			| arguments induced_sentence 				{ $$ = saveChild($1, $2); }
			| induced_sentence 						{ $$ = saveChild(NULL, $1); }
			;

arguments 	: arguments argAux 								{ $$ = saveChild($1, $2); }
			| argAux  										{ $$ = saveChild(NULL, $1); }
			;

argAux 	: arg
		| CC arg 											{ $$ = $2; }
		;

induced_sentence 	: CC sentenceV    							{ sentenceFlag = 1; $$ = $2; }
					| gerund_frame 								{ $$ = $1; strcpy($1->label,"ARGM-MNR"); strcpy($1->level,"ARG");}
					;

gerund_frame 	: gerund_frame arguments 					{ attachChildren($1, $2); $$ = $1; }
				| adjP gerund_frame 						{ node* nod = makeNode("ARG", "ARGM-MNR", "");  attachChildren(nod, $1); addChild($2, nod); $$ = $2; }
				| advP gerund_frame 						{ node* nod = makeNode("ARG", "ARGM-MNR", "");  attachChildren(nod, $1); addChild($2, nod); $$ = $2; }
				| GERUND2 unkPJs 							{ node* nodV = makeNode("V", "V", $1); node* nodArg1 = makeNode("ARG", "ARG1", "");  attachChildren(nodArg1,$2);
																addChild(nodV, nodArg1); $$ = nodV; }	
				| GERUND2 									{ node* nod = makeNode("V", "V", $1);$$ = nod; }
				;

arg 	: arg2 												{ if (containerFlag == 1) { strcpy($1->label,"ARGM-LOC"); containerFlag = -1;} else if (heatFlag == 1) { strcpy($1->label,"ARGM-EXT"); heatFlag = -1; }  $$ = $1; }
		| argm 	 											{ $$ = $1;}
		| arg3 												{ $$ = $1; arg3Flag = 1;}	
		| arg4 												{ $$ = $1; }	
		;

arg2 	: arg2_prep unkPJs									{ $$ = makeNode("ARG", "ARG2", $1); attachChildren($$,$2);}
		| adjP												{ $$ = makeNode("ARG", "ARG2", ""); attachChildren($$,$1); }
		| unkPJs 											{ $$ = makeNode("ARG", "MERGE", ""); attachChildren($$,$1);}										
		;

arg2_prep 	: BY 
			| OVER 
			| UNDER 
			| BETWEEN
			| AROUND
			| INTO
			;

arg3	: FROM unkPJs 										{ node* nod = makeNode("ARG", "ARG3", $1); attachChildren(nod, $2); $$ = nod;}
		;


arg4	: loc_prep_solo unkPJs 								{ node* nod = makeNode("ARG", "ARG4", $1); attachChildren(nod, $2); $$ = nod; }
		;


argm 	: argm_loc 											{ $$ = $1; containerFlag = -1; }
		| argm_ext  										{ $$ = $1; }
		| argm_tmp											{ $$ = $1; heatFlag = -1; }
		| argm_mnr											{ $$ = $1; }
		| argm_dir											{ $$ = $1; }
		| argm_gol											{ $$ = $1; }
		| argm_neg											{ $$ = $1; }
		| argm_adv											{ $$ = $1; }
		| argm_prp 											{ $$ = $1; }
		| argm_tmp_frame 									{ $$ = $1; }
		;


argm_prp	: TO sentenceV 						{ node* nod = makeNode("ARG", "ARGM-PRP", $1); addChild(nod, $2); $$ = nod; }
			| TO unkPJs 						{ node* nod; if (arg3Flag == -1) {
														if (containerFlag == 1) { nod = makeNode("ARG", "ARGM-LOC", $1); containerFlag = -1;} else if (heatFlag == 1) { nod = makeNode("ARG", "ARGM-EXT", $1); heatFlag = -1; } else {nod = makeNode("ARG", "ARG2", $1); }
														} 
														else { arg3Flag = -1; nod = makeNode("ARG", "ARG4", $1);} 
														attachChildren(nod, $2); $$ = nod; }
			| TO_Q unkPJs 						{ node* nod; if (arg3Flag == -1) {
														if (containerFlag == 1) { nod = makeNode("ARG", "ARGM-LOC", $1); containerFlag = -1;} else if (heatFlag == 1) { nod = makeNode("ARG", "ARGM-EXT", $1); heatFlag = -1; } else {nod = makeNode("ARG", "ARG2", $1); }
														} 
														else { arg3Flag = -1; nod = makeNode("ARG", "ARG4", $1);} 
														attachChildren(nod, $2); $$ = nod; }
			;


argm_neg 	: NOT  											{ $$ = makeNode("ARG", "ARGM-NEG",$1); }
			;

argm_gol 	: FOR unkPJs 									{ node* nod = makeNode("ARG", "ARGM-GOL",$1); attachChildren(nod,$2); $$ = nod; }
			| FOR adjP 										{ node* nod = makeNode("ARG", "ARGM-GOL",$1); attachChildren(nod,$2); $$ = nod; }
			;

argm_adv 	: IF adjP 										{ node* nod = makeNode("ARG", "ARGM-ADV",$1); attachChildren(nod,$2); $$ = nod; }
			| IF arg0 sentence 								{ node* nod = makeNode("ARG", "ARGM-ADV",$1); addChild($3, $2); addChild(nod,$3); $$ = nod; }
			;

argm_dir 	: DIR 											{ $$ = makeNode("ARG", "ARGM-DIR",$1); }									
			| OVER 											{ $$ = makeNode("ARG", "ARGM-DIR",$1); }
			;

argm_mnr	: WITH unkPJs 									{ node* nod = makeNode("ARG", "ARGM-MNR",$1); attachChildren(nod,$2); $$ = nod; }
			| advP 											{ node* nod = makeNode("ARG", "ARGM-MNR",""); attachChildren(nod,$1); $$ = nod; }
			| AT_A_TIME 									{ node* nod = makeNode("ARG", "ARGM-MNR",$1); $$ = nod;}
			;

argm_tmp_frame 	: time_prep_relative arg0 sentence		{ node* nod = makeNode("ARG", "ARGM-TMP", $1); addChild($3, $2); addChild(nod, $3); $$ = nod; }
				| time_prep_relative gerund_frame 		{ node* nod = makeNode("ARG", "ARGM-TMP", $1); addChild(nod, $2); $$ = nod;}		
				;

time_prep_relative 	: UNTIL  		
					| WHEN
					| WHILE
					| AFTER 
					| BEFORE
					;

arg0 	: arg1 											{ $$ = $1; strcpy($1->label,"ARG0");}
		;			

argm_tmp	: time_prep JJ_TEMP 			{ node* nod = makeNode("ARG", "ARGM-TMP",$1); node* adj = makeNode("SUBARG","QUALITY",$2); addChild(nod,adj); $$ = nod;}
			| time_prep arguments			{ node* nod = makeNode("ARG", "ARGM-TMP",$1); attachChildren(nod,$2); $$ = nod;}
			| time_prep time   				{ node* nod = makeNode("ARG", "ARGM-TMP",$1); attachChildren(nod,$2); $$ = nod; }
			| time 		 					{ node* nod = makeNode("ARG", "ARGM-TMP",""); attachChildren(nod,$1); $$ = nod; }
			;		

time_prep 	: time_prep_relative
			| TIME_PREP 
			;

time 	: adjDet time_unit 									{ node* nod = makeNode("SUBARG","UNIT",$2); $$ = saveChild($1,nod); }
		| time time 	 									{ node* nod = makeNode("SUBARG","TIME",""); node* nod1 = makeNode("SUBARG","TIME",""); node* nod2 = makeNode("SUBARG","TIME",""); attachChildren(nod1,$1); attachChildren(nod2,$2); addChild(nod, nod1); addChild(nod, nod2); $$ = saveChild(NULL,nod); }
		| time TO_T time 	 								{ node* nod = makeNode("SUBARG","TIME-INTERVAL",""); node* nod1 = makeNode("SUBARG","TIME-MIN",""); node* nod2 = makeNode("SUBARG","TIME-MAX",""); attachChildren(nod1,$1); attachChildren(nod2,$3); addChild(nod, nod1); addChild(nod, nod2); $$ = saveChild(NULL,nod); }
		| adjDet TO_T time 	 								{ node* nod = makeNode("SUBARG","TIME-INTERVAL",""); node* nod1 = makeNode("SUBARG","TIME-MIN",""); node* nod2 = makeNode("SUBARG","TIME-MAX",""); attachChildren(nod1,$1); attachChildren(nod2,$3); addChild(nod, nod1); addChild(nod, nod2); $$ = saveChild(NULL,nod); }
		| time_unit 										{ node* nod = makeNode("SUBARG","UNIT",$1); $$ = saveChild(NULL, nod); }
		| time adjective 									{ node* nod = makeNode("SUBARG", "QUALITY",$2); $$ = saveChild($1,nod);}
		;

time_unit 	: SECOND
			| HOUR 
			| MIN 
			| DAY 
			| WEEK 
			| MONTH 
			| YEAR 
			| RELATIVE_TIME
			;

argm_loc	: loc_prep unkPJs								{ $$ = makeNode("ARG","ARGM-LOC",$1); attachChildren($$,$2); }
			| loc_prep_solo									{ $$ = makeNode("ARG","ARGM-LOC",$1);}
			;

loc_prep	: IN 
			| ON
			| ONTO
			| LOC_PREP
			;

loc_prep_solo	: ABOVE 
				| BELOW 
				;

argm_ext	: temperature_prep temperature_ext 				{ $$ = $2; $2->value = concat2($1,$2->value," "); }
			| temperature_prep unkPJs 						{ node* nod; if (heatFlag == -1) { nod = makeNode("ARG","ARGM-MNR",$1);} else {nod = makeNode("ARG","ARGM-EXT",$1);} attachChildren(nod, $2); $$ = nod;}
			| temperature_ext 								{ $$ = $1;}
			;

temperature_prep 	: TO 
					| UNDER 
					| AT 
					;

temperature_ext	: TEMPERATURE 								{ $$ = makeNode("ARG","ARGM-EXT",$1); }
				;

container 	: CONTAINER 									
			| DUAL_VN_CONTAINER 							
			;

tool 	: TOOL 												
		| DUAL_VN_TOOL 										
		;

heat	: HEAT 												
		| DUAL_VN_HEAT 										
		;


adjDet	: adjPQs  											{ $$ = $1; }
		| DET adjPQs 										{ node* nod = makeNode("SUBARG","DET",$1); $$ = saveChild(NULL, nod); 
																for (int i = 0; i < $2->nrChildren; i++) $$ = saveChild($$,$2->children[i]); }
		| DET 												{ node* nod = makeNode("SUBARG","DET",$1); $$ = saveChild(NULL, nod); }
		| ingredient_quantity 								{ $$ = $1; }
		;

adjPQs	: adjPQs adjPQ										{ $$ = $1; for (int i = 0; i < $2->nrChildren; i++) $$ = saveChild($1,$2->children[i]); }
		| adjPQ 											{ $$ = $1; }
		| adjPQ TO_Q adjPQ 									{ node* nod = makeNode("SUBARG","QUANTITY-INTERVAL",""); node* nod1 = makeNode("SUBARG","QUANTITY-MIN",""); node* nod2 = makeNode("SUBARG","QUANTITY-MAX",""); attachChildren(nod1,$1); attachChildren(nod2,$3); addChild(nod, nod1); addChild(nod, nod2); $$ = saveChild(NULL,nod);}
		;

adjPQ 	: ingredient_quantity  								{ numberFlag = 1; $$ = $1; }
		| quantity DASH UNK_WORD 							{ numberFlag = 1; node* qNode = makeNode("SUBARG",getNumberTag(),$1); 
																node* uNode = makeNode("SUBARG","UNIT",$3); 
													  			$$ = saveChild(NULL,qNode); $$ = saveChild($$, uNode);}
		| quantity DASH ingredient_unit 					{ numberFlag = 1; node* qNode = makeNode("SUBARG",getNumberTag(),$1); 
																node* uNode = makeNode("SUBARG","UNIT",$3); 
													  			$$ = saveChild(NULL,qNode); $$ = saveChild($$, uNode); }
		| quantity DASH ingredient_quantity 				{ numberFlag = 1; $3->children[0]->value = concat2($1,$3->children[0]->value,"-"); $$ = $3; }
		| adjP 												{ $$ = $1;}		
		;

adjP	: adjective 										{ node* nod = makeNode("SUBARG","QUALITY",$1); $$ = saveChild(NULL, nod); }
		| adjP adjective 									{ node* nod = makeNode("SUBARG","QUALITY",$2); $$ = saveChild($1,nod); }
		| adjP DASH adjective 								{ $$ = $1; $1->children[$1->nrChildren-1]->value = concat2($1->children[$1->nrChildren-1]->value,$3,"-");}
		| adjP CC adjective  								{ node* nod = makeNode("SUBARG","QUALITY",$3); $$ = saveChild($1,nod); }
		| adjP CC CC3		  								{ $$ = $1;}
		;

adjective	: JJ 											
			| DUAL_JR 										
			| DUAL_NJ 										
			| DUAL_VJ 																			
			;

ingredient_quantity	: quantity  ingredient_unit 		{ node* qNode = makeNode("SUBARG",getNumberTag(),$1); node* uNode = makeNode("SUBARG","UNIT",$2); 
														  $$ = saveChild(NULL,qNode); $$ = saveChild($$, uNode); }
					| quantity 							{ node* nod = makeNode("SUBARG",getNumberTag(),$1); $$ = saveChild(NULL, nod); }
					;

ingredient_unit	: L 									{ $$ = malloc(strlen($1->label)+1); strcpy($$, $1->label); }
				| G 									{ $$ = malloc(strlen($1->label)+1); strcpy($$, $1->label); }
				| M 									{ $$ = malloc(strlen($1->label)+1); strcpy($$, $1->label); }
				| CUP 									{ $$ = malloc(strlen($1->label)+1); strcpy($$, $1->label); }
				| AUX_UNIT 								
				| INCH 									{ $$ = malloc(strlen($1->label)+1); strcpy($$, $1->label); }
				| ingredient_unit OF 					{ $$ = concat2($1,"of"," "); }
				;

quantity	: number  										{ $$ = malloc(1+15); sprintf($$, getNumberFormat($1), $1);}
			| DIMENSION 									{ dimensionFlag = 1; }
			| quantity DIGITS_NUMBER 						{ $$ = concat2($1,$2," "); }
			| quantity SLASH number 						{ char* digits = malloc(1+15); sprintf(digits, getNumberFormat($3), $3); $$ = concat2($1,digits, "/"); }
			| ABOUT quantity 								{ $$ = concat2("about",$2," "); }
			| DIGITS_NUMBER 								{ }
			;
				

number 	: number_thousands
		| number_hundreds
		| number_tens 									
		| DOZEN 											{ $$ = $1->value; }		
		;

number_thousands 	: val_hundreds THOUSAND val_hundreds 			{ $$ = $1 * 1000 + $3;}
					| val_hundreds THOUSAND  						{ $$ = $1 * 1000;}
					| THOUSAND val_hundreds 						{ $$ = 1000 + $2;}
					| THOUSAND  									{ $$ = 1000;}
					;

val_hundreds	: number_tens 							{ $$ = $1; }
				| number_hundreds 						{ $$ = $1; }
				;

number_hundreds	: number_tens HUNDRED number_tens 		{ $$ = $1 * 100 + $3; }
				| number_tens HUNDRED    				{ $$ = $1 * 100; }
				| HUNDRED number_tens 					{ $$ = 100 + $2; }
				| HUNDRED                               { $$ = 100; }
				;

number_tens	: DIGIT 									{ $$ = $1->value; }
			| TENS 										{ $$ = $1->value; }
			| TENS DIGIT								{ $$ = $1->value + $2->value; }
			| TENS DASH DIGIT 							{ $$ = $1->value + $3->value; }
			| TEENS 									{ $$ = $1->value; }
			;

%%

void yyerror(char* s) {
	printf("\nError: %s\n", s);
	FILE* fp = fopen("recipe.json","w");
	if (fp != NULL) {
		fprintf(fp, "%d", -1);
		fclose(fp);
	}
}

char* concat2(char* a1, char* a2, char* split) {
	char* result = (char*) malloc(strlen(a1)+1+strlen(a2)+1);
	strcpy(result, a1);
	strcat(result, split);
	strcat(result, a2);
}

char* getNumberTag() {
	if (dimensionFlag == 1) {
		dimensionFlag == -1;
		return "DIMENSION";
	} else {
		return "QUANTITY";
	}
}


char* getNumberFormat(float number) {

	char* format = malloc(5);
	if (floorf(number) == number) 
	{
		strcpy(format, "%.0f");	
	} 
	else {
		strcpy(format, "%.4f");
	}
	return format;
}


node* makeNode(char* level, char* label, char* value) {

	node* newNode = (node*) calloc(1, sizeof(node));

	newNode->level = (char*) malloc(strlen(level)+1);
	newNode->label = (char*) malloc(strlen(label)+1);
	newNode->value = (char*) malloc(strlen(value)+1);

	strcpy(newNode->level, level);
	strcpy(newNode->label, label);
	strcpy(newNode->value, value);

	newNode->nrChildren = 0;
	newNode->nrSiblings = 0;

	return newNode;
}


void addSibling(node* current, node* sibling) {

	if (current->nrSiblings >= SIBLINGS) {
		printf("Maximum number of siblings exceeded!\n");
		return;
	}

	(current->siblings)[current->nrSiblings] = sibling;
	current->nrSiblings = current->nrSiblings + 1;
}

void addChild(node* parent, node* child) {

	if (parent->nrChildren >= CHILDREN) {
		printf("Maximum number of children for a node exceeded!\n");
		return;
	}

	(parent->children)[parent->nrChildren] = child;
	parent->nrChildren = parent->nrChildren + 1;

}


children* saveChild(children* children, node* newChild) { 

	if (children != NULL) {
		if (children->nrChildren >= CHILDREN) {
			printf("Maximum number of children for a node exceeded!\n");
			return children;
		}

		children->children[children->nrChildren] = newChild;
		(children->nrChildren)++;
		return children;
	} 

	struct Children* newChildren = (struct Children*) calloc(1, sizeof(struct Children));
	(newChildren->children)[0] = newChild;
	newChildren->nrChildren = 1;

	return newChildren;
}


void attachSiblings(node* parent, node* child) {

	if (child->nrSiblings > 0) {
	  for (int i = 0; i < child->nrSiblings; i++) {
	  	addChild(parent, (child->siblings)[i]);
	  }
	}
}


void attachChildren(node* parent, children* children) {

	int current = parent->nrChildren;
	int n = children->nrChildren;
	int hasArg0 = -1;

	for (int i = 0; i < n; i++) {

		if (strcmp((children->children)[i]->level, "V") == 0 && strcmp(parent->level,"V") == 0) // parent - child = are actually siblings
		{
			addSibling(parent, (children->children)[i]);

		} else {
			if (strcmp((children->children)[i]->label, "ARG0") == 0) {
				hasArg0 = 1;
			}
			
			if (i < n-1 && strcmp((children->children)[i]->label, "ARG2") == 0 && strcmp((children->children)[i+1]->label,"MERGE") == 0) 
			{
				int len = (children->children)[i]->nrChildren;
				for (int j = 0; j < len; j++) {
					addChild((children->children)[i+1]->children[0],(children->children)[i]->children[j]);
				}
				strcpy((children->children)[i+1]->label,"ARG1");
				addChild(parent, (children->children)[i+1]);
				i++;
				continue;
			}
			if (strcmp((children->children)[i]->label,"MERGE") == 0) {
				if (hasArg0 == 1) {
					strcpy((children->children)[i]->label,"ARG2");
				} else {
					strcpy((children->children)[i]->label,"ARG1");
				}
				
			}

			addChild(parent, (children->children)[i]);

			if (strcmp((children->children)[i]->level, "V") == 0 && strcmp(parent->level,"V") != 0 && strcmp(parent->level,"STEP") != 0) 
			{
				attachSiblings(parent, (children->children)[i]);
			} 
		}

		for (int j = 0; j < children->children[i]->nrSiblings; j++) 
		{
			addChild(parent, children->children[i]->siblings[j]);
		}
	}

}

void printNode(node* current) {

	printf("Level: %s\n", current->level);
	printf("Label: %s\n", current->label);
	printf("Value: %s\n", current->value);

	for (int i = 0; i < current->nrChildren; i++) {
		printNodeTab((current->children)[i], 1);
	}
}

void printNodeTab(node* current, int tabs) {

	char* tab = malloc(tabs+1);
	strcpy(tab, "\t");

	for (int j = 0; j < tabs-1; j++)
		strcat(tab,"\t");

	printf("%sLevel: %s\n", tab, current->level);
	printf("%sLabel: %s\n", tab, current->label);
	printf("%sValue: %s\n", tab, current->value);

	free(tab);

	for (int i = 0; i < current->nrChildren; i++) {
		printNodeTab((current->children)[i], tabs+1);
	}

}

void solve_coord_flags() {
	if (ccFlag == 1) {
		ccFlag = -1;
	} else if (sentenceFlag == 1) {
		sentenceFlag = -1;
	} 
}


char* nodeToJSON(node* node) {

	char* json = (char*) malloc(10000); 
	int len = sprintf(json, "{ \"level\": \"%s\",\"label\": \"%s\",\"value\": \"%s\"",node->level, node->label, node->value);

	if (node->nrChildren > 0) 
	{
		int aux = sprintf(json+len, ", \"children\":[");
		len += aux;
	
		for (int i = 0; i < node->nrChildren; i++)
		{
			char* child = nodeToJSON(node->children[i]);

			if (node->nrChildren - 1 == i) {
				aux = sprintf(json+len, " %s ", child);
			} else {
				aux = sprintf(json+len, " %s, ", child);
			}
			
			free(child);
			len += aux;
		}

		aux = sprintf(json+len, "]}");
		len += aux;

	} else {
		sprintf(json+len, "}");
	}
	
	return json;
}

void saveJSON(char* json) {

	FILE* fp = fopen("recipe.json","w");
	if (fp != NULL) {
		fprintf(fp, "%s", json);
		fclose(fp);
	}
}

void resetFlags() {

	toolFlag = -1;
	containerFlag = -1;
	heatFlag = -1;
	arg3Flag = -1;
}