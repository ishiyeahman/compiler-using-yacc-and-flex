%{
#include <stdio.h>
#include <math.h>
int yylex(void);
void  yyerror( char *s);
// int yyparse(void);
int getchar(void);
char usingChar[] = {'\n', '+', '-', '*', '/', '%', '(', ')', '0', '1','2','3','4', '5', '6','7','8','9', 'r', '^'};
char END = 'q';
int arraySize =  sizeof(usingChar) / sizeof(char);
int isUsedChar(int);
void exit(int);

// yyperse() : 戻り値 error => 1
%}

%union{
    int ival;
    double rval;
}

%token EXP LOG SQRT

%token <ival> INTC
%token <rval> REALC

%type  <rval> line expr term factor

%start line 

%%

line    :   expr '\n'   {
                        printf("ans >> %lf\n", $1); 
                        /* 再帰的に計算 */
                        /* syntax errorならば再帰を復帰せずその処理で終了*/
                        if( yyparse()) exit(1); 
                        }
        ;

expr    :   expr '+' term       { $$ = $1 + $3; }
        |   expr '-' term       { $$ = $1 - $3; }
        |   term                { $$ = $1; }
        ;

term    :   term '*' factor     { $$ = $1 * $3; } 
        |   term '/' factor     { if($3 == 0) { 
                                        /*計算を行わず0を出力する*/
                                        printf("division by zero\n"); 
                                        $$ = 0;  
                                } else { $$ = $1 / $3;} }
        /* 剰余演算子を追加 */
        |   term '%' factor     { $$ =fmod($1,$3); } 

        /* べき乗を追加*/
        |   term '^' factor     { $$ = pow($1, $3); } 
        |   factor              { $$ = $1; }
        ;

factor  :   '(' expr ')'        {$$ = $2;}
        |   INTC                {$$ = (double)$1; }
        |   REALC               {$$ = $1; }
        ;




%%

#include <ctype.h>

int main(){
    yyparse();
}

void yyerror( char *msg){
    printf("%s\n", msg);
}


