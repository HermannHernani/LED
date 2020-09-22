%{
    #define YYSTYPE double
    #include "calc.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.h"
%}

alpha [a-zA-Z]
white [ \t]+
digit [0-9]
alnum {alpha}|{digit}
integer {digit}+
exponent [eE][+-]?{integer}
real {integer}("."{integer})?{exponent}?
ID  {alpha}+{alnum}*
STRING		\"{print}*\"
%%

{white} { }
{real} { yylval=atof(yytext); return NUMBER; }

"int" return INT;
"INT" return INT;

"=" return ATTRIB

"MAIS" return PLUS;
"mais" return PLUS;
"+" return PLUS;

"MENOS" return MINUS;
"menos" return MINUS;
"-" return MINUS;

"VEZES" return TIMES;
"vezes" return TIMES;
"*" return TIMES;

"DIVIDIDO" return DIVIDE;
"dividido" return DIVIDE;
"/" return DIVIDE;

"POTENCIA" return POWER;
"potencia" return POWER;
"^" return POWER;

"A" return TRIANGLE;

"O" return CIRCLE;

"#" return PRIMES;

"(" return LEFT;
")" return RIGHT;
";" return END;

"help" return HELP;
"Help" return HELP;
"HELP" return HELP;

"exit" return EXIT;
"Exit" return EXIT;
"EXIT" return EXIT;

"PRINT:" return PRINT;
"print:" return PRINT;
"Print:" return PRINT;

 
{ID} 			{
					// insert identifier into symbol table
					insert(yytext, strlen(yytext), UNDEF, lineno);
					return ID;
				}
 
"\n"			{ lineno += 1; }