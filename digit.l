%{
#include <stdio.h>
#include <stdlib.h>
#include "digit.tab.h"
%}

Digit 一|三|四|五|六|七|八|九
Er 二
Liang 两
Ling 零
Shi 十
Bai 百
Qian 千
Wan 万
Yi 亿

%%
{Digit}    { return DIGIT; }
{Er}       { return ER; }
{Liang}    { return LIANG; }
{Ling}      { return LING; }
{Shi}       { return SHI; }
{Bai}       { return BAI; }
{Qian}      { return QIAN; }
{Wan}       { return WAN; }
{Yi}        { return YI; }
[ \t\n\r]+  { /* Skip whitespace */ }
.           { printf("Unknown character: %s\n", yytext); }
%%
