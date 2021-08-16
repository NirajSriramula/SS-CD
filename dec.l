%{
	#include <stdlib.h>
	#include "y.tab.h"
	void yyerror(char *);
	extern int line_number;
%}
%%
=						return EQ;
;						return EOL;

int                   	return INT;
long					return LONG;
short					return SHORT;	
float					return FLOAT;
double					return DOUBLE;
char					return CHAR;
void                    return VOID;

"{"						return '{';
"}"						return '}';
","						return ',';
":"						return ':';
"("						return '(';
")"						return ')';
"["					    return '[';
"]"						return ']';

[a-zA-Z][_a-zA-Z0-9]*    {printf("%s",yytext);return ID;}
%%
int yywrap(void) {
    return 1;
}
