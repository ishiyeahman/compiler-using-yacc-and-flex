bison -y -dv calc2.y;
flex -l calc2.l;
gcc y.tab.c lex.yy.c -ly -ll calc2.l;
