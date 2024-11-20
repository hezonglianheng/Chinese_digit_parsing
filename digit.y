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
3. 处理位数“万万”
4. 处理“三十三万零两百八”
5. 处理“两百万三”的非法性，并且解决文法上的冲突
*/

Number: // 数字
    DecBillionPos // 从最高位“万万万……”开始解析
    | Abbr // 数字的缩略形式单独解析
    | LING // “零”做特殊处理
    ;

DecBillionPos: // 亿位
    DecBillionNum AfterTenThousandPos // 亿位数后面跟着万位数
    | DecBillionNum LING AfterZeroMillionPos // 亿位数后面跟着“零”和百万位数
    | DecBillionNum LING HundredAbbr // 亿位数后面跟着“零”和百位数的缩略形式
    | DecBillionNum LING ThousandAbbr // 亿位数后面跟着“零”和十位数
    | TenThousandPos // 亿位留空
    ;

DecBillionNum: // 亿位数
    TenThousandPos YI // 亿位数嵌套万位数
    | LIANG YI // 两亿单独处理
    | WanWanNum
    // | WanWanNum YI
    | DecBillionNum YI
    ;

WanWanNum: // 万万位数
    Wan1 WAN
    | Wan2 WAN
    | Wan1 Wan1 WAN
    | Wan1 Wan2 WAN
    | Wan2 Wan1 WAN
    | Wan2 Wan2 WAN
    | Wan1 LING HundredPos WAN WAN
    | Wan2 LING ThousandPos WAN WAN
    ;

AfterZeroMillionPos: // 亿位数后面跟着“零”和百万位数
    MillionNum AfterThousandPos // X百万后面跟着千位数
    | MillionNum LING HundredPos // X百万后面跟着“零”和百位数
    | ThousandPos // X百万留空
    ;

MillionNum: // 百万位数
    HundredPos WAN // 百万位数嵌套百位数
    // | LIANG WAN // 两万单独处理
    ;

TenThousandPos: // 万位
    Wan1 AfterThousandPos // 万位数后面跟着千位数
    | Wan2 AfterThousandPos // 万位数后面跟着“零”和千位数
    | Wan2 LING ThousandPos // 万位数后面跟着“零”和千位数
    | Wan1 LING HundredPos // 万位数后面跟着“零”和百位数
    // | Wan2 LING HundredPos // 万位数后面跟着“零”和百位数
    | Wan1 ThousandAbbr // 万位数后面跟着千位数的缩略形式
    | Wan2 LING ThousandAbbr // 万位数后面跟着“零”和千位数的缩略形式
    | Wan1 LING HundredAbbr // 万位数后面跟着“零”和千位数的缩略形式
    | Wan2 LING HundredAbbr // 万位数后面跟着“零”和千位数的缩略形式
    | ThousandPos // 万位留空
    ;

AfterTenThousandPos: // 跟随的万位数
    Wan1 AfterThousandPos // 万位数后面跟着千位数
    | Wan2 AfterThousandPos // 万位数后面跟着“零”和千位数
    | Wan2 LING ThousandPos // 万位数后面跟着“零”和千位数
    | Wan1 LING HundredPos // 万位数后面跟着“零”和百位数
    // | Wan2 LING HundredPos // 万位数后面跟着“零”和百位数
    | Wan1 ThousandAbbr // 万位数后面跟着千位数的缩略形式
    | Wan2 LING ThousandAbbr // 万位数后面跟着“零”和千位数的缩略形式
    | Wan1 LING HundredAbbr // 万位数后面跟着“零”和千位数的缩略形式
    | Wan2 LING HundredAbbr // 万位数后面跟着“零”和千位数的缩略形式
    | // 留空
    ;

// X万
// 10-14修订: 拆解为更细的规则
Wan1:
    GeWan
    | LiangWan
    | ShiGeWan
    | JiShiGeWan
    | BaiGeWan
    | QianGeWan
    ;

Wan2:
    ShiLingWan
    | JiShiLingWan
    | BaiLingWan
    | QianLingWan
    ;

GeWan:
    Digit WAN
    ;

LiangWan:
    LIANG WAN
    ;

ShiGeWan:
    SHI GeWan
    ;

JiShiGeWan:
    TenNum GeWan
    ;

ShiLingWan:
    SHI WAN
    ;

JiShiLingWan:
    TenNum WAN
    ;

BaiGeWan:
    HundredNum LING GeWan
    | HundredNum JiShiGeWan
    ;

BaiLingWan:
    HundredNum WAN
    | HundredNum JiShiLingWan
    ;

QianGeWan:
    ThousandNum LING GeWan
    | ThousandNum LING JiShiGeWan
    | ThousandNum BaiGeWan
    ;

QianLingWan:
    ThousandNum WAN
    | ThousandNum LING JiShiLingWan
    | ThousandNum BaiLingWan
    ;

// 千位数
ThousandPos:
    HundredPos
    | ThousandNum AfterHundredPos
    | ThousandNum LING AfterZeroTenPos
    | ThousandNum HundredAbbr
    ;

AfterThousandPos:
    ThousandNum AfterHundredPos
    | ThousandNum LING AfterZeroTenPos
    | ThousandNum HundredAbbr
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
    HundredAbbr
    | ThousandAbbr
    | TenThousandAbbr
    ;

HundredAbbr:
    HundredNum Digit // “三百八”
    ;

ThousandAbbr:
    ThousandNum Digit // “三千八”
    ;

TenThousandAbbr:
    Wan1 Digit // “三万八”
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}