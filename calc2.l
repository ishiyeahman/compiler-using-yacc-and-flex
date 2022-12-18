%{
#include "y.tab.h"
%}

ws  [ \t]
symbol [=+\-*/\^()[\]%,\n]
digit   [0-9]
other .


%%
{ws}+       
{symbol}    { return(yytext[0]); }
"exp"       { return(EXP); }
"log"       { return(LOG); }
"sqrt"      { return(SQRT); }
"max"      { return(MAX); }
"min"      { return(MIN); }
"!"         { return(FACTORIAL); }
"pi"        { return(PI); }
{digit}+    { sscanf(yytext, "%d", &yylval.ival); return(INTC);}
{digit}+"."{digit}* { sscanf(yytext, "%lf", &yylval.rval); return(REALC);}

{other}     {fprintf(stderr, "Illegal char '%c' ignored\n", yytext[0]); }

