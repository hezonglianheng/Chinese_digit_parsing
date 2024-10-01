@echo off
set digit="digit"
set digitparsing="DigitParsing"
@echo on
bison -d %digit%.y
flex %digit%.l
g++ -o %digitparsing% %digitparsing%.cpp lex.yy.c %digit%.tab.c