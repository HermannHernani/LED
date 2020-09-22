%option noyywrap
 
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "symtab.c"
    
    extern FILE *yyin;
    extern FILE *yyout;
    
    int lineno = 1; // initialize to 1
    void ret_print(char *token_type);
    void yyerror();
%}
 
%x ML_COMMENT
 
alpha       [a-zA-Z]
digit       [0-9]
alnum       {alpha}|{digit}
print       [ -~]
 
ID          {alpha}+{alnum}*
STRING      \"{print}*\"
 
%%
 
"//".*       
<ML_COMMENT>"\n"        { lineno += 1; }
 
 
"char"|"CHAR"           { ret_print("KEYWORD_CHAR"); }
"int"|"INT"             { ret_print("KEYWORD_INT"); }
"float"|"FLOAT"         { ret_print("KEYWORD_FLOAT"); }
"void"|"VOID"           { ret_print("KEYWORD_VOID"); }
"return"|"RETURN"       { ret_print("KEYWORD_RETURN"); }
 
 
"+"|"-"                 { ret_print("ADDOP"); }
"*"                     { ret_print("MULOP"); }
"/"                     { ret_print("DIVOP"); }
 
 
"("             { ret_print("LPAREN"); }
")"             { ret_print("RPAREN"); }
"{"             { ret_print("LBRACE"); }
"}"             { ret_print("RBRACE"); }
";"             { ret_print("SEMI"); }
"."             { ret_print("DOT"); }
","             { ret_print("COMMA"); }
"="             { ret_print("ASSIGN"); }
"&"             { ret_print("REFER"); }
 
 
{ID}            {
                    // insert identifier into symbol table
                    insert(yytext, strlen(yytext), UNDEF, lineno);
                    ret_print("ID");
                }
 
 
"\n"            { lineno += 1; }
[ \t\r\f]+          /* eat up whitespace */
 
.               { yyerror("Unrecognized character"); }
 
%%
 
void ret_print(char *token_type){
    printf("yytext: %s\ttoken: %s\tlineno: %d\n", yytext, token_type, lineno);
}
 
void yyerror(char *message){
    printf("Error: \"%s\" in line %d. Token = %s\n", message, lineno, yytext);
    exit(1);
}
 
int main(int argc, char *argv[]){
    // initialize symbol table
    init_hash_table();
 
    // open input file
    yyin = fopen(argv[1], "r");
    
    // lexical analysis
    yylex();
    fclose(yyin);
    
    // symbol table dump
    yyout = fopen("symtab_dump.out", "w");
    symtab_dump(yyout);
    fclose(yyout);  
    
    return 0;
}