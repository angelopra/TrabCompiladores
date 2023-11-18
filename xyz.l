%{
#include <stdlib.h>
#include "xyz.tab.h"

extern int yyerror (char const *msg, ...);
%}
MAIN        "main()"
FN          "fn"
VAR         "var"
RETURN      "return"
IF          "if"
ELSE        "else"
WHILE       "while"
TYPE_INT    "i64"
TYPE_FLOAT  "f64"
ID          [a-zA-Z][a-zA-Z_]*
FLOAT       [0-9]*"."[0-9]+
INT         [0-9]+
LPAR        "("
RPAR        ")"
COM         ","
LBRAC       "{"
RBRAC       "}"
SCOL        ";"
COL         ":"
EQ          "="
INCR        "++;"
DECR        "--;"
MINUS       "-"
DIF         "!="
EXCL        "!"
PLUS        "+"
ASTR        "*"
SLSH        "/"
PRCT        "%"
GEQ         ">="
LEQ         "<="
GT          ">"
LT          "<"
AND         "&&"
OR          "||"
SPACE       [ \t\n]
%option noyywrap nodefault yylineno
%%
{MAIN}          { return MAIN; }
{FN}            { return FN; }
{VAR}           { return VAR; }
{RETURN}        { return RETURN; }
{IF}            { return IF; }
{ELSE}          { return ELSE; }
{WHILE}         { return WHILE; }
{TYPE_INT}      { return TYPE_INT; }
{TYPE_FLOAT}    { return TYPE_FLOAT; }
{ID}            { yylval.s = strdup(yytext); return ID; }
{INT}           { yylval.i = atoi(yytext); return INT; }
{FLOAT}         { yylval.f = atof(yytext); return FLOAT; }
{LPAR}          { return LPAR; }
{RPAR}          { return RPAR; }
{COM}           { return COM; }
{LBRAC}         { return LBRAC; }
{RBRAC}         { return RBRAC; }
{SCOL}          { return SCOL; }
{COL}           { return COL; }
{EQ}            { return EQ; }
{INCR}          { return INCR; }
{DECR}          { return DECR; }
{MINUS}         { return MINUS; }
{DIF}           { return DIF; }
{EXCL}          { return EXCL; }
{PLUS}          { return PLUS; }
{ASTR}          { return ASTR; }
{SLSH}          { return SLSH; }
{PRCT}          { return PRCT; }
{GEQ}           { return GEQ; }
{LEQ}           { return LEQ; }
{GT}            { return GT; }
{LT}            { return LT; }
{AND}           { return AND; }
{OR}            { return OR; }
{SPACE}         { ; }
.               { yyerror("unknown token %s\n", yytext); }
%%
