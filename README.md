# Php_Mini_Compiler
Php mini Compiler with expression evaluation, if/elseif/else, print, Error handling, for & while loops etc.

Written in Bison/lex-yacc

To compile and run : lex done.l && yacc -d -v ab.y && gcc lex.yy.c y.tab.c -ll -w && ./a.out < php_code.txt && python3 optimize.py intermediate_code.txt > output.txt

Then with the optimized code run TARGET.py to get the assembly code.
