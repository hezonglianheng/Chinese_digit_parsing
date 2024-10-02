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
done: 增加语法规则
1. 处理“四百零七亿零一百二十万零三百零七”和“四百零七亿零一百二十”的歧义问题
2. 处理“三百八”的解析问题
*/

/*
done: 语法规则
处理“万万”“万万亿”等问题
*/


Number: // 数字
    DecBillionPos // 从最高位“万万万……”开始解析
    | Abbr // 数字的缩略形式单独解析
    | LING // “零”做特殊处理
    ;

DecBillionPos: // 亿位
    DecBillionNum AfterTenThousandPos // 亿位数后面跟着万位数
    | DecBillionNum LING AfterZeroMillionPos // 亿位数后面跟着“零”和百万位数
    | TenThousandPos // 亿位留空
    ;

DecBillionNum: // 亿位数
    TenThousandPos YI // 亿位数嵌套万位数
    | LIANG YI // 两亿单独处理
    | WanWanNum
    | WanWanNum YI
    ;

WanWanNum: // 万万位数
    TenThousandNum WAN
    | TenThousandNum TenThousandNum WAN
    | TenThousandNum LING HundredPos WAN WAN
    ;

AfterZeroMillionPos: // 亿位数后面跟着“零”和百万位数
    MillionNum AfterThousandPos // X百万后面跟着千位数
    | MillionNum LING HundredPos // X百万后面跟着“零”和百位数
    | ThousandPos // X百万留空
    ;

MillionNum: // 百万位数
    HundredPos WAN // 百万位数嵌套百位数
    | LIANG WAN // 两万单独处理
    ;

TenThousandPos: // 万位
    TenThousandNum AfterThousandPos // 万位数后面跟着千位数
    | TenThousandNum LING HundredPos // 万位数后面跟着“零”和百位数
    | ThousandPos // 万位留空
    ;

AfterTenThousandPos: // 跟随的万位数
    TenThousandNum AfterThousandPos // 万位数后面跟着千位数
    | TenThousandNum LING HundredPos // 万位数后面跟着“零”和百位数
    | // 留空
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
    |
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

Abbr:
    ThousandNum Digit // “三千八”
    | HundredNum Digit // “三百八”
    | TenThousandNum Digit // “三万八”
    | DecBillionNum DIGIT // “三亿八”
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}