%{

# include <stdio.h>
# include <string.h>
int yylex(void);
void yyerror(char *s);

%}

// 定义句法终结符
%token DIGIT LIANG LING SHI BAI QIAN WAN YI

%%

Number:
    TenThousandPos
    | LING
    ;

// 万位
TenThousandPos:
    TenThousandNum ThousandPos
    | ThousandPos
    ;

// X万
TenThousandNum:
    ThousandPos WAN
    | LIANG WAN
    ;

// 千位数
ThousandPos:
    ThousandNum HundredPos
    | HundredPos
    ;

// X千
ThousandNum:
    DIGIT QIAN
    | LIANG QIAN
    ;

// 百位数
HundredPos:
    HundredNum TenLimitPos
    | TenPos
    ;

// X百
HundredNum:
    DIGIT BAI
    | LIANG BAI
    ;

// 十位数（包含十X）
TenPos:
    SHI Individual
    | TenLimitPos
    ;

// 十位数
TenLimitPos:
    TenLimitNum Individual
    | Individual
    ;

TenLimitNum:
    DIGIT SHI
    ;

// 个位数
Individual:
    DIGIT
    |
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}