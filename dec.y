%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void yyerror(char *);
	int yylex(void);
	extern char *yytext;
	extern FILE * yyin;
	int global_dec=0;
	int func_def=0;
	
	int line_number=1;
%}
%token INT LONG SHORT FLOAT DOUBLE CHAR VOID STRING EQ EOL ID
%%

program:
	lines
;

lines:
	line 
|	line lines						{line_number++;}
;

line:
	func_dec 								
;
func_dec:
	mul_type ID '(' args_ornot ')' EOL			{printf("Function declaration found\n");func_def++;}
|	mul_type ID '(' args_ornot ')' '{' statements '}' 	{printf("Function Definition found\n");func_def++;}
;
args_ornot:
	args_id
|	%empty
;

mul_type:
	type 				
|	type mul_type 
;

args_id:
	mul_type
|	mul_type ID										
|	mul_type ',' args_id
|	mul_type ID ',' args_id
;
statements:
	one_or_more_statement
|	%empty
;

one_or_more_statement:
	statement
|	statement one_or_more_statement
;

statement:
	var_dec
|	ID '(' internal_ornot ')' '{' statements '}' 
;
internal_ornot:
	internal_id
|	%empty
;
internal_id:
|	ID				
|	ID ',' internal_id
;

var_dec:
	mul_type assign_var EOL 					
;
assign_var:
	ID  extend_var_dec
; 	
extend_var_dec:
	',' assign_var
|	%empty
;

var_assign:
	ID EOL 
|	ID EQ expression EOL
;
expression:
	'(' expression ')'
|	un_op expression
;
un_op:
	'+'
|	'-'
|	'&'
|	'~'
|	'!'
;

type:
	INT 	
| 	LONG	
| 	SHORT	
| 	FLOAT
| 	DOUBLE
| 	CHAR  
| 	VOID 	
;

%%
void yyerror(char *s) {
    printf("\n%s\n",s);
}

int main(int argc,char* argv[]){
if(argc != 2){
	   	printf("***process terminated*** [input error]: invalid number of command-line argumnets\n");
		return 0;
    }
    FILE *file_open = fopen( argv[1] , "r" );
    if (!file_open) {
		printf("***process terminated*** [input error]: no such file %s exists\n",argv[1]);
		return 0;
    } 
    yyin = file_open;
    yyparse();
    }
