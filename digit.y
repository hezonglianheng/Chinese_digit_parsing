%{

# include <stdio.h>
# include <string.h>
int yylex(void);
void yyerror(char *s);

%}

// 定义句法终结符
%token DIGIT ER LIANG LING SHI BAI QIAN WAN YI

%%
/*
todo: 增加语法规则
1. 处理“四百零七亿零一百二十万零三百零七”和“四百零七亿零一百二十”的歧义问题
2. 处理“三百八”的解析问题
*/


Number:
    DecBillionPos
    | LING
    ;

DecBillionPos:
    DecBillionNum AfterTenThousandPos
    | DecBillionNum LING AfterZeroTenThousandPos
    | TenThousandPos
    ;

DecBillionNum:
    TenThousandPos YI
    | LIANG YI
    ;

// 万位
TenThousandPos:
    TenThousandNum AfterThousandPos
    | TenThousandNum LING HundredPos
    | ThousandPos
    ;

AfterTenThousandPos:
    TenThousandNum AfterThousandPos
    | TenThousandNum LING HundredPos
    |
    ;

AfterZeroTenThousandPos:
    ThousandPos
    | HundredPos WAN AfterThousandPos
    ;

// X万
TenThousandNum:
    ThousandPos WAN
    | LIANG WAN
    ;

// 千位数
ThousandPos:
    HundredPos
    | ThousandNum AfterHundredPos
    | ThousandNum LING AfterZeroTenPos
    ;

AfterThousandPos:
    ThousandNum AfterHundredPos
    | ThousandNum LING AfterZeroTenPos
    |
    ;

ThousandNum:
    Digit QIAN
    | LIANG QIAN
    ;

HundredPos:
    TenPos
    | HundredNum LING Digit
    | HundredNum AfterTenPos
    ;

AfterHundredPos:
    HundredNum AfterTenPos
    | HundredNum LING Digit
    |
    ;

HundredNum:
    Digit BAI
    | LIANG BAI
    ;

TenPos:
    SHI DigitZero
    | TenNum DigitZero
    | Digit
    ;

AfterTenPos:
    TenNum DigitZero
    | DigitZero
    ;

AfterZeroTenPos:
    TenNum DigitZero
    | Digit
    ;

TenNum:
    Digit SHI
    ;

Digit:
    DIGIT
    | ER
    ;

DigitZero:
    DIGIT
    | ER
    | 
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}