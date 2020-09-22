calc: calc.y calc.l
	bison -d -W calc.y
	flex  -o -w calc.lex.c calc.l
	gcc -Wall -o calc calc.lex.c calc.tab.c -lfl -lm 
	
clean:
	rm -rf calc
	rm -f calc.lex.c
	rm -f calc.tab.c
	rm -f calc.tab.h 

	