%{
	#include "symtab.c"
    #include <math.h>
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #define YYSTYPE double
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
    int yyerror (char const *s);
    extern int yylex (void);
%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER TRIANGLE CIRCLE HELP EXIT PRINT
%token LEFT RIGHT
%token END

%left PLUS MINUS
%left TIMES DIVIDE
%left NEG PRIMES
%right POWER

%define parse.error verbose
%start Input
%%

Input: /* empty */{printf(">>> ");};
Input: Input Line {printf(">>> ");};

Line: END
Line: Expression END {printf("\n");}

Expression: PRINT { printf("%c\n", $1);}
Expression: EXIT { printf("Até mais!\n"); exit(0);}
Expression: HELP { printf(
"Comandos:\nMAIS, mais, +: soma;\nMENOS, menos, -: subtração;\nVEZES, vezes, *: multiplicação;\nDIVIDIDO, dividido, /:divisão;\nPOTENCIA, potencia, ^: potencia;\nA: calcula a hiptenusa dado dois lados de um triangulo retangulo;\nO: calcula a circunferencia de um circulo dado o raio;\n#: calcula os divisores primos de um numero;\n");}
Expression: NUMBER { $$=$1; };
Expression: Expression PLUS Expression { $$ =$1 + $3; };
Expression: Expression MINUS Expression { $$ = $1 - $3; };
Expression: Expression TIMES Expression { $$ = $1 * $3; };
Expression: Expression DIVIDE Expression { $$ = $1 / $3; };
Expression: MINUS Expression %prec NEG { $$ = -$2; };
Expression: Expression POWER Expression { $$ = pow($1, $3); };
Expression: LEFT Expression RIGHT { $$ = $2; };
Expression: Expression TRIANGLE Expression {
    $$ = sqrt(pow($1, 2) + pow($3, 2)); 
    printf("Triangulo retangulo:\nADJACENTE:%.2f\nOPOSTO:%.2f\nHIPOTENUSA:%.2f\n", $1, $3, $$); 
};
Expression: CIRCLE Expression { $$ = 6.28 * $2; printf("Circunferencia do circulo de raio %.2f: %.2f\n", $2, $$);};
Expression: PRIMES Expression { 
    int div = floor($2);
    char res[200];
    strcpy(res, "");
    while (div > 1) {
    if(div % 2 == 0)  { strcat(res, "2,"); div = div / 2; }
    else if(div % 3 == 0)  { strcat(res, "3,"); div = div / 3; }
    else if(div % 5 == 0)  { strcat(res, "5,"); div = div / 5; }
    else if(div % 7 == 0)  { strcat(res, "7,"); div = div / 7; }
    else if(div % 11 == 0) { strcat(res, "11,"); div = div / 11; }
    else if(div % 13 == 0) { strcat(res, "13,"); div = div / 13; }
    else if(div % 17 == 0) { strcat(res, "17,"); div = div / 17; }
    else if(div % 19 == 0) { strcat(res, "19,"); div = div / 19; }
    else if(div % 23 == 0) { strcat(res, "23,"); div = div / 23; }
    else if(div % 29 == 0) { strcat(res, "29,"); div = div / 29; }
    else if(div % 31 == 0) { strcat(res, "31,"); div = div / 31; }
    else if(div % 37 == 0) { strcat(res, "37,"); div = div / 37; }
    else if(div % 41 == 0) { strcat(res, "41,"); div = div / 41; }
    else if(div % 43 == 0) { strcat(res, "43,"); div = div / 43; }
    else if(div % 47 == 0) { strcat(res, "47,"); div = div / 47; }
    else if(div % 53 == 0) { strcat(res, "53,"); div = div / 53; }
    else if(div % 59 == 0) { strcat(res, "59,"); div = div / 59; }
    else if(div % 61 == 0) { strcat(res, "61,"); div = div / 61; }
    else if(div % 67 == 0) { strcat(res, "67,"); div = div / 67; }
    else if(div % 71 == 0) { strcat(res, "71,"); div = div / 71; }
    else if(div % 73 == 0) { strcat(res, "73,"); div = div / 73; }
    else if(div % 79 == 0) { strcat(res, "79,"); div = div / 79; }
    else if(div % 83 == 0) { strcat(res, "83,"); div = div / 83; }
    else if(div % 89 == 0) { strcat(res, "89,"); div = div / 89; }
    else if(div % 97 == 0) { strcat(res, "97,"); div = div / 97; }
    else { div = 0; }
    }
    res[strlen(res)-1] = '\0';
    if(div != 0) printf("Decomposição prima de %.0f: %s\n", $2, res);
    else printf("Não foi possivel calcular os divisores primos de %.0f\n", $2);
    strcpy(res, "");
    $$ = div; 
};
%%

int yyerror(char const *s) {
    printf("Comando nao reconhecido: %s\n", s);
}

int main() {
    printf("Bem vindo ao terminal da Calculadora Monstra™ (v0.1)\nEsta Calculadora foi desenvolvida pelos alunos da Materia de Linguagens Especificas e de Dominio\ndo curso de Sistemas de Informação - UEA/EST\nSobre a mentoria do Professor Doutor Jucimar da Silva Jr.\nDigite 'Help' para ver os comandos\nDigite 'Exit' para sair\n");
    
	// initialize symbol table
	init_hash_table();
 
	// parsing
	int flag;
	yyin = fopen(argv[1], "r");
	flag = yyparse();
	fclose(yyin);
 
	// symbol table dump
	yyout = fopen("symtab_dump.out", "w");
	symtab_dump(yyout);
	fclose(yyout);	
 
	return flag;
}
