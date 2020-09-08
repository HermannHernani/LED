%{
#define YYSTYPE double
#include "calc.tab.h"
%}

white [ \t]+
digit [0-9]
integer {digit}+
exponent [eE][+-]?{integer}
real {integer}("."{integer})?{exponent}?

%%

{white} { }
{real} { yylval=atof(yytext); return NUMBER; }

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
";\n" return END;
";" return END;
"\n" return END;

"help" return HELP;
"Help" return HELP;
"HELP" return HELP;

"exit" return EXIT;
"Exit" return EXIT;
"EXIT" return EXIT;

"PRINT:" return PRINT;
"print:" return PRINT;
"Print:" return PRINT;

