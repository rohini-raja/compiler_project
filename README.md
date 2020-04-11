# Lexical Scanner & Parser (By: Rohini.R -2017103579 , RathnaSri - 2017103576)
TOOLS USED:
1) lex - to find tokens and lexemes

IMPLEMENTATION DETAILS:

-->Done using Ubuntu 18.04

By the following commands:
 1) sudo apt-get update
 2) sudo apt-get install flex

STEPS:

1) lex codetry.l

2) gcc -o scanner lex.yy.c -lfl

3) ./scanner inputfile.txt

