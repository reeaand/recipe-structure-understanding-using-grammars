%{
#include "y.tab.h"
#include <string.h>
#include "structs.h"

int set_ant(int current);
int set_noun(int original);

int solve_vn(int original);
int solve_vjr(int original); 
int solve_vj(int original); 
int solve_nr(int original);
int solve_unk(int original);
int solve_jj(int original);
int solve_gerund(int original);

int ant = -1;		// code of the previous token
int aant = -1; 		// code of the token tow positions before

%}


MILI "mili"|"m"
CENTI "centi"|"c"
DECI "deci"|"d"
DECA "deca"|"da"
HECTO "hecto"|"h"
KILO "kilo"|"k"

LITER "liter"|"litre"|"l"|"L"
GRAM "g"|"gr"|"gram"|"gramme"|"G"|"GR"
METER "m"|"M"|"meter"|"metre"

TEMP (([cC](elsius)?|[fF](ahrenheit)?|[kK](elvin)?))  

COMMA ","(" ")*?  

NUMI   [0-9]+([.,][0-9]+)? 		
NUMBER {NUMI}("/"{NUMI})*     	

TIME (sec(ond(s)?)?|min(ute(s)?)?|h(our(s)?)?|day(s)?|week(s)?|month(s)?|year(s)?|moment(s)?)  

TIME_DETECTION (({NUMBER}(" ")+)+({TIME}(" ")+)?"to ")?({NUMBER}(" "+))+{TIME}[" ""."";""?""!"] 

S ("es"|"s")?   
P (".")? 		
%%

[aA]n?|[tT]he 										{ return set_ant(DET);}

("teaspoon"|("t"|"tsp"){P}){S}						{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.005f;  return set_ant(L);}
("tablespoon"|("T"|"tbl"|"tbs"|"tbsp"){P}){S}		{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.015f; return set_ant(L);}
("fluid ounce"|"fl oz"{P}){S}						{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.030f; return set_ant(L);}
("pint"|("p"|("fl ")?"pt"){P}){S}					{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.5f; return set_ant(L);}
("quart"|("q"|("fl ")?"qt"){P}){S}					{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.9463f; return set_ant(L);}
("gallon"|("g"|"gal"){P}){S}						{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 3.78541f; return set_ant(L);}

"gill"{S}											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.5f; return set_ant(CUP);}
("cup"|"c"{P}){S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0f; return set_ant(CUP);}

({MILI}{LITER}|"cc"){S}								{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.001f; return set_ant(L);}
{CENTI}{LITER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.01f; return set_ant(L);}
{DECI}{LITER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.1f; return set_ant(L);}
{LITER}{S}											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0f; return set_ant(L);}
{DECA}{LITER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 10.0f; return set_ant(L);}
{HECTO}{LITER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 100.0f; return set_ant(L);}
{KILO}{LITER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1000.0f; return set_ant(L);}

{MILI}{GRAM}{S}										{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.001f; return set_ant(G);}
{CENTI}{GRAM}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.01f; return set_ant(G);}
{DECI}{GRAM}{S}										{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.1f; return set_ant(G);}
{GRAM}{S}											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0f; return set_ant(G);}
{DECA}{GRAM}{S}										{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 10.0f; return set_ant(G);}
{HECTO}{GRAM}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 100.0f; return set_ant(G);}
{KILO}{GRAM}{S}										{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1000.0f; return set_ant(G);}

("pound"|"lb"{P}){S}								{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 450.0f; return set_ant(G);}
("ounce"|"oz"{P}){S}								{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 25.0f; return set_ant(G);}

{MILI}{METER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.001f; return set_ant(M);}
{CENTI}{METER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.01f; return set_ant(M);}
{DECI}{METER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.1f; return set_ant(M);}
{METER}{S}											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0f; return set_ant(M);}
{DECA}{METER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 10.0f; return set_ant(M);}
{HECTO}{METER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 100.0f; return set_ant(M);}
{KILO}{METER}{S}									{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1000.0f; return set_ant(M);}

[iI]n/"." 											{ return set_ant(RB);}
[iI]n												{ return set_ant(IN);}
[oO]n 												{ return set_ant(ON);}

("inch"|"in"{P}){S}|"\""							{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.0254f; return set_ant(INCH);}

[zZ]ero 											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.0f; return set_ant(DIGIT);}
[oO]ne 												{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0f; return set_ant(DIGIT);}
[tT]wo												{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 2.0f; return set_ant(DIGIT);}
[tT]hree											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 3.0f; return set_ant(DIGIT);}
[fF]our												{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 4.0f; return set_ant(DIGIT);}
[fF]ive												{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 5.0f; return set_ant(DIGIT);}
[sS]ix												{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 6.0f; return set_ant(DIGIT);}
[sS]even											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 7.0f; return set_ant(DIGIT);}
[eE]ight											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 8.0f; return set_ant(DIGIT);}
[nN]ine 											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 9.0f; return set_ant(DIGIT);}
[tT]en 												{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 10.0f; return set_ant(TENS);}

[eE]leven											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 11.0f; return set_ant(TEENS);}
[tT]welve											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 12.0f; return set_ant(TEENS);}
[tT]hirteen											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 13.0f; return set_ant(TEENS);}
[fF]ourteen											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 14.0f; return set_ant(TEENS);}
[fF]ifteen											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 15.0f; return set_ant(TEENS);}
[sS]ixteen											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 16.0f; return set_ant(TEENS);}
[sS]eventeen										{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 17.0f; return set_ant(TEENS);}
[eE]ighteen											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 18.0f; return set_ant(TEENS);}
[nN]ineteen											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 19.0f; return set_ant(TEENS);}

[tT]wenty											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 20.0f; return set_ant(TENS);}
[tT]hirty											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 30.0f; return set_ant(TENS);}
[fF]orty											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 40.0f; return set_ant(TENS);}
[fF]ifty											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 50.0f; return set_ant(TENS);}
[sS]ixty											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 60.0f; return set_ant(TENS);}
[sS]eventy											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 70.0f; return set_ant(TENS);}
[eE]ighty											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 80.0f; return set_ant(TENS);}
[nN]inety											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 90.0f; return set_ant(TENS);}

[hH]undred{S}										{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 100.0f; return set_ant(HUNDRED);}
[tT]housand{S}										{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1000.0f; return set_ant(THOUSAND);}

[dD]ozen{S}											{ yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 12.0f; 	return set_ant(DOZEN);}

[hH]alf 											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.5f;*/ 	return set_ant(FRACTION_NUMBER);}
[tT]hird											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0/3.0f; */return set_ant(FRACTION_NUMBER);}
[qQ]uarter											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.25f;*/ 	return set_ant(FRACTION_NUMBER);}
[fF]ifth											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.20f; */	return set_ant(FRACTION_NUMBER);}
[sS]ixth											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0/6.0f;*/ return set_ant(FRACTION_NUMBER);}
[sS]eventh											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0/7.0f;*/ return set_ant(FRACTION_NUMBER);}
[eE]igth											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0/8.0f;*/ return set_ant(FRACTION_NUMBER);}
[nN]inth											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 1.0/9.0f;*/ return set_ant(FRACTION_NUMBER);}
[tT]enth											{ /*yylval.pair = malloc(sizeof(pair)); yylval.pair->label = strdup(yytext); yylval.pair->value = 0.1f;*/ 	return set_ant(FRACTION_NUMBER);}
		


[iI]|[mM]e|[yY]ou|[hH]e|[sS]he|[iI]t				{ return set_ant(PRP);}
[wW]e|[tT]hey 										{ return set_ant(PRP);}

"'s" 												{return set_ant(ACTION);}
[Aa]dd{S}											{return set_ant(ACTION);}
[Ss]tir{S}(" in ")?									{return set_ant(ACTION);}
[Tt]ransfer{S}(" "[0-9])?							{return solve_vn(DUAL_VN);}
[Cc]over{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Cc]ook{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Pp]reheat{S}										{return set_ant(ACTION);}
([Mm](ay|ight)" ")?[Bb]e							{return set_ant(ACTION);}
[Ss]prinkle{S}										{return set_ant(ACTION);}
[Ss]erve{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Bb]ring{S}											{return set_ant(ACTION);}
[Rr]emove{S}										{return set_ant(ACTION);}
[Aa]re												{return set_ant(ACTION);}
[Ii]s												{return set_ant(ACTION);}
[Bb]ake{S}											{return set_ant(ACTION);}
[Pp]lace{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Mm]ix(es)?(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Mm]ix" "in 										{return set_ant(ACTION);}
[Cc]ool{S}											{return solve_vj(DUAL_VJ);}
[Ll]et{S}											{return set_ant(ACTION);}
[Pp]our{S}											{return set_ant(ACTION);}
[Bb]oil{S}											{return solve_vn(DUAL_VN);}
[Hh]eat{S}(" "[0-9])?								{return solve_vn(DUAL_VN_HEAT);}
[Ss]immer{S}										{return set_ant(ACTION);}
[Ss]tand{S}											{return set_ant(ACTION);}
[Cc]ut{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]pread{S}										{return set_ant(ACTION);}
[Ww]hisk{S}(" "[0-9])?								{return solve_vn(DUAL_VN_TOOL);}
[Rr]educe{S}										{return set_ant(ACTION);}
[Bb]eat{S}											{return set_ant(ACTION);}
[Dd]rain{S}											{return set_ant(ACTION);}
[Cc]ombine{S}										{return set_ant(ACTION);}
[Tt]oss{S}											{return set_ant(ACTION);}
[Cc]hill{S}											{return set_ant(ACTION);}
[Rr]efrigerate{S}									{return set_ant(ACTION);}
[Aa]rrange{S}										{return set_ant(ACTION);}
[Ss]poon{S}(" "[0-9])?								{return solve_vn(DUAL_VN_TOOL);}
[Tt]aste{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Tt]urn{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Kk]eep{S}											{return set_ant(ACTION);}
[Ss]eason{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Mm]elt{S}											{return set_ant(ACTION);}
[Bb]lend{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]ack 											{return set_ant(CONTAINER);}
[Dd]o{S}											{return set_ant(ACTION);}
[Tt]op{S}(" "[0-9])?								{return solve_vn(DUAL_VNR);}
[Dd]ivide{S}										{return set_ant(ACTION);}
[Rr]eturn{S}										{return set_ant(ACTION);}
[Bb]rush{S}(" "[0-9])?								{return solve_vn(DUAL_VN_TOOL);}
[Ff]old{S}											{return set_ant(ACTION);}
[Ss]et{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Pp]ut{S}											{return set_ant(ACTION);}
[Rr]oast{S}											{return set_ant(ACTION);}
[Cc]ontinue{S}										{return set_ant(ACTION);}
[Ss]auté{S}(" "[0-9])?								{return solve_vn(DUAL_VNJ);}
[Ll]ine{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]oll{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Pp]ress{S}											{return set_ant(ACTION);}
[Gg]arnish{S}										{return set_ant(ACTION);}
[Mm]ake{S}											{return set_ant(ACTION);}
[Dd]iscard{S}										{return set_ant(ACTION);}
[Ff]orm{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]epeat{S}										{return set_ant(ACTION);}
[Ss]ift{S}											{return set_ant(ACTION);}
[Ww]rap{S}											{return set_ant(ACTION);}
[Rr]ub{S}											{return set_ant(ACTION);}
[Rr]un{S}											{return set_ant(ACTION);}
[Ll]oosen{S}										{return set_ant(ACTION);}
[Ii]ncrease{S}										{return set_ant(ACTION);}
[Dd]rizzle{S}										{return set_ant(ACTION);}
[Rr]eserve{S}										{return set_ant(ACTION);}
[Pp]repare{S}										{return set_ant(ACTION);}
[Ss]often{S}										{return set_ant(ACTION);}
[Pp]eel{S}											{return solve_vn(DUAL_VN);}
[Gg]rill{S}											{return set_ant(ACTION);}
[Hh]old{S}											{return set_ant(ACTION);}
[Bb]egin{S}											{return set_ant(ACTION);}
[Pp]late{S}(" "[0-9])?								{return solve_vn(DUAL_VN_CONTAINER);}
[Ff]ill{S}											{return set_ant(ACTION);}

