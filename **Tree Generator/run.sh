#!/bin/bash

yacc -d -v recipe.y
lex  recipe.l
gcc y.tab.c lex.yy.c -ly -ll -lm
./a.out 
