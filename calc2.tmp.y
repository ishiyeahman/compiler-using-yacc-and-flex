%{
#include <stdio.h>
#include <math.h>
int yylex(void);
void yyerror(const char *s);
int getchar(void);
char usingChar[] = {'\n', '+', '-', '*', '/', '%', '(', ')', '0', '1','2','3','4', '5', '6','7','8','9', 'r', '^'};
char END = 'q';
int arraySize =  sizeof(usingChar) / sizeof(char);
int isUsedChar(int);
void exit(int);

// yyperse() : 戻り値 error => 1
%}
%token NUM

%start line 

%%

line    :   expr '\n'   {
                        printf("ans >> %d\n", $1); 
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
        |   term '%' factor     { $$ = $1 % $3; } 

        /* べき乗を追加*/
        |   term '^' factor     { $$ = pow($1, $3); } 
        |   factor              { $$ = $1; }
        ;

factor  :   '(' expr ')'        {$$ = $2;}
        |  NUM 
        ;




%%

#include <ctype.h>

int yylex()
{
        int c;
        
        while(1){
                c = getchar();
                /* 空白とタブを読み飛ばす*/
                if( c  != ' ' && c  != '\t'){
                        /* if(isUsedChar(c))
                                break; */
                    if(isdigit(c)){
                        yylval = c - '0';
                        while( isdigit(c = getchar()))
                            yylval = yylval*10 +(c - '0');
                        ungetc(c , stdin);
                        
                        return NUM;
                    }
                    
                /* END(q)を入力するとプログラム終了*/
                    if(c == END)
                        exit(0);

                    if(isUsedChar(c))
                                break;

                /* 予約文字以外の場合エラーを出力し文字を再読み込み*/
                    printf("'%c' is prohibited.\n", c);
                }
            
        };
        return c;
        
}

int isUsedChar(int c){
        /* usingCharで定義されていなければ return 0*/
        for(int i = 0; i < arraySize ; i++){
                if( c == (char)usingChar[i])
                        return 1;
        }

        return 0;
}