[Ss]tore{S}											{return set_ant(ACTION);}
[Tt]rim{S}											{return set_ant(ACTION);}
[Uu]ncover{S}										{return set_ant(ACTION);}
[Bb]ite{S}											{return set_ant(ACTION);}
[Cc]hop{S}											{return set_ant(ACTION);}
[Ff]reeze{S}										{return set_ant(ACTION);}
[Rr]ewarm{S}										{return set_ant(ACTION);}
[Hh]ave												{return set_ant(ACTION);}
[Uu]se{S}											{return set_ant(ACTION);}
[Ss]lice{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]train{S}										{return set_ant(ACTION);}
[Ss]pra(y|ies)										{return set_ant(ACTION);}
[Ii]nvert{S}										{return set_ant(ACTION);}
[Dd]rop{S}											{return set_ant(ACTION);}
[Ff]latten{S}										{return set_ant(ACTION);}
[Ss]eal{S}											{return set_ant(ACTION);}
[Ff]lour{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]elease{S}										{return set_ant(ACTION);}
[Ss]crape{S}										{return set_ant(ACTION);}
[Ss]queeze{S}										{return set_ant(ACTION);}
[Aa]llow{S}											{return set_ant(ACTION);}
[Rr]inse{S}											{return set_ant(ACTION);}
[Tt]ouch(es)?										{return set_ant(ACTION);}
[Gg]ather{S}										{return set_ant(ACTION);}
[Ll]ift{S}											{return set_ant(ACTION);}
[Ss]hake{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Mm]easure{S}										{return set_ant(ACTION);}
[Ff]it{S}											{return set_ant(ACTION);}
[Ss]mooth{S}										{return solve_vj(DUAL_VJ);}
[Pp]uree{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]oak{S}											{return set_ant(ACTION);}
[Cc]ome{S}(" in"|" out")?							{return set_ant(ACTION);}
[Mm]aintain{S}										{return set_ant(ACTION);}
[Pp]revent{S}										{return set_ant(ACTION);}
[Tt]ent{S}											{return set_ant(ACTION);}
[Ss]coop{S}											{return set_ant(ACTION);}
[Bb]utter{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Gg]ive{S}											{return set_ant(ACTION);}
[Gg]rind{S}											{return set_ant(ACTION);}
[Pp]ull{S}											{return set_ant(ACTION);}
[Ll]eave{S}											{return set_ant(ACTION);}
[Rr]ise{S}											{return set_ant(ACTION);}
[Gg]rease{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Pp]urée{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Pp]ush{S}											{return set_ant(ACTION);}
[Oo]il{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]eheat{S}										{return set_ant(ACTION);}
[Ss]alt{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Pp]epper{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Tt]ie{S}											{return set_ant(ACTION);}
[Aa]dhere{S}										{return set_ant(ACTION);}
[Mm]arinate{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Bb]reak{S}											{return set_ant(ACTION);}
[Dd]ip{S}											{return set_ant(ACTION);}
[Mm]ash{S}											{return set_ant(ACTION);}
[Dd]redge{S}										{return set_ant(ACTION);}
[Pp]rocess{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Pp]ipe{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Cc]rimp{S}											{return set_ant(ACTION);}
[Ss]lide{S}											{return set_ant(ACTION);}
[Aa]ppear{S}										{return set_ant(ACTION);}
[Tt]hin{S}											{return solve_vj(DUAL_VJ);}
[Cc]ake{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ww]ork{S}											{return set_ant(ACTION);}
[Ss]hape{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Cc]oat{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Dd]ry												{return solve_vj(DUAL_VJ);}
[Dd]ries 											{return set_ant(ACTION);}
[Pp]ulse{S}											{return set_ant(ACTION);}
[Mm]oisten{S}										{return set_ant(ACTION);}
[Dd]issolve{S}										{return set_ant(ACTION);}
[Ss]top{S}											{return set_ant(ACTION);}
[Tt]oast{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Oo]pen{S}											{return solve_vj(DUAL_VJ);}
[Ss]eam{S}											{return set_ant(ACTION);}
[Ss]tart{S}											{return set_ant(ACTION);}
[Tt]hicken{S}										{return set_ant(ACTION);}
[Ee]nclose{S}										{return set_ant(ACTION);}
[Cc]lean{S}											{return solve_vj(DUAL_VJ);}
[Ff]r(y|ies)											{return set_ant(ACTION);}
[Cc]rack{S}											{return set_ant(ACTION);}
[Dd]rip{S}											{return set_ant(ACTION);}
[Aa]djust{S}										{return set_ant(ACTION);}
[Kk]nead{S}											{return set_ant(ACTION);}
[Pp]rick{S}											{return set_ant(ACTION);}
[Pp]ierce{S}										{return set_ant(ACTION);}
[Ww]ant{S}											{return set_ant(ACTION);}
[Ll]ook{S}											{return set_ant(ACTION);}
[Mm]oderate{S}										{return set_ant(ACTION);}
[Ss]tick{S}(" "[0-9])?								{return solve_vn(DUAL_VN_TOOL);}
[Ll]ighten{S}										{return set_ant(ACTION);}
[Hh]andle{S}										{return set_ant(ACTION);}
[Gg]laze{S}											{return set_ant(ACTION);}
[Bb]urn{S}											{return set_ant(ACTION);}
[Tt]ake{S}											{return set_ant(ACTION);}
[Hh]elp{S}											{return set_ant(ACTION);}
[Rr]each(es)?										{return set_ant(ACTION);}
[Ss]team{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]wirl{S}											{return solve_vn(DUAL_VN);}
[Ss]catter{S}										{return set_ant(ACTION);}
[Ss]ee{S}											{return set_ant(ACTION);}
[Bb]aste{S}											{return set_ant(ACTION);}
[Pp]ass{S}											{return set_ant(ACTION);}
[Ww]ash{S}											{return set_ant(ACTION);}
[Ww]ipe{S}											{return set_ant(ACTION);}
[Ll]ower{S}											{return DUAL_VR;}
[Ss]urround{S}										{return set_ant(ACTION);}
[Bb]ubble{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Aa]void{S}											{return set_ant(ACTION);}
[Cc]rush{S}											{return set_ant(ACTION);}
[Ww]arm{S}											{return solve_vj(DUAL_VJ);}
[Ll]ike{S}											{return set_ant(ACTION);}
[Pp]osition{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Dd]ot{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Bb]raise{S}										{return set_ant(ACTION);}
[Rr]est{S}											{return set_ant(ACTION);}
[Pp]at{S}											{return set_ant(ACTION);}
[Ss]ide{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]kim{S}											{return set_ant(ACTION);}
[Ss]ear{S}											{return set_ant(ACTION);}
[Tt]ap{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Dd]istribute{S}									{return set_ant(ACTION);}
[Mm]ove{S}											{return set_ant(ACTION);}
[Ii]ncorporate{S}									{return set_ant(ACTION);}
[Bb]ecome{S}										{return set_ant(ACTION);}
[Ss]it{S}											{return set_ant(ACTION);}
[Cc]rumble{S}										{return set_ant(ACTION);}
[Ww]ish{S}											{return set_ant(ACTION);}
[Ss]eparate{S}										{return set_ant(ACTION);}
[Hh]alve{S}											{return set_ant(ACTION);}
[Rr]emain{S}										{return set_ant(ACTION);}
[Tt]ilt{S}											{return set_ant(ACTION);}
[Ii]nsert{S}										{return set_ant(ACTION);}
[Pp]aste{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Gg]et{S}											{return set_ant(ACTION);}
[Bb]urst{S}											{return set_ant(ACTION);}
[Ff]lip{S}											{return set_ant(ACTION);}
[Dd]eglaze{S}										{return set_ant(ACTION);}
[Ll]ayer{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Gg]rate{S}											{return set_ant(ACTION);}
[Ss]moke{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Cc]atch(es)?										{return set_ant(ACTION);}
[Cc]heck{S}											{return set_ant(ACTION);}
[Rr]eplace{S}										{return set_ant(ACTION);}
[Ee]xtract{S}										{return set_ant(ACTION);}
[Ff]orce{S}											{return set_ant(ACTION);}
[Oo]verbeat{S}										{return set_ant(ACTION);}
[Ww]ilt{S}											{return set_ant(ACTION);}
[Nn]eed{S}											{return set_ant(ACTION);}
[Ss]core{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ff]all{S}											{return set_ant(ACTION);}
[Qq]uarter{S}										{return DUAL_VC;}
[Tt]ear{S}											{return set_ant(ACTION);}
[Oo]verlap{S}										{return set_ant(ACTION);}
[Aa]ssemble{S}										{return set_ant(ACTION);}
[Cc]lose{S}											{return solve_vjr(DUAL_VJR);}
[Ss]tack{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ff]eel{S}											{return set_ant(ACTION);}
[Cc]hicken{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]tew{S}											{return set_ant(ACTION);}
[Rr]otate{S}										{return set_ant(ACTION);}
[Pp]op{S}											{return set_ant(ACTION);}
[Ss]ubmerge{S}										{return set_ant(ACTION);}
[Aa]bsorb{S}										{return set_ant(ACTION);}
[Ff]oam{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Mm]icrowave{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Hh]arden{S}										{return set_ant(ACTION);}
[Hh]ang{S}											{return set_ant(ACTION);}
[Ff]rost{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Cc]risp{S}											{return set_ant(ACTION);}
[Pp]ack{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Dd]ollop{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Cc]ream{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Tt]hread{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]nap{S}											{return set_ant(ACTION);}
[Cc]reate{S}										{return set_ant(ACTION);}
[Ss]ettle{S}										{return set_ant(ACTION);}
[Pp]unch(es)?										{return set_ant(ACTION);}
[Cc]ompact{S}										{return solve_vj(DUAL_VJ);}
[Ff]at{S}(" "[0-9])?								{return solve_vn(DUAL_VNJ);}
[Ss]plit{S}											{return set_ant(ACTION);}
[Uu]nfold{S}										{return set_ant(ACTION);}
[Ll]a(y|ies)											{return set_ant(ACTION);}
[Ee]at{S}											{return set_ant(ACTION);}
[Ww]orr(y|ies)											{return set_ant(ACTION);}
[Ee]scape{S}										{return set_ant(ACTION);}
[Dd]ice{S}											{return set_ant(ACTION);}
[Cc]arve{S}											{return set_ant(ACTION);}
[Dd]raw{S}											{return set_ant(ACTION);}
[Aa]ttach(es)?										{return set_ant(ACTION);}
[Rr]aise{S}											{return set_ant(ACTION);}
[Ff]ind{S}											{return set_ant(ACTION);}
[Ss]ubstitute{S}									{return set_ant(ACTION);}
[Ss]ubside{S} 										{return set_ant(ACTION);}
[Oo]verbake{S}										{return set_ant(ACTION);}
[Dd]ump{S}											{return set_ant(ACTION);}
[Cc]urdle{S}										{return set_ant(ACTION);}
[Ww]ear{S}											{return set_ant(ACTION);}
[Ss]mear{S}											{return set_ant(ACTION);}
[Mm]ince{S}											{return set_ant(ACTION);}
[Ww]hip{S}											{return set_ant(ACTION);}
[Ss]traddle{S}										{return set_ant(ACTION);}
[Cc]rust{S}											{return set_ant(ACTION);}
[Ss]eem{S}											{return set_ant(ACTION);}
[Cc]aramelize{S}									{return set_ant(ACTION);}
[Dd]ecorate{S}										{return set_ant(ACTION);}
[Mm]ark{S}											{return set_ant(ACTION);}
[Ff]inish(es)?										{return set_ant(ACTION);}
[Dd]ust{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Pp]oke{S}											{return set_ant(ACTION);}
[Tt]est{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]platter{S}										{return set_ant(ACTION);}
[Ee]liminate{S}										{return set_ant(ACTION);}
[Aa]lternate{S}										{return set_ant(ACTION);}
[Ff]loat{S}											{return set_ant(ACTION);}
[Yy]ield{S}											{return set_ant(ACTION);}
[Vv]ar(y|ies)											{return set_ant(ACTION);}
[Cc]oncentrate{S}									{return set_ant(ACTION);}
[Ss]witch(es)?										{return set_ant(ACTION);}
[Pp]inch(es)?(" "[0-9])?							{return solve_vn(DUAL_VN);}
[Dd]evelop{S}										{return set_ant(ACTION);}
[Uu]nroll{S}										{return set_ant(ACTION);}
[Uu]nmold{S}										{return set_ant(ACTION);}
[Ss]hrink{S}										{return set_ant(ACTION);}
[Ff]ollow{S}										{return set_ant(ACTION);}
[Cc]lump{S}											{return set_ant(ACTION);}
[Dd]owel{S}											{return set_ant(ACTION);}
[Ss]ecure{S}										{return solve_vj(DUAL_VJ);}
[Dd]eflate{S}										{return set_ant(ACTION);}
[Oo]mit{S}											{return set_ant(ACTION);}
[Tt]r(y|ies)											{return set_ant(ACTION);}
[Tt]wist{S}											{return set_ant(ACTION);}
[Ss]nip{S}											{return set_ant(ACTION);}
[Ss]cant{S}											{return set_ant(ACTION);}
[Ll]ock{S}											{return set_ant(ACTION);}
[Ss]patter{S}										{return set_ant(ACTION);}
[Gg]o{S}											{return set_ant(ACTION);}
[Ww]ait{S}											{return set_ant(ACTION);}
[Ff]low{S}											{return set_ant(ACTION);}
[Rr]esemble{S}										{return set_ant(ACTION);}
[Uu]nwrap{S}										{return set_ant(ACTION);}
[Ss]lip{S}											{return set_ant(ACTION);}
[Pp]refer{S}										{return set_ant(ACTION);}
[Ee]njo(y|ies)											{return set_ant(ACTION);}
[Ss]ieve{S}(" "[0-9])?								{return solve_vn(DUAL_VN_TOOL);}
[Dd]efrost{S}										{return set_ant(ACTION);}
[Dd]rape{S}											{return set_ant(ACTION);}
[Ee]vaporate{S}										{return set_ant(ACTION);}
[Oo]verwork{S}										{return set_ant(ACTION);}
[Ss]ound{S}											{return set_ant(ACTION);}
[Tt]haw{S}											{return set_ant(ACTION);}
[Ee]xtend{S}										{return set_ant(ACTION);}
[Pp]uff{S}											{return set_ant(ACTION);}
[Ss]quash{S}										{return set_ant(ACTION);}
[Mm]eld{S}											{return set_ant(ACTION);}
[Ss]ta(y|ies)											{return set_ant(ACTION);}
[Ss]lather{S}										{return set_ant(ACTION);}
[Rr]ewhisk{S}										{return set_ant(ACTION);}
[Aa]ccommodate{S}									{return set_ant(ACTION);}
[Bb]end{S}											{return set_ant(ACTION);}
[Oo]verhang{S}										{return solve_vn(DUAL_VN);}
[Bb]ind{S}											{return set_ant(ACTION);}
[Ss]ink{S}											{return set_ant(ACTION);}
[Hh]ack{S}											{return set_ant(ACTION);}
[Cc]hile{S}											{return set_ant(ACTION);}
[Ss]corch(es)?										{return set_ant(ACTION);}
[Pp]roceed{S}										{return set_ant(ACTION);}
[Aa]ppl(y|ies)											{return set_ant(ACTION);}
[Pp]roduce{S}										{return set_ant(ACTION);}
[Rr]eassemble{S}									{return set_ant(ACTION);}
[Cc]hange{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]tem{S}											{return set_ant(ACTION);}
[Pp]ile{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Mm]ound{S}											{return set_ant(ACTION);}
[Dd]ecrease{S}										{return set_ant(ACTION);}
[Ee]xpose{S}										{return set_ant(ACTION);}
[Ee]nsure{S}										{return set_ant(ACTION);}
[Rr]einforce{S}										{return set_ant(ACTION);}
[Aa]lign{S}											{return set_ant(ACTION);}
[Rr]elish{S}										{return set_ant(ACTION);}
[Cc]enter{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ee]xpand{S}										{return set_ant(ACTION);}
[Rr]ound{S}											{return solve_vn(DUAL_VNJ);}
[Ss]tiffen{S}										{return set_ant(ACTION);}
[Bb]uild{S}											{return set_ant(ACTION);}
[Ll]evel{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Mm]eet{S}											{return set_ant(ACTION);}
[Tt]russ{S}											{return set_ant(ACTION);}
[Rr]esult{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Uu]nderstand{S}									{return set_ant(ACTION);}
[Rr]edistribute{S}									{return set_ant(ACTION);}
[Dd]eserve{S}										{return set_ant(ACTION);}
[Aa]erate{S}										{return set_ant(ACTION);}
[Ww]hack{S}											{return set_ant(ACTION);}
[Cc]ling{S}											{return set_ant(ACTION);}
[Cc]rosshatch(es)?									{return set_ant(ACTION);}
[Ii]nfuse{S}										{return set_ant(ACTION);}
[Dd]irect{S}										{return solve_vj(DUAL_VJ);}
[Ss]upport{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]pill{S}											{return set_ant(ACTION);}
[Pp]ureé{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Cc]orrect{S}										{return solve_vj(DUAL_VJ);}
[Ss]patchcock{S}									{return set_ant(ACTION);}
[Ss]pla(y|ies)											{return set_ant(ACTION);}
[Hh]ear{S}											{return set_ant(ACTION);}
[Gg]ratin{S}										{return set_ant(ACTION);}
[Hh]ollow{S}										{return solve_vj(DUAL_VJ);}
[Rr]ecoat{S}										{return set_ant(ACTION);}
[Ss]weat{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]emind{S}										{return set_ant(ACTION);}
[Ee]rupt{S}											{return set_ant(ACTION);}
[Aa]stound{S}										{return set_ant(ACTION);}
[Oo]verwhelm{S}										{return set_ant(ACTION);}
[Ee]nrich(es)?										{return set_ant(ACTION);}
[Pp]resent{S}										{return set_ant(ACTION);}
[Ll]ove{S}											{return set_ant(ACTION);}
[Tt]hink{S}											{return set_ant(ACTION);}
[Cc]lear{S}											{return solve_vj(DUAL_VJ);}
[Ss]wim{S}											{return set_ant(ACTION);}
[Dd]ig{S}											{return set_ant(ACTION);}
[Tt]hrow{S}											{return set_ant(ACTION);}
[Kk]now{S}											{return set_ant(ACTION);}
[Ss]a(y|ies)											{return set_ant(ACTION);}
[Dd]issipate{S}										{return set_ant(ACTION);}
[Dd]ome{S}											{return set_ant(ACTION);}
[Oo]rder{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Hh]ull{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ii]ce{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ll]end{S}											{return set_ant(ACTION);}
[Rr]ead{S}											{return set_ant(ACTION);}
[Rr]ebond{S}										{return set_ant(ACTION);}
[Rr]eact{S}											{return set_ant(ACTION);}
[Cc]oagulate{S}										{return set_ant(ACTION);}
[Pp]oach(es)?										{return set_ant(ACTION);}
[Oo]verblend{S}										{return set_ant(ACTION);}
[Rr]ender{S}										{return set_ant(ACTION);}
[Ee]ncircle{S}										{return set_ant(ACTION);}
[Rr]eroll{S}										{return set_ant(ACTION);}
[Cc]all{S}											{return set_ant(ACTION);}
[Pp]lunge{S}										{return set_ant(ACTION);}
[Rr]im{S}											{return set_ant(ACTION);}
[Dd]evein{S}										{return set_ant(ACTION);}
[Hh]eap{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Tt]ighten{S}										{return set_ant(ACTION);}
[Dd]isturb{S}										{return set_ant(ACTION);}
[Pp]addle{S}										{return set_ant(ACTION);}
[Uu]ndercook{S}										{return set_ant(ACTION);}
[Ii]gnite{S}										{return set_ant(ACTION);}
[Rr]eattach(es)?									{return set_ant(ACTION);}
[Ss]autè{S}(" "[0-9])?								{return solve_vn(DUAL_VNJ);}
[Ww]ring{S}											{return set_ant(ACTION);}
[Aa]ffect{S}										{return set_ant(ACTION);}
[Dd]amp{S}											{return solve_vj(DUAL_VJ);}
[Gg]ill{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]traighten{S}									{return set_ant(ACTION);}
[Bb]u(y|ies)											{return set_ant(ACTION);}
[Mm]ind{S}											{return set_ant(ACTION);}
[Tt]end{S}											{return set_ant(ACTION);}
[Dd]iscolor{S}										{return set_ant(ACTION);}
[Rr]igate{S}										{return set_ant(ACTION);}
[Uu]nderbeat{S}										{return set_ant(ACTION);}
[Tt]uck{S}											{return set_ant(ACTION);}
[Rr]eshape{S}										{return set_ant(ACTION);}
[Ll]ie{S}											{return set_ant(ACTION);}
[Ss]trip{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]egister{S}										{return set_ant(ACTION);}
[Ee]nd{S}											{return set_ant(ACTION);}
[Dd]unk{S}											{return set_ant(ACTION);}
[Ss]marten{S}										{return set_ant(ACTION);}
[Ww]alk{S}											{return set_ant(ACTION);}
[Aa]flame{S}										{return solve_vj(DUAL_VJ);}
[Dd]ie{S}											{return set_ant(ACTION);}
[Cc]ross{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]eposition{S}									{return set_ant(ACTION);}
[Tt]race{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]uperfine{S}										{return solve_vj(DUAL_VJ);}
[Ss]tain{S}											{return set_ant(ACTION);}
[Ss]plash{S}										{return set_ant(ACTION);}
[Pp]ick{S}											{return set_ant(ACTION);}
[Ee]xpel{S}											{return set_ant(ACTION);}
[Ss]eperate{S}										{return set_ant(ACTION);}
[Dd]istort{S}										{return set_ant(ACTION);}
[Pp]roof{S}											{return set_ant(ACTION);}
[Rr]elax(es)?										{return set_ant(ACTION);}
[Tt]oughen{S}										{return set_ant(ACTION);}
[Ff]acilitate{S}									{return set_ant(ACTION);}
[Ff]roth{S}											{return set_ant(ACTION);}
[Bb]roil{S}											{return set_ant(ACTION);}
[Dd]ouble{S}										{return solve_vj(DUAL_VJ);}
[Bb]lanch(es)?										{return set_ant(ACTION);}
[Tt]emper{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]ave{S}											{return set_ant(ACTION);}
[Ss]well{S}											{return set_ant(ACTION);}
[Ww]atch(es)?										{return set_ant(ACTION);}
[Cc]harcoal{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Hh]ead{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ff]oil{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]have{S}											{return set_ant(ACTION);}
[Ff]eeze{S}											{return set_ant(ACTION);}
[Ff]orget{S}										{return set_ant(ACTION);}
[Mm]oist{S}											{return solve_vj(DUAL_VJ);}
[Oo]verprocess{S}									{return set_ant(ACTION);}
[Pp]it{S}											{return set_ant(ACTION);}
[Rr]epat{S}											{return set_ant(ACTION);}
[Ll]ade{S}											{return set_ant(ACTION);}
[Vv]ent{S}											{return set_ant(ACTION);}
[Ii]mmerse{S}										{return set_ant(ACTION);}
[Rr]estir{S}										{return set_ant(ACTION);}
[Aa]ccompan(y|ies)										{return set_ant(ACTION);}
[Zz]est{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Rr]everse{S}										{return set_ant(ACTION);}
[Cc]ollapse{S}										{return set_ant(ACTION);}
[Aa]chieve{S}										{return set_ant(ACTION);}
[Cc]lip{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Aa]nchor{S}										{return set_ant(ACTION);}
[Rr]emember{S}										{return set_ant(ACTION);}
[Ee]xceed{S}										{return set_ant(ACTION);}
[Ll]ean{S}											{return set_ant(ACTION);}
[Cc]arr(y|ies)											{return set_ant(ACTION);}
[Ff]ree{S}											{return solve_vj(DUAL_VJ);}
[Cc]url{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Cc]har{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ww]aste{S}(" "[0-9])?								{return solve_vn(DUAL_VN);}
[Ss]aute{S}											{return solve_vj(DUAL_VJ);}
[Ss]tretch(es)?										{return set_ant(ACTION);}
[Ww]rinkle{S}										{return set_ant(ACTION);}
[Ii]nclude{S}										{return set_ant(ACTION);}


