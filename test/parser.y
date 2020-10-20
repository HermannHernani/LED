%{
	#include "symtab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
    char char_val;
	int int_val;
	double double_val;
	char* str_val;
	list_t* symtab_item;
}

/* token definition */
%token<int_val> CHAR INT FLOAT VOID RETURN
%token<int_val> ADDOP MULOP DIVOP
%token<int_val> LPAREN RPAREN LBRACE RBRACE SEMI DOT COMMA ASSIGN
%token <symtab_item>   ID
%token <int_val>       ICONST
%token <double_val>    FCONST
%token <char_val>      CCONST
%token <str_val>       STRING
%token PRINT

/* precedencies and associativities */
%left LPAREN RPAREN
%right INCR
%left MULOP DIVOP
%left ADDOP
%right ASSIGN
%left COMMA PRINT


%start program

/* expression rules */

%%

program: functions_optional ;

/* declarations */
declarations: declarations declaration | declaration;

declaration: type names SEMI ;

type: INT | CHAR | FLOAT | VOID ;

names: names COMMA variable | names COMMA init | variable | init ;

variable: ID 
;

init: var_init  ;

var_init : ID ASSIGN constant

values: values COMMA constant | constant ;

/* statements */
statements: statements statement | statement ;

statement: assigment SEMI | function_call SEMI | print
;

/* Expressao de print, modificar aqui */

expression: print: {printf("%c");} 

expression:
    expression ADDOP expression |
    expression MULOP expression |
    expression DIVOP expression |
    LPAREN expression RPAREN |
    var_ref |
    sign constant |
    function_call
	print:
;

sign: ADDOP | /* empty */ ; 

constant: ICONST | FCONST | CCONST ;

assigment: var_ref ASSIGN expression ;

var_ref  : variable ; 

function_call: ID LPAREN call_params RPAREN;

call_params: call_param | STRING | /* empty */

call_param : call_param COMMA expression | expression ; 

/* functions */
functions_optional: functions | /* empty */ ;

functions: functions function | function ;

function: function_head function_tail ;
		
function_head: return_type ID LPAREN parameters_optional RPAREN ;

return_type: type ;

parameters_optional: parameters | /* empty */ ;

parameters: parameters COMMA parameter | parameter ;

parameter : type variable ;

function_tail: LBRACE declarations_optional statements_optional return_optional RBRACE ;

declarations_optional: declarations | /* empty */ ;

statements_optional: statements | /* empty */ ;

return_optional: RETURN expression SEMI | /* empty */ ;

%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[]){

	// initialize symbol table
	init_hash_table();

	// parsing
	int flag;
	yyin = fopen(argv[1], "r");
	flag = yyparse();
	fclose(yyin);
	
	printf("Parsing finished!\n");
	
	// symbol table dump
	yyout = fopen("symtab_dump.out", "w");
	symtab_dump(yyout);
	fclose(yyout);
	
	return flag;
}
