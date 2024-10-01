%{
#include <stdio.h>
#include <stdlib.h>
#include "digit.tab.h"
%}

Digit 一|二|三|四|五|六|七|八|九
Liang 两
Ling 零
Shi 十
Bai 百
Qian 千
Wan 万
Yi 亿

%%
{Digit}    { return DIGIT; }
{Liang}    { return LIANG; }
{Ling}      { return LING; }
{Shi}       { return SHI; }
{Bai}       { return BAI; }
{Qian}      { return QIAN; }
{Wan}       { return WAN; }
{Yi}        { return YI; }
.           { printf("Unknown character: %s\n", yytext); }
%%