[Ii]ncluding((" to")|{COMMA})? 										{return solve_gerund(GERUND);}
[Aa]dding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]tirring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]ransfering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]overing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]ooking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]reheating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]eing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]prinkling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]erving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]ringing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]emoving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]aking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]lacing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]ixing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]ooling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]eting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ouring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]oiling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]eating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]immering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]tanding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]utting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]preading((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]hisking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]educing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]eating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]raining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]ombining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]ossing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]hilling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]efrigerating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]rranging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]pooning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]asting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]urning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Kk]eeping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]easoning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]elting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]lending((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]acking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]oing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]oping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]ividing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eturning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]rushing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]olding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]eting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]uting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]oasting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]ontinuing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]autéing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]ining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]olling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ressing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]arnishing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]aking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]iscarding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]orming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]epeating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ifting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]raping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]ubing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]uning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]oosening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ii]ncreasing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]rizzling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eserving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]reparing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]oftening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]eeling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]rilling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]olding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]eginning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]lating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]illing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]aucing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]toring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]riming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]ncovering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]iting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]hoping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]reezing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]ewarming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]aving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]sing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]licing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]training((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]praying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ii]nverting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]roping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]lattening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ealing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]louring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eleasing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]craping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]queezing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]llowing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]insing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]ouching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]athering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]ifting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]haking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]easuring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]iting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]moothing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ureing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]oaking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]oming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]aintaining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]reventing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]enting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]cooping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]uttering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]iving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]rinding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ulling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]eaving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]ising((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]reasing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]uréing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ushing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]iling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eheating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]alting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]iing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]dhering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]arinating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]reaking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]iping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]ashing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]redging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]rocessing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]iping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]rimping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]liding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]ppearing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]hining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]aking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]orking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]haping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]oating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]rying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ulsing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]oistening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]issolving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]toping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]oasting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]pening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]eaming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]tarting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]hickening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]nclosing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]leaning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]rying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]racking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]riping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]djusting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Kk]neading((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ricking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]iercing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]anting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]ooking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]oderating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ticking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]ightening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]andling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]lazing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]urning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]aking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]elping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eaching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]teaming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]wirling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]cattering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]eing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]asting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]assing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]ashing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]iping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]owering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]urrounding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]ubbling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]voiding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]rushing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]arming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]iking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ositioning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]oting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]raising((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]esting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]iding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]kiming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]earing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]aping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]istributing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]oving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ii]ncorporating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]ecoming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]iting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]rumbling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]ishing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]eparating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]alving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]emaining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]ilting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ii]nserting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]asting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]eting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]ursting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]liping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]eglazing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]ayering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]rating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]moking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]atching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]hecking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eplacing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]xtracting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]orcing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]verbeating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]ilting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Nn]eeding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]coring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]alling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Qq]uartering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]earing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]verlaping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]ssembling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]losing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]tacking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]eppering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]eeling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]hickening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]tewing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]otating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]oping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ubmerging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]bsorbing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]oaming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]icrowaving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]ardening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]anging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]risping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]acking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]olloping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]reaming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]hreading((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]naping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]reating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ettling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]unching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]ompacting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]ating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]pliting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]nfolding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]aying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]ating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]orrying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]scaping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]icing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]arving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]rawing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]ttaching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]aising((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]inding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ubstituting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]verbaking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]umping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]urdling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]earing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]mearing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]incing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]hipping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]traddling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]rusting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]eeming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]aramelizing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]ecorating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]arking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]inishing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]usting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]oking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]esting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]plattering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]liminating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]lternating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]loating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Yy]ielding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Vv]arying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]oncentrating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]witching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]inching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]eveloping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]nrolling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]nmolding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]hrinking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]ollowing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]lumping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]oweling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ecuring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]eflating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]miting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]rying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]wisting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]niping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]canting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]ocking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]pattering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]oing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]aiting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]lowing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]esembling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]nwraping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]liping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]refering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]njoying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ieving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]efrosting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]raping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]vaporating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]verworking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]ounding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]hawing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]xtending((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]uffing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]quashing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]elding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]taying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]lathering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]ewhisking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]ccommodating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]ending((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]verhanging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]inding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]inking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]acking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]hiling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]corching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]roceeding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]pplying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]roducing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eassembling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]hanging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]teming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]iling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]ounding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]ecreasing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]xposing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]nsuring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]einforcing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]ligning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]elishing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]entering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]xpanding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]ounding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]tiffening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]uilding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]eveling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]eeting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]russing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]esulting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]nderstanding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]edistributing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]eserving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]erating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]hacking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]linging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]rosshatching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ii]nfusing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]irecting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]upporting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]pilling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]ureéing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]orrecting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]patchcocking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]playing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]earing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]ratining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]ollowing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]ecoating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]weating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eminding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]rupting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]stounding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]verwhelming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]nriching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]resenting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]oving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]hinking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]learing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]wiming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]iging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]hrowing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Kk]nowing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]aying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]issipating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]oming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]rdering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]ulling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]ending((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eading((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]ebonding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eacting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]oagulating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]oaching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]verblending((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]endering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]ncircling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]erolling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]alling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]lunging((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]iming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]eveining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]eaping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]ightening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]isturbing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]addling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]ndercooking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ii]gniting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eattaching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]autèing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]ringing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]ffecting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]amping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Gg]illing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]traightening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]uying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]inding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]ending((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]iscoloring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]igating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Uu]nderbeating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]ucking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eshaping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]iing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]triping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]egistering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]nding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]unking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]martening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]alking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]flaming((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]iing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]rossing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]epositioning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]racing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]uperfining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]taining((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]plashing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]icking((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]xpeling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]eperating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]istorting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]roofing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]elaxing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]oughening((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]acilitating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]rothing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]roiling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Dd]oubling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Bb]lanching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Tt]empering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]aving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]welling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]atching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]harcoaling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Hh]eading((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]oiling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]having((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]eezing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]orgeting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Mm]oisting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Oo]verprocessing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Pp]iting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]epating((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]ading((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Vv]enting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ii]mmersing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]estirring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]ccompanying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Zz]esting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]eversing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]ollapsing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]chieving((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]liping((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Aa]nchoring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Rr]emembering((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ee]xceeding((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ll]eaning((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]arrying((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ff]reing((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]urling((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Cc]haring((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]asting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]auting((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ss]tretching((" to")|{COMMA})?									{return solve_gerund(GERUND);}
[Ww]rinkling((" to")|{COMMA})?									{return solve_gerund(GERUND);}

[Dd]one 											{return solve_jj(JJ);}
[Ll]arge   											{return solve_jj(JJ);}
[Mm]edium   										{return solve_jj(JJ);}
[Hh]eavy   											{return solve_jj(JJ);}
[Hh]igh   											{return solve_jj(DUAL_JR);}
[Ss]mall   											{return solve_jj(JJ);}
[Tt]ender   										{return solve_jj(JJ);}
[Gg]olden   										{return solve_jj(JJ);}
[Ll]ow   											{return solve_jj(DUAL_JR);}
[Hh]ot   											{return solve_jj(JJ);}
[Bb]rown   											{return solve_vj(DUAL_VJ);}
[Ee]lectric   										{return solve_jj(JJ);}
[Tt]hick   											{return solve_jj(JJ);}
[Pp]repared   										{return solve_jj(JJ);}
[Cc]old   											{return solve_jj(JJ);}
[Ss]ame   											{return solve_jj(JJ);}
[Ss]oft   											{return solve_jj(JJ);}
[Ff]irst   											{return solve_jj(JJ);}
[Pp]lastic   										{return solve_jj(JJ);}
[Gg]reen   											{return solve_jj(JJ);}
[Rr]ed   											{return solve_jj(JJ);}
[Ss]lotted   										{return solve_jj(JJ);}
[Ff]irm   											{return solve_jj(JJ);}
[Ss]hallow   										{return solve_jj(JJ);}
[Ss]our   											{return solve_jj(JJ);}
[Ff]luffy   										{return solve_jj(JJ);}
[Mm]elted   										{return solve_jj(JJ);}
[Ww]hite   											{return solve_jj(JJ);}
[Dd]eep   											{return solve_jj(DUAL_JR);}
[Rr]eserved   										{return solve_jj(JJ);}
[Rr]immed   										{return solve_jj(JJ);}
[Aa]vailable   										{return solve_jj(JJ);}
[Nn]ecessary   										{return solve_jj(JJ);}
[Pp]ale   											{return solve_jj(JJ);}
[Cc]oarse   										{return solve_jj(JJ);}
[Bb]lended   										{return solve_jj(JJ);}
[Aa]dditional   									{return solve_jj(JJ);}
[Ss]harp   											{return solve_jj(JJ);}
[Ee]xcess   										{return solve_jj(JJ);}
[Ss]econd   										{return solve_jj(JJ);}
[Nn]ext   											{return solve_jj(JJ);}
[Tt]otal   											{return solve_jj(JJ);}
[Ww]ide   											{return solve_jj(JJ);}
[Nn]onsticky   										{return solve_jj(JJ);}
[Ss]ingle   										{return solve_jj(JJ);}
[Gg]rilled   										{return solve_jj(JJ);}
[Bb]lack   											{return solve_jj(JJ);}
[Ll]ong   											{return solve_jj(JJ);}
[Ss]tiff   											{return solve_jj(JJ);}
[Rr]efrigerated   									{return solve_jj(JJ);}
[Ww]ooden   										{return solve_jj(JJ);}
[Ff]resh   											{return solve_jj(JJ);}
[Ff]ragrant   										{return solve_jj(JJ);}
[Oo]venproof   										{return solve_jj(JJ);}
[Pp]owdered   										{return solve_jj(JJ);}
[Ff]lat   											{return solve_jj(DUAL_JR);}
[Rr]are   											{return solve_jj(JJ);}
[Ll]iquid   										{return solve_jj(JJ);}
[Ll]ight   											{return solve_jj(JJ);}
[Uu]pper   											{return solve_jj(JJ);}
[Bb]rowned   										{return solve_jj(JJ);}
[Aa]irtight   										{return solve_jj(JJ);}
[Ff]ine   											{return solve_jj(JJ);}
[Ss]weet   											{return solve_jj(JJ);}
[Ff]ew   											{return solve_jj(JJ);}
[Ww]hole   											{return solve_jj(JJ);}
[Oo]ther   											{return solve_jj(JJ);}
[Ii]talian   										{return solve_jj(JJ);}
[Aa]sian   											{return solve_jj(JJ);}
[Pp]ink   											{return solve_jj(JJ);}
[Ll]ittle   										{return solve_jj(JJ);}
[Ss]hort   											{return solve_jj(JJ);}
[Cc]reamy   										{return solve_jj(JJ);}
[Ss]low   											{return solve_jj(JJ);}
[Pp]reheated   										{return solve_jj(JJ);}
[Dd]utch   											{return solve_jj(JJ);}
[Gg]enerous   										{return solve_jj(JJ);}
[Tt]ranslucent   									{return solve_jj(JJ);}
[Ff]loured   										{return solve_jj(JJ);}
[Ww]et   											{return solve_jj(JJ);}
[Uu]ncovered   										{return solve_jj(JJ);}
[Mm]ain   											{return solve_jj(JJ);}
[Rr]eady   											{return solve_jj(JJ);}
[Ss]ure   											{return solve_jj(JJ);}
[Ee]qual   											{return solve_jj(JJ);}
[Ss]ticky   										{return solve_jj(JJ);}
[Pp]lain   											{return solve_jj(JJ);}
[Rr]ounded   										{return solve_jj(JJ);}
[Cc]ooked   										{return solve_jj(JJ);}
[Ss]quare   										{return solve_jj(JJ);}
[Ff]rozen   										{return solve_jj(JJ);}
[Dd]ark   											{return solve_jj(JJ);}
[Ee]xtra   											{return solve_jj(DUAL_JR);}
[Pp]uffed   										{return solve_jj(JJ);}
[Ss]liced   										{return solve_jj(JJ);}
[Rr]emovable   										{return solve_jj(JJ);}
[Pp]ossible   										{return solve_jj(JJ);}
[Uu]ngreased   										{return solve_jj(JJ);}
[Oo]iled   											{return solve_jj(JJ);}
[Rr]esealable   									{return solve_jj(JJ);}
[Cc]ouscous   										{return solve_jj(JJ);}
[Bb]uttered   										{return solve_jj(JJ);}
[Dd]iagonal   										{return solve_jj(JJ);}
[Ll]ukewarm   										{return solve_jj(JJ);}
[Ww]axed   											{return solve_jj(JJ);}
[Nn]atural   										{return solve_jj(JJ);}
[Cc]areful   										{return solve_jj(JJ);}
[Cc]eramic   										{return solve_jj(JJ);}
[Ll]atin   											{return solve_jj(JJ);}
[Mm]oistened   										{return solve_jj(JJ);}
[Ss]preadable   									{return solve_jj(JJ);}
[Ss]alted   										{return solve_jj(JJ);}
[Gg]lossy   										{return solve_jj(JJ);}
[Pp]ourable   										{return solve_jj(JJ);}
[Bb]are   											{return solve_jj(JJ);}
[Ll]ast   											{return solve_jj(JJ);}
[Oo]pposite   										{return solve_jj(JJ);}
[Mm]ashed   										{return solve_jj(JJ);}
[Ff]ull   											{return solve_jj(JJ);}
[Ss]ealable   										{return solve_jj(JJ);}
[Rr]oasted   										{return solve_jj(JJ);}
[Kk]osher   										{return solve_jj(JJ);}
[Bb]right   										{return solve_jj(JJ);}
[Oo]paque   										{return solve_jj(JJ);}
[Cc]rushed   										{return solve_jj(JJ);}
[Cc]overed   										{return solve_jj(JJ);}
[Rr]aw   											{return solve_jj(JJ);}
[Cc]hopped   										{return solve_jj(JJ);}
[Aa]merican   										{return solve_jj(JJ);}
[Ww]ild   											{return solve_jj(JJ);}
[Rr]ight   											{return solve_jj(DUAL_JR);}
[Oo]ff 												{return set_ant(DIR);}
[Ee]ntire   										{return solve_jj(JJ);}
[Tt]hickened   										{return solve_jj(JJ);}
[Ii]ndividual   									{return solve_jj(JJ);}
[Tt]ough   											{return solve_jj(JJ);}
[Cc]oncentric   									{return solve_jj(JJ);}
[Bb]lue   											{return solve_jj(JJ);}
[Uu]nsweetened   									{return solve_jj(JJ);}
[Vv]ertical   										{return solve_jj(JJ);}
[Ii]nverted   										{return solve_jj(JJ);}
[Hh]eatproof   										{return solve_jj(JJ);}
[Dd]iced   											{return solve_jj(JJ);}
[Ss]picy   											{return solve_jj(JJ);}
[Oo]uter   											{return solve_jj(JJ);}
[Ss]quashed   										{return solve_jj(JJ);}
[Ii]nternal   										{return solve_jj(JJ);}
[Cc]anned   										{return solve_jj(JJ);}
[Mm]ixed   											{return solve_jj(JJ);}
[Ff]lameproof   									{return solve_jj(JJ);}
[Dd]ecorative   									{return solve_jj(JJ);}
[Gg]ranulated   									{return solve_jj(JJ);}
[Yy]ellow   										{return solve_jj(JJ);}
[Ii]ntact   										{return solve_jj(JJ);}
[Cc]rumbled   										{return solve_jj(JJ);}
[Ii]ncorporated   									{return solve_jj(JJ);}
[Uu]ndisturbed   									{return solve_jj(JJ);}
[Gg]ood   											{return solve_jj(JJ);}
[Nn]onreactive   									{return solve_jj(JJ);}
[Cc]ombined   										{return solve_jj(JJ);}
[Hh]eated   										{return solve_jj(JJ);}
[Ff]rench   										{return solve_jj(JJ);}
[Bb]ittersweet   									{return solve_jj(JJ);}
[Ss]tandard   										{return solve_jj(JJ);}
[Oo]val   											{return solve_jj(JJ);}
[Rr]unny   											{return solve_jj(JJ);}
[Mm]arinated   										{return solve_jj(JJ);}
[Uu]ncooked   										{return solve_jj(JJ);}
[Bb]eaten   										{return solve_jj(JJ);}
[Pp]liable   										{return solve_jj(JJ);}
[Cc]ooled   										{return solve_jj(JJ);}
[Uu]navailable   									{return solve_jj(JJ);}
[Ll]oose   											{return solve_jj(JJ);}
[Ee]lastic   										{return solve_jj(JJ);}
[Ss]oftened   										{return solve_jj(JJ);}
[Ff]rothy   										{return solve_jj(JJ);}
[Uu]nsalted   										{return solve_jj(JJ);}
[Vv]irgin   										{return solve_jj(JJ);}
[Ff]ried   											{return solve_jj(JJ);}
[Ss]hiny   											{return solve_jj(JJ);}
[Bb]aked   											{return solve_jj(JJ);}
[Ii]nner   											{return solve_jj(JJ);}
[Ww]obbly   										{return solve_jj(JJ);}
[Tt]ablespoonful   									{return solve_jj(JJ);}
[Ee]astern   										{return solve_jj(JJ);}
[Hh]ard   											{return solve_jj(DUAL_JR);}
[Rr]ectangular   									{return solve_jj(JJ);}
[Tt]iny   											{return solve_jj(JJ);}
[Cc]reamed   										{return solve_jj(JJ);}
[Ss]afe   											{return solve_jj(JJ);}
[Cc]olored   										{return solve_jj(JJ);}
[Hh]orizontal   									{return solve_jj(JJ);}
[Tt]ight   											{return solve_jj(DUAL_JR);}
[Ss]hredded   										{return solve_jj(JJ);}
[Gg]entle   										{return solve_jj(JJ);}
[Ss]pringy   										{return solve_jj(JJ);}
[Rr]egular   										{return solve_jj(JJ);}
[Nn]ew   											{return solve_jj(JJ);}
[Bb]roilerproof   									{return solve_jj(JJ);}
[Gg]rainy   										{return solve_jj(JJ);}
[Oo]nly   											{return solve_jj(DUAL_JR);}
[Oo]ptional   										{return solve_jj(JJ);}
[Dd]egreased   										{return solve_jj(JJ);}
[Aa]ssorted   										{return solve_jj(JJ);}
[Uu]nstuffed   										{return solve_jj(JJ);}
[Vv]isible   										{return solve_jj(JJ);}
[Mm]arshmallow   									{return solve_jj(JJ);}
[Mm]icrowaved   									{return solve_jj(JJ);}
[Ss]light   										{return solve_jj(JJ);}
[Ii]ndian   										{return solve_jj(JJ);}
[Ff]rosted   										{return solve_jj(JJ);}
[Rr]ustic   										{return solve_jj(JJ);}
[Ss]alty   											{return solve_jj(JJ);}
[Gg]rand   											{return solve_jj(JJ);}
[Ww]ell   											{return solve_jj(DUAL_JR);}
[Ss]olid   											{return solve_jj(JJ);}
[Hh]andheld   										{return solve_jj(JJ);}
[Gg]reek   											{return solve_jj(JJ);}
[Uu]nopened   										{return solve_jj(JJ);}
[Ee]asy   											{return solve_jj(JJ);}
[Gg]rated   										{return solve_jj(JJ);}
[Jj]uicy   											{return solve_jj(JJ);}
[Ss]aucy   											{return solve_jj(JJ);}
[Ss]teamed   										{return solve_jj(JJ);}
[Cc]racked   										{return solve_jj(JJ);}
[Ll]umpy   											{return solve_jj(JJ);}
[Gg]lowing   										{return solve_jj(JJ);}
[Ss]teep   											{return solve_jj(JJ);}
[Ss]teady   										{return solve_jj(JJ);}
[Ff]lexible   										{return solve_jj(JJ);}
[Dd]isposable   									{return solve_jj(JJ);}
[Ss]tainless   										{return solve_jj(JJ);}
[Ee]mpty   											{return solve_jj(JJ);}
[Ee]ven   											{return solve_jj(JJ);}
[Cc]rystallized   									{return solve_jj(JJ);}
[Tt]riple   										{return solve_jj(JJ);}
[Dd]elicate   										{return solve_jj(JJ);}
[Ss]imilar   										{return solve_jj(JJ);}
[Ss]ized   											{return solve_jj(JJ);}
[Qq]uick   											{return solve_jj(JJ);}
[Ss]weetened   										{return solve_jj(JJ);}
[Ss]tewed   										{return solve_jj(JJ);}
[Tt]rimmed   										{return solve_jj(JJ);}
[Ff]luted   										{return solve_jj(JJ);}
[Bb]rittle   										{return solve_jj(JJ);}
[Pp]ierced   										{return solve_jj(JJ);}
[Ii]mportant   										{return solve_jj(JJ);}
[Pp]erfect   										{return solve_jj(JJ);}
[Ii]nstant   										{return solve_jj(JJ);}
[Bb]ig   											{return solve_jj(JJ);}
[Ff]inal   											{return solve_jj(JJ);}
[Cc]rusty   										{return solve_jj(JJ);}
[Dd]ampened   										{return solve_jj(JJ);}
[Bb]raised  										{return solve_jj(JJ);}
[Cc]oated   										{return solve_jj(JJ);}
[Ss]trong   										{return solve_jj(JJ);}
[Mm]ini   											{return solve_jj(JJ);}
[Pp]rotective   									{return solve_jj(JJ);}
[Ss]yrupy   										{return solve_jj(JJ);}
[Ss]tacked   										{return solve_jj(JJ);}
[Oo]ld   											{return solve_jj(JJ);}
[Aa]romatic   										{return solve_jj(JJ);}
[Ff]orward   										{return solve_jj(JJ);}
[Gg]ray   											{return solve_jj(JJ);}
[Uu]nbaked   										{return solve_jj(JJ);}
[Cc]runchy   										{return solve_jj(JJ);}
[Oo]riginal   										{return solve_jj(JJ);}
[Ss]autéed   										{return solve_jj(JJ);}
[Ss]easoned   										{return solve_jj(JJ);}
[Ff]laky   											{return solve_jj(JJ);}
[Ss]ensitive   										{return solve_jj(JJ);}
[Cc]ircular   										{return solve_jj(JJ);}
[Mm]arked   										{return solve_jj(JJ);}
[Ss]kinned   										{return solve_jj(JJ);}
[Bb]eautiful   										{return solve_jj(JJ);}
[Nn]ice   											{return solve_jj(JJ);}
[Ff]lavorful   										{return solve_jj(JJ);}
[Aa]ble   											{return solve_jj(JJ);}
[Ss]imple   										{return solve_jj(JJ);}
[Cc]hunky   										{return solve_jj(JJ);}
[Ss]wiss   											{return solve_jj(JJ);}
[Cc]leared   										{return solve_jj(JJ);}
[Ss]emi   											{return solve_jj(JJ);}
[Bb]ottled   										{return solve_jj(JJ);}
[Dd]eglazed 										{return solve_jj(JJ);}
[Pp]revious   										{return solve_jj(JJ);}
[Uu]ntoasted   										{return solve_jj(JJ);}
[Ee]nglish   										{return solve_jj(JJ);}
[Ss]turdy   										{return solve_jj(JJ);}
[Ss]poonful   										{return solve_jj(JJ);}
[Dd]ifferent   										{return solve_jj(JJ);}
[Ww]onderful   										{return solve_jj(JJ);}
[Gg]reat   											{return solve_jj(JJ);}
[Pp]ressed   										{return solve_jj(JJ);}
[Ii]rregular   										{return solve_jj(JJ);}
[Ff]oamy   											{return solve_jj(JJ);}
[Nn]onaluminum   									{return solve_jj(JJ);}
[Ww]ilted   										{return solve_jj(JJ);}
[Rr]ich   											{return solve_jj(JJ);}
[Jj]apanese   										{return solve_jj(JJ);}
[Mm]ushy   											{return solve_jj(JJ);}
[Dd]istinctive   									{return solve_jj(JJ);}
[Ff]inished   										{return solve_jj(JJ);}
[Cc]reole   										{return solve_jj(JJ);}
[Tt]hai   											{return solve_jj(JJ);}
[Mm]iniature   										{return solve_jj(JJ);}
[Ee]mulsified   									{return solve_jj(JJ);}
[Pp]arallel   										{return solve_jj(JJ);}
[Rr]eactive   										{return solve_jj(JJ);}
[Cc]losed   										{return solve_jj(JJ);}
[Uu]nbleached   									{return solve_jj(JJ);}
[Hh]ungarian   										{return solve_jj(JJ);}
[Ss]haggy   										{return solve_jj(JJ);}
[Ss]traight   										{return solve_jj(DUAL_JR);}
[Bb]razilian   										{return solve_jj(JJ);}
[Aa]frican   										{return solve_jj(JJ);}
[Aa]djacent   										{return solve_jj(JJ);}
[Dd]ivided   										{return solve_jj(JJ);}
[Pp]uffy   											{return solve_jj(JJ);}
[Rr]eclosable   									{return solve_jj(JJ);}
[Ss]tretchy   										{return solve_jj(JJ);}
[Mm]ilky   											{return solve_jj(JJ);}
[Bb]itter   										{return solve_jj(JJ);}
[Ss]ided   											{return solve_jj(JJ);}
[Ff]luid   											{return solve_jj(JJ);}
[Nn]eat   											{return solve_jj(JJ);}
[Cc]andied   										{return solve_jj(JJ);}
[Ff]ragile   										{return solve_jj(JJ);}
[Cc]aramelized   									{return solve_jj(JJ);}
[Ee]yed   											{return solve_jj(JJ);}
[Pp]icante   										{return solve_jj(JJ);}
[Ll]eafy   											{return solve_jj(JJ);}
[Mm]ediumhigh   									{return solve_jj(JJ);}
[Mm]ediumlow   										{return solve_jj(JJ);}
[Dd]rippin   										{return solve_jj(JJ);}
[Nn]arrow   										{return solve_jj(JJ);}
[Aa]jar   											{return solve_jj(JJ);}
[Hh]alved   										{return solve_jj(JJ);}
[Dd]ressed   										{return solve_jj(JJ);}
[Dd]ifficult   										{return solve_jj(JJ);}
[Cc]omfortable   									{return solve_jj(JJ);}
[Uu]niform   										{return solve_jj(JJ);}
[Ss]ucculent   										{return solve_jj(JJ);}
[Tt]riangular   									{return solve_jj(JJ);}
[Ss]uperelegant   									{return solve_jj(JJ);}
[Ss]mashed   										{return solve_jj(JJ);}
[Rr]educed   										{return solve_jj(JJ);}
[Ff]lattened   										{return solve_jj(JJ);}
[Ll]ively   										{return solve_jj(JJ);}
[Ss]atiny   										{return solve_jj(JJ);}
[Oo]ily   											{return solve_jj(JJ);}
[Tt]rue   											{return solve_jj(JJ);}
[Ii]sraeli   										{return solve_jj(JJ);}
[Ii]ndirect   										{return solve_jj(JJ);}
[Oo]dd   											{return solve_jj(JJ);}
[Aa]leppo   										{return solve_jj(JJ);}
[Ss]yrian   										{return solve_jj(JJ);}
[Ee]arthy   										{return solve_jj(JJ);}
[Ss]ubtle   										{return solve_jj(JJ);}
[Bb]odied   										{return solve_jj(JJ);}
[Ss]cored   										{return solve_jj(JJ);}
[Bb]oned   											{return solve_jj(JJ);}
[Pp]retty   										{return solve_jj(JJ);}
[Cc]ute   											{return solve_jj(JJ);}
[Pp]retentious   									{return solve_jj(JJ);}
[Dd]elicious   										{return solve_jj(JJ);}
[Uu]nencumbered   									{return solve_jj(JJ);}
[Ll]ucky   											{return solve_jj(JJ);}
[Hh]earty   										{return solve_jj(JJ);}
[Vv]egetarian   									{return solve_jj(JJ);}
[Gg]rayish   										{return solve_jj(JJ);}
[Cc]oncentrated   									{return solve_jj(JJ);}
[Ee]venish   										{return solve_jj(JJ);}
[Bb]lunt   											{return solve_jj(JJ);}
[Tt]errific   										{return solve_jj(JJ);}
[Cc]omforting   									{return solve_jj(JJ);}
[Ii]nserted   										{return solve_jj(JJ);}
[Ee]xpandable   									{return solve_jj(JJ);}
[Uu]nadorned   										{return solve_jj(JJ);}
[Ee]vaporated   									{return solve_jj(JJ);}
[Ss]tupid   										{return solve_jj(JJ);}
[Ee]xpensive   										{return solve_jj(JJ);}
[Ww]rong   											{return solve_jj(DUAL_JR);}
[Cc]ohesive   										{return solve_jj(JJ);}
[Ff]laked   										{return solve_jj(JJ);}
[Oo]blong   										{return solve_jj(JJ);}
[Ss]pecial   										{return solve_jj(JJ);}
[Nn]oncorrodible   									{return solve_jj(JJ);}
[Uu]sual   											{return solve_jj(JJ);}
[Pp]remature   										{return solve_jj(JJ);}
[Uu]nprotected   									{return solve_jj(JJ);}
[Ss]eared   										{return solve_jj(JJ);}
[Vv]arious   										{return solve_jj(JJ);}
[Uu]npeeled   										{return solve_jj(JJ);}
[Dd]efrosted   										{return solve_jj(JJ);}
[Aa]lternative   									{return solve_jj(JJ);}
[Ss]pecific   										{return solve_jj(JJ);}
[Aa]ppealing   										{return solve_jj(JJ);}
[Pp]rofessional   									{return solve_jj(JJ);}
[Ll]ined   											{return solve_jj(JJ);}
[Pp]asty   											{return solve_jj(JJ);}
[Ff]udgy   											{return solve_jj(JJ);}
[Bb]ottomless   									{return solve_jj(JJ);}
[Ss]ilky   											{return solve_jj(JJ);}
[Aa]ssembled   										{return solve_jj(JJ);}
[Ss]tuck   											{return solve_jj(JJ);}
[Ii]nstantread   									{return solve_jj(JJ);}
[Ss]kewered   										{return solve_jj(JJ);}
[Ss]helled   										{return solve_jj(JJ);}
[Cc]urried   										{return solve_jj(JJ);}
[Pp]rebaked   										{return solve_jj(JJ);}
[Ss]altine   										{return solve_jj(JJ);}
[Jj]ulienned   										{return solve_jj(JJ);}
[Cc]ondensed   										{return solve_jj(JJ);}
[Mm]arbled   										{return solve_jj(JJ);}
[Dd]igital   										{return solve_jj(JJ);}
[Uu]ncolored   										{return solve_jj(JJ);}
[Oo]vensafe   										{return solve_jj(JJ);}
[Tt]oasty   										{return solve_jj(JJ);}
[Ff]ancy   											{return solve_jj(JJ);}
[Bb]illowy   										{return solve_jj(JJ);}
[Ss]errated   										{return solve_jj(JJ);}
[Ee]dible   										{return solve_jj(JJ);}
[Mm]exican   										{return solve_jj(JJ);}
[Tt]easpoonful   									{return solve_jj(JJ);}
[Bb]asic   											{return solve_jj(JJ);}
[Rr]esistant   										{return solve_jj(JJ);}
[Ff]ar   											{return solve_jj(DUAL_JR);}
[Ss]ecret   										{return solve_jj(DUAL_NJ);}
[Aa]dequate   										{return solve_jj(JJ);}
[Aa]cidic   										{return solve_jj(JJ);}
[Mm]etal(lic)? 										{return solve_jj(JJ);}
[Hh]oly   											{return solve_jj(JJ);}
[Ff]ront   											{return solve_jj(JJ);}
[Bb]rief   											{return solve_jj(JJ);}
[Uu]nexpected   									{return solve_jj(JJ);}
[Cc]ored   											{return solve_jj(JJ);}
[Rr]osy   											{return solve_jj(JJ);}
[Ss]tout   											{return solve_jj(JJ);}
[Pp]eppered   										{return solve_jj(JJ);}
[Aa]djustable   									{return solve_jj(JJ);}
[Cc]urved   										{return solve_jj(JJ);}
[Cc]olombian   										{return solve_jj(JJ);}
[Ii]ndonesian   									{return solve_jj(JJ);}
[Cc]anadian   										{return solve_jj(JJ);}
[Mm]oroccan   										{return solve_jj(JJ);}
[Ss]tirred   										{return solve_jj(JJ);}
[Ss]lanted   										{return solve_jj(JJ);}
[Ii]ced   											{return solve_jj(JJ);}
[Mm]anageable   									{return solve_jj(JJ);}
[Uu]nglazed   										{return solve_jj(JJ);}
[Pp]lump   											{return solve_jj(JJ);}
[Ee]xact   											{return solve_jj(JJ);}
[Rr]ough   											{return solve_jj(JJ);}
[Bb]akeware   										{return solve_jj(JJ);}
[Aa]ssertive   										{return solve_jj(JJ);}
[Tt]raditional   									{return solve_jj(JJ);}
[Mm]indful   										{return solve_jj(JJ);}
[Pp]otential   										{return solve_jj(JJ);}
[Nn]ightly   										{return solve_jj(JJ);}
[Dd]emi   											{return solve_jj(JJ);}
[Rr]oasty   										{return solve_jj(JJ);}
[Ss]poonable   										{return solve_jj(JJ);}
[Qq]uartered   										{return solve_jj(JJ);}
[Ff]rizzled   										{return solve_jj(JJ);}
[Ll]ater   											{return solve_jj(DUAL_JR);}
[Cc]hinese   										{return solve_jj(JJ);}
[Ss]emisweet   										{return solve_jj(JJ);}
[Dd]usty   											{return solve_jj(JJ);}
[Mm]ild   											{return solve_jj(JJ);}
[Ss]moked   										{return solve_jj(JJ);}
[Tt]ransparent   									{return solve_jj(JJ);}
[Rr]eversed   										{return solve_jj(JJ);}
[Rr]eddish   										{return solve_jj(JJ);}
[Dd]islodged   										{return solve_jj(JJ);}
[Ss]lippery   										{return solve_jj(JJ);}
[Ss]outhwestern   									{return solve_jj(JJ);}
[dD]irty		 									{return solve_jj(JJ);}
[uU]sed 											{return solve_jj(JJ);}
[sS]poiled 											{return solve_jj(JJ);}
[Vv]ery(" "much)?   								{return solve_jj(JJ);}
[dD]esired 											{return solve_jj(JJ);}


[Aa]head   											{return set_ant(RB);}
[Jj]ust   											{;}
[Oo]ccasionally   									{return set_ant(RB);}
[Ss]lightly   										{return set_ant(RB);}
[Tt]ogether   										{return set_ant(RB);}
[Cc]ompletely   									{return set_ant(RB);}
[Ll]ightly   										{return set_ant(RB);}
[Gg]ently   										{return set_ant(RB);}
[Ee]venly   										{return set_ant(RB);}
[Mm]oderately   									{return solve_jj(DUAL_JR);}
[Ll]onger   										{return set_ant(RB);}
[Mm]eanwhile   										{return set_ant(RB);}
[Gg]radually   										{return set_ant(RB);}
[Aa]side   											{return set_ant(RB);}
[Tt]hrough   										{return set_ant(RB);}
[Aa]lmost   										{return set_ant(RB);}
[Oo]ften   											{return set_ant(RB);}
([uU]pside" ")?[Dd]own   							{return set_ant(DIR);}
[Ll]eft  											{return set_ant(DIR);}
[Rr]ight  											{return set_ant(DIR);}
[Ff]requently   									{return set_ant(RB);}
[Oo]nce   											{return set_ant(RB);}
[Ff]inely   										{return set_ant(RB);}
[Cc]arefully   										{return set_ant(RB);}
[Cc]onstantly   									{return set_ant(RB);}
[Ii]mmediately   									{return set_ant(RB);}
[Oo]vernight   										{return set_ant(RB);}
[Aa]ll   											{return set_ant(RB);}
[Ll]oosely   										{return set_ant(RB);}
[Gg]enerously   									{return set_ant(RB);}
[Ss]eparately   									{return set_ant(RB);}
[Uu]p   											{return set_ant(DIR);}
[Aa]part   											{return set_ant(RB);}
[Oo]ut   											{return set_ant(RB);}
[Cc]oarsely   										{return set_ant(RB);}
[Tt]ightly   										{return set_ant(RB);}
[Ee]nough   										{return set_ant(DUAL_JR);}
[Hh]alfway   										{return set_ant(RB);}
[Aa]lternately   									{return set_ant(RB);}
[Bb]arely   										{return set_ant(RB);}
[Aa]gain   											{return set_ant(RB);}
[Dd]ecoratively   									{return set_ant(RB);}
[Ee]qually   										{return set_ant(RB);}
[Bb]ack(" of")?										{return solve_nr(DUAL_NR);}
[Aa]top(" of")?										{return solve_nr(DUAL_NR);}
[Mm]iddle(" of")?									{return solve_nr(DUAL_NR);}
[Tt]op(" of") 										{return solve_nr(DUAL_NR);}
[Tt]horoughly   									{return set_ant(RB);}
[Pp]artially   										{return set_ant(RB);}
[Qq]uickly   										{return set_ant(RB);}
[Aa]way   											{return set_ant(DIR);}
[Tt]hinly   										{return set_ant(RB);}
[Tt]wice   											{return set_ant(RB);}
[Ss]lowly   										{return set_ant(RB);}
[Ii]nside   										{return set_ant(RB);}
[Hh]orizontally   									{return set_ant(RB);}
[Ff]irmly   										{return set_ant(RB);}
[Dd]iagonally   									{return set_ant(RB);}
[Ll]ess   											{return set_ant(RB);}
[Vv]igorously   									{return set_ant(RB);}
[Dd]irectly   										{return set_ant(RB);}
[Ff]reshly   										{return set_ant(RB);}
[Aa]longside   										{return set_ant(RB);}
[Ll]arger   										{return set_ant(RB);}
[Pp]referably   									{return set_ant(RB);}
[Tt]hickly   										{return set_ant(RB);}
[Aa]lternatively   									{return set_ant(RB);}
[Oo]utside   										{return set_ant(RB);}
[Ss]ometimes   										{return set_ant(RB);}
[Ss]maller   										{return set_ant(RB);}
[Ll]engthwise   									{return set_ant(RB);}
[Rr]oughly   										{return set_ant(RB);}
[Ff]ully   											{return set_ant(RB);}
[Aa]pproximately   									{return set_ant(RB);}
[Ee]asier   										{return set_ant(RB);}
[Aa]long   											{return set_ant(RB);}
[Cc]rumbly   										{return set_ant(RB);}
[Cc]losely   										{return set_ant(RB);}
[Bb]riskly   										{return set_ant(RB);}
[Ii]nward   										{return set_ant(RB);}
[Ee]asily   										{return set_ant(RB);}
[Bb]ubbly   										{return set_ant(RB);}
[Bb]ehind   										{return set_ant(RB);}
[Hh]igher   										{return set_ant(RB);}
[Bb]riefly   										{return set_ant(RB);}
[Uu]nderneath   									{return set_ant(RB);}
[Ss]oftly   										{return set_ant(RB);}
[Ss]imply   										{return set_ant(RB);}
[Nn]icely   										{return set_ant(RB);}
[Bb]etter   										{return set_ant(RB);}
[Nn]ow   											{return set_ant(RB);}
[Hh]ere   											{return set_ant(RB);}
[Mm]ostly   										{return set_ant(RB);}
[Rr]eally   										{return set_ant(RB);}
[Ss]ecurely   										{return set_ant(RB);}
[Rr]ather   										{return set_ant(RB);}
[Tt]hicker   										{return set_ant(RB);}
[Ss]nugly   										{return set_ant(RB);}
[Nn]ever   											{return set_ant(RB);}
[Bb]ottoms 											{return set_ant(UNK_WORD);}
[Bb]ottom(" of")?									{return solve_nr(DUAL_NR);}
[Qq]uite   											{return set_ant(RB);}
[Pp]reviously   									{return set_ant(RB);}
[Hh]owever   										{return set_ant(RB);}
[Yy]et   											{return set_ant(RB);}
[Ss]omewhat   										{return set_ant(RB);}
[Uu]pside   										{return set_ant(RB);}
[Uu]sually   										{return set_ant(RB);}
[Tt]hinner   										{return set_ant(RB);}
[Nn]earest   										{return set_ant(RB);}
[Aa]lways   										{return set_ant(RB);}
[Ff]airly   										{return set_ant(RB);}
[Ss]horter   										{return set_ant(RB);}
[Cc]ontinuously   									{return set_ant(RB);}
[Ss]ignificantly   									{return set_ant(RB);}
[Nn]ationwide   									{return set_ant(RB);}
[Ff]irmer   										{return set_ant(RB);}
[Ww]ider   											{return set_ant(RB);}
[Ee]specially   									{return set_ant(RB);}
[Ff]urther   										{return set_ant(RB);}
[Ll]ighter   										{return set_ant(RB);}
[Tt]here   											{return set_ant(RB);}
[Dd]eeper   										{return set_ant(RB);}
[Ss]moothly   										{return set_ant(RB);}
[Cc]reamier   										{return set_ant(RB);}
[Cc]omfortably   									{return set_ant(RB);}
[Oo]utward   										{return set_ant(RB);}
[Ss]tronger   										{return set_ant(RB);}
[Aa]ppealingly   									{return set_ant(RB);}
[Pp]robably   										{return set_ant(RB);}
[Ss]oon   											{return set_ant(RB);}
[Bb]rilliantly   									{return set_ant(RB);}
[Ii]nitially   										{return set_ant(RB);}
[Oo]verly   										{return set_ant(RB);}
[Cc]onversely   									{return set_ant(RB);}
[Dd]eeply   										{return set_ant(RB);}
[Ee]ntirely   										{return set_ant(RB);}
[Ii]ndividually   									{return set_ant(RB);}
[Gg]reater   										{return set_ant(RB);}
[Ss]imultaneously   								{return set_ant(RB);}
[Aa]skew   											{return set_ant(RB);}
[Nn]oticeably   									{return set_ant(RB);}
[Ss]picier   										{return set_ant(RB);}
[Ss]weeter   										{return set_ant(RB);}
[Ii]nstantly   										{return set_ant(RB);}
[Aa]while   										{return set_ant(RB);}
[Cc]hantilly   										{return set_ant(RB);}
[Nn]early   										{return set_ant(RB);}
[Ii]ndefinitely   									{return set_ant(RB);}
[Aa]cross   										{return set_ant(RB);}
[Nn]icer   											{return set_ant(RB);}
[Aa]nyway   										{return set_ant(RB);}
[Qq]uicker   										{return set_ant(RB);}
[Aa]dequately   									{return set_ant(RB);}
[Ff]lakier   										{return set_ant(RB);}
[Ii]ncorrectly   									{return set_ant(RB);}
[Nn]ewly   											{return set_ant(RB);}
[Uu]npleasantly   									{return set_ant(RB);}
[Jj]iggly   										{return set_ant(RB);}
[Ee]xceedingly   									{return set_ant(RB);}
[Mm]inimally   										{return set_ant(RB);}
[Vv]ertically   									{return set_ant(RB);}
[Ss]easonally   									{return set_ant(RB);}
[Rr]apidly   										{return set_ant(RB);}
[Pp]roperly   										{return set_ant(RB);}
[Rr]epeatedly   									{return set_ant(RB);}
[Uu]pright   										{return set_ant(RB);}
[Rr]icher   										{return set_ant(RB);}
[Dd]arkly   										{return set_ant(RB);}
[Bb]eautifully   									{return set_ant(RB);}
[Ss]moother   										{return set_ant(RB);}
[Ss]pearately   									{return set_ant(RB);}
[Cc]rosswise										{return set_ant(RB);}
[Cc]risscross   									{return set_ant(RB);}
[Cc]ontrary   										{return set_ant(RB);}
[sS]hortly 											{return set_ant(RB);}

[wW]hipping" "cream 									{return set_ant(UNK_WORD);}
[bB]aking" "(soda|powder)								{return set_ant(UNK_WORD);}
[cC]ake" "layer(s)? 									{return set_ant(UNK_WORD);}

{NUMBER}(" "[a-z]+)?" at a time" 						{return set_ant(AT_A_TIME);}

[lL]adle{S}												{ return set_ant(TOOL);}
[sS]patula{S}											{ return set_ant(TOOL);}
[fF]ork{S}												{ return set_ant(TOOL);}
[kK]ni(fe|ves)											{ return set_ant(TOOL);}
[pP]eeler{S}											{ return set_ant(TOOL);}
[tT]ongs{S} 											{ return set_ant(TOOL);}

[sS]pinner{S} 											{ return set_ant(TOOL);}
[zZ]ester{S}											{ return set_ant(TOOL);}
[fF]ish" "turner{S} 									{ return set_ant(TOOL);}
([cC]an" ")?[oO]pener{S}								{ return set_ant(TOOL);}
[cC]utting" "board{S} 									{ return set_ant(TOOL);}
[iI]mmersion{S}											{ return set_ant(TOOL);}
[sS]tick" "blender{S}									{ return set_ant(TOOL);}
[mM]ixer{S}												{ return set_ant(TOOL);}
[bB]lender{S} 											{ return set_ant(TOOL);}
[Ss]kewer{S}											{ return set_ant(TOOL);}

[pP]latter{S} 											{ return set_ant(CONTAINER);}
[Tt]ra(y|ies) 											{ return set_ant(CONTAINER);}
[cC]olander{S}											{ return set_ant(CONTAINER);}
[pP]an{S} 	 											{ return set_ant(CONTAINER);}
[oO]ven{S} 												{ return set_ant(CONTAINER);}	
[pP]ot{S}												{ return set_ant(CONTAINER);}
[bB]owl{S}												{ return set_ant(CONTAINER);}
[cC]ontainer{S}											{ return set_ant(CONTAINER);}
[kK]ettle{S} 											{ return set_ant(CONTAINER);}
[cC]asserole{S}											{ return set_ant(CONTAINER);}
[bB]oiler{S} 											{ return set_ant(CONTAINER);}
[sS]killet{S} 											{ return set_ant(CONTAINER);}
[gG]riddle{S}											{ return set_ant(CONTAINER);}
[sS]tock" "?pot|[wW]ok 									{ return set_ant(CONTAINER);}
([sS]aut[ée]|[sS]heet)" "?pan{S}						{ return set_ant(CONTAINER);}
([rR]oasting|[sS]auce|[fF]rying)" "?pan{S}				{ return set_ant(CONTAINER);}
[Ss]ilpat{S}   											{ return set_ant(CONTAINER);}

[sS]ec(ond(s)?)?										{ return set_ant(SECOND);}
[mM]in(ute(s)?)?										{ return set_ant(MIN);}
[hH](our(s)?)?											{ return set_ant(HOUR);}
[dD]ay(s)? 												{ return set_ant(DAY);}
[wW]eek(s)? 											{ return set_ant(WEEK);}
[mM]onth(s)? 											{ return set_ant(MONTH);}
[Yy]ear(s)? 											{ return set_ant(YEAR);}
[mM]oment(s)? 											{ return set_ant(RELATIVE_TIME);}



[Ee]very 									{ return set_ant(DET);}
[Mm]uch 									{ return set_ant(DET);}
[Ss]ome										{ return set_ant(DET);}
[Aa]ny 										{ return set_ant(DET);}
[Mm]any 									{ return set_ant(DET);}
[Ss]everal									{ return set_ant(DET);}
[Aa]nother 									{ return set_ant(DET);}
[eE]ach 									{ return set_ant(DET);}
[eE]ither 									{ return set_ant(DET);}
[nN]either 									{ return set_ant(DET);}

[Ff]or/(" about") 							{ return set_ant(TIME_PREP);}
[Ff]or 										{ return set_ant(FOR);}
[wW]ith 									{ return set_ant(WITH);}
[uU]ntil 									{ return set_ant(UNTIL);}
[Oo]ver/" in"								{ return set_ant(DIR);}
[oO]ver										{ return set_ant(OVER);}
[uU]nder									{ return set_ant(UNDER);}
[bB]y 										{ return set_ant(BY);}
[Aa]fter   									{ return set_ant(AFTER);}
[Bb]efore   								{ return set_ant(BEFORE);}
[aA]bout 									{ if (ant != TIME_PREP) return set_ant(ABOUT); else return set_ant(TIME_PREP);}

({COMMA})?[aA]bout(" ")+/{TIME_DETECTION} 							{ return set_ant(TIME_PREP);}
({COMMA})?[fF]or(" ")+/{TIME_DETECTION}								{ return set_ant(TIME_PREP);}
({COMMA})?[oO]ver(" ")+/{TIME_DETECTION}							{ return set_ant(TIME_PREP);}
({COMMA})?[uU]nder(" ")+/{TIME_DETECTION} 							{ return set_ant(TIME_PREP);}
({COMMA})?[eE]very(" ")+/{TIME_DETECTION}							{ return set_ant(TIME_PREP);}
({COMMA})?[fF]or(" ")[eE]very(" ")+/{TIME_DETECTION}	 			{ return set_ant(TIME_PREP);}
({COMMA})?[aA]fter(" ")+/{TIME_DETECTION} 							{ return set_ant(TIME_PREP);}
({COMMA})?[bB]efore(" ")+/{TIME_DETECTION}							{ return set_ant(TIME_PREP);}


[tT]o/((" ")+{NUMBER}(" ")+{TIME}[" ""."";""?""!"])			{ return set_ant(TO_T);} 
[tT]o/((" ")+{NUMBER}[" ""."";""?""!"\-])					{ return set_ant(TO_Q);} 
[tT]o 														{ return set_ant(TO);}

[aA]t 	 									{ return set_ant(AT);}
[Ww]hen   									{ return set_ant(WHEN);}
[Ww]hile  									{ return set_ant(WHILE);}
[oO]f 										{ return set_ant(OF);}
[Ff]rom 									{ return set_ant(FROM);}
[Aa]round 									{ return set_ant(AROUND);}
[Aa]bove 									{ return set_ant(ABOVE);}
[Bb]elow 									{ return set_ant(BELOW);}
[Ii]nto 									{ return set_ant(INTO);}
[Oo]nto 									{ return set_ant(ONTO);}
[Bb]etween 									{ return set_ant(BETWEEN);}
[Ii]f 										{ return set_ant(IF);}

"."|"?"|"!"|";" 										{ return set_ant(EOS);}
","/(" "[a-z]+"ing") 									{ ;}
"," 													{ if ( ant != ACTION && ant != RB) {set_ant(-2); return CC;} }
","/((" ")+{NUMBER}(" ")+{TIME}) 							{ ;}
"and"/((" ")+{NUMBER}(" ")+{TIME}) 							{ ;}

{COMMA}?[oO]r											{ set_ant(-2); return CC;}
[aA]nd{COMMA}? 											{ set_ant(-2); return CC;}

[nN]o(t)?												{ return set_ant(NOT);}

{COMMA}[aA]nd 											{ if (ant == ACTION || (aant == GERUND2 && ant == RB)) {set_ant(-2); return CC2;} else {set_ant(-1); return CC;}}
{COMMA}?"and then" 										{ set_ant(-1); return CC2;}
{COMMA}?("then")										{ set_ant(-1); return CC2;}

{NUMBER}?" "*?("degree"{S}|(°))?" "*?{TEMP}/[" ""."","";"]		{ return set_ant(TEMPERATURE);}
[fF]ire 														{ return set_ant(HEAT);}
([rR]oom" ")?[tT]emperature										{ return set_ant(HEAT);} 

({NUMBER}+"x")+{NUMBER} 								{ return set_ant(DIMENSION);}
{NUMBER} 												{ return set_ant(DIGITS_NUMBER); }
"/"														{ set_ant(ant); return SLASH;}
\-														{ set_ant(ant); return DASH;}
\-" " 													{ ;}

"(".+")" 										
" x " 													{ ; }
[a-z]+([a-z\-]*[a-z])									{ return solve_unk(UNK_WORD);}
[\n]													{ set_ant(-1); return NL;}
[\t ".""?""!"]											;
.														;
%%


// tries to find the part of speech for unknown words (UNK_WORD)
int solve_unk(int original) 
{
	if (ant == EOS) {
		return set_ant(ACTION);
	}

	if (ant == TO) {
		return set_ant(ACTION);
	}

	if ((aant == JJ || aant == RB) && ant == -2) {
		return set_ant(JJ);
	}

	if (ant == -2 && aant == ACTION) {
		return set_ant(ACTION);
	}

	if (strcmp(yytext+strlen(yytext)-2,"ed") == 0 && strcmp(yytext+strlen(yytext)-3,"eed") != 0) {
		return set_ant(JJ);
	}

	return set_ant(original);
}

// tries to find the part of speech for potential adjectives (JJ)
int solve_jj(int original) {
	
	if (ant == UNTIL || ant == WHILE || ant == WHEN || ant == BEFORE || ant == AFTER) {
		return set_ant(JJ_TEMP);
	}

	if (ant == UNK_WORD || (ant == CC && aant == RB)) {
		return set_ant(RB);
	} 

	return set_ant(original);
}


// solves verb vs noun problems
int solve_vn(int original) 
{
	if (yytext[yyleng-2] == ' ') {
		yyless(yyleng-2);

		if (ant != JJ){
			return set_ant(ACTION);
		} else {
			return set_noun(original);
		}
	} else {
		if (continuousCC >= 1 && ant == -2) return set_ant(original);

		if (numberFlag == 1 ||  ant == UNK_WORD) {
			return set_noun(original);
		}

		if (ant == RB && aant == ACTION) return set_noun(original);

		if (ant == -2 || ant == -1 || ant == RB || ant == TO || ant == TEMPERATURE || ((aant == UNTIL || aant == WHEN || aant == WHILE || aant == BEFORE || aant == AFTER) && ant == PRP)) {
			return set_ant(ACTION);
		}

		if (ant == JJ || ant == ACTION || ant == DUAL_JR || ant == DET || ant == UNTIL || ant == INTO || ant == ONTO || ant == IN || ant == ON || ant == DIGITS_NUMBER || ant == WITH) {
			return set_noun(original);
		}

		return set_ant(original);
	}
}

// extracts the keyword/noun from a token
int set_noun(int original)
{
	if (original == DUAL_VN_TOOL) 
		return set_ant(TOOL);

	if (original == DUAL_VN_CONTAINER)
		return set_ant(CONTAINER);

	if (original == DUAL_VN_HEAT)
		return set_ant(HEAT);

	return set_ant(UNK_WORD);
}

// sets the previous tokens
int set_ant(int current) 
{
	if (ant == ACTION && current == ACTION) {
		current = SUB_ACTION;
	}

	numberFlag = 0;

	if (current != L && current != M && current != G && current != CUP && current != INCH && current != DIGIT && current != TENS
		&& current != TEENS && current != HUNDRED && current != THOUSAND && current != DOZEN && current != CC3) {
		yylval.text = strdup(yytext);	
	}

	if (current != CC3 && yylval.text[0] == ',') {
		strcpy(yylval.text, yylval.text+2);
	}

	if (current == ACTION && (ant == -1 || ant == -2) && aant == JJ) {
		
		yyless(0);
		current = CC3;
	}

	aant = ant;

	if (current == EOS) {

		ant = -1;
		aant = -1;
	} else {
		ant = current;
	}
	return current;
}

// solves verb-adjective-adverb problems
int solve_vjr(int original) 
{
	if (ant == ACTION) 
	{
		return set_ant(DUAL_JR);
	} else {
		return set_ant(original);
	}
}


// solves verb-adjective problems
int solve_vj(int original) 
{
	if (ant == UNTIL || ant == WHILE || ant == WHEN || ant == BEFORE || ant == AFTER) 
	{
		return set_ant(JJ_TEMP);
	}

	if (ant == ACTION || ant == DET || ant == IN || ant == ON || ant == INTO || ant == ONTO || ant == OVER || ant == UNDER || ant == PRP) 
	{
		return set_ant(JJ);
	} else {
		return set_ant(ACTION);
	}
}


// part of speech identification for gerund
int solve_gerund(int original)
{
	if (ant == EOS || ant == -1 || ant == UNK_WORD || ant == PRP || ant == TOOL || ant == HEAT || ant == CONTAINER) {
		return set_ant(GERUND2);
	}

	if (ant == DET || ant == JJ || ant == WITH || ant == IN || ant == ON || ant == INTO || ant == ONTO || ant == FROM) {
		return set_ant(JJ);
	}
	
	if (strcmp(yytext+yyleng-3," to") == 0) {

		yyless(yyleng-3);
		return set_ant(GERUND2);
	} 

	if (ant == WHEN || ant == WHILE || ant == UNTIL || ant == BEFORE || ant == AFTER) {
		return set_ant(GERUND2);
	}

	if (strcmp(yytext+yyleng-2,", ") == 0) {
		yyless(yyleng-1);
		return set_ant(RB);
	}

	if (ant == -2 || ant == ACTION || ant == EOS) {
		return set_ant(GERUND2);
	}

	return set_ant(original);
	
}


int solve_nr(int original)
{ 
	if (strcmp(yytext+yyleng-3," of") == 0) {
		yyless(yyleng-3);
		return set_ant(UNK_WORD);
	} 
	if (ant == DET || ant == -2) {
		return set_ant(UNK_WORD);
	}
	if (ant == UNK_WORD) {
		return set_ant(LOC_PREP);
	}

	return set_ant(original);
}