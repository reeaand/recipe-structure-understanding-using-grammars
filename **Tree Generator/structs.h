#define SIBLINGS 5
#define CHILDREN 15

int continuousCC;
int numberFlag;

typedef struct Pair {
	float value;
	char* label;
} pair;

typedef struct Node {
	char* level;
	char* label;
	char* value;

	int nrSiblings;
	struct Node* siblings[SIBLINGS];

	int nrChildren;
	struct Node* children[CHILDREN];
	
} node;

typedef struct Children {

	struct Node* children[CHILDREN];
	int nrChildren;

} children;

