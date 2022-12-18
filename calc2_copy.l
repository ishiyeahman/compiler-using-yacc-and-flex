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


double degree(double rad);
%}

%union{
    int ival;
    double rval;
}

%token EXP LOG SQRT MAX MIN FACTORIAL PI E ABS DEGREE

%token <ival> INTC
%token <rval> REALC

%type  <rval> line expr 

%right '='
%left '+' '-'
%left '*' '/' '%'
%right '^'
%right UMINUS
/* %start line  */

%%
        
line    :
        |  line expr '\n'   {
                        printf("ans >> %f\n", $2); 
                        /* 再帰的に計算 */
                        /* syntax errorならば再帰を復帰せずその処理で終了*/
                        // if( yyparse()) exit(1); 
                        }
        | line error '\n' { yyerrok; }
        ;

expr    :   expr '+' expr       { $$ = $1 + $3; }
        |   expr '-' expr       { $$ = $1 - $3; }
        |   expr '*' expr     { $$ = $1 * $3; } 
        |   expr '/' expr     { if($3 == 0) { 
                                    /*計算を行わず0を出力する*/
                                    printf("division by zero\n"); 
                                    $$ = 0;  
                                } else { $$ = $1 / $3;} }
        /* 剰余演算子を追加 */
        |   expr '%' expr    { $$ =fmod($1,$3); } 
        |   expr '^' expr     { $$ = pow($1, $3); } 
        |  '(' expr ')'        {$$ = $2;}
        | LOG '(' expr ')'      {$$ = log($3); }
        | EXP '(' expr ')'      {$$ = exp($3); }
        | SQRT '(' expr ')'      {$$ = sqrt($3); }
        | MAX '(' expr ',' expr ')'      {$$ = fmax($3, $5); }
        | MIN '(' expr ',' expr ')'      {$$ = fmin($3, $5); }
        | ABS '(' expr ')'      {$$ = fabs($3); }
        | '(' expr')' FACTORIAL   {$$ = tgamma($2 + 1.0); } /* FACTORIAL = gmmma(n + 1)*/
        |   PI                  {$$ = M_PI; }
        |   E                  {$$ = M_E; }
        | '-' expr  %prec UMINUS {$$ = -$2; }
        |   DEGREE '(' expr ')' {$$ = degree($3); }
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

double degree(double rad){
    return rad*180/M_PI;
}