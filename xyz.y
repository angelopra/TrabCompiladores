%{
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include<string.h>
#include<ctype.h>

#define MAXTOKEN 64
#define MAXSYMS 1024

struct symtab {
        char scope[MAXTOKEN];
        char id[MAXTOKEN];
        char type;
};

// Stop warning about implicit declaration of yylex().
extern int yylex();

int yyerror(const char *msg, ...);
void setScope(char *scope);
void install(char *id, char type);
void verifyIfDeclared(char *id);

static struct symtab symbols[MAXSYMS];
static int symbolsLength = 0;
static int symbolsInCurrentScope = 0;

/* 
  To debug, run 
  bison --verbose --debug -d file.y 
*/
int yydebug = 1;

%}

%union {
        char *s;
        char c;
}

/* Gramatica */

%token  FN // fn
        <s> ID // [a-zA-z][a-zA-z_]*
        INT // [-]?[0-9]+
        FLOAT // [-]?[0-9]*\.[0-9]+
        LPAR // (
        RPAR // )
        COM // ,
        TYPE_INT // i64
        TYPE_FLOAT // f64
        LBRAC // {
        RBRAC // }
        VAR // var
        SCOL // ;
        COL // :
        EQ // =
        MINUS // -
        EXCL // !
        PLUS // +
        ASTR // *
        SLSH // /
        PRCT // %
        GT // >
        LT // <
        GEQ // >=
        LEQ // <=
        DIF // !=
        AND // &&
        OR // ||
        INCR // ++;
        DECR // --;
        RETURN // return
        IF // if
        ELSE // else
        WHILE // while
        <s> MAIN // main

%type <c> type

%%

program         : functions
                ;

functions       : function functions
                | main
                ;

function        : FN ID LPAR parameters RPAR fBody      { setScope($2); }
                ;

parameters      : parameter COM parameters
                | parameter
                |
                ;

parameter       : ID type                               { install($1, $2); }
                ;

type            : TYPE_INT                              { $$ = 'i'; }
                | TYPE_FLOAT                            { $$ = 'f'; }
                ;

fBody           : LBRAC statements return RBRAC
                ;

statements      : statement statements
                |
                ;

statement       : assignment
                | VAR declarations
                | unary
                | functionCall SCOL
                | if
                | while
                ;

declarations    : declaration declarations
                | declaration
                | statements
                ;

declaration     : ID COL type EQ expression SCOL        { install($1, $3); }
                ;

expression      : expression  op  expression
                | functionCall
                | ID                                    { verifyIfDeclared($1); }
                | literal
                | LPAR expression RPAR
                | MINUS expression
                | EXCL expression
                ; 

op              : PLUS
                | MINUS
                | ASTR
                | SLSH
                | PRCT
                | GT
                | LT
                | GEQ
                | LEQ
                | DIF
                | AND
                | OR
                ;

functionCall    : ID LPAR arguments RPAR                { verifyIfDeclared($1); }
                ;

arguments       : expression COM arguments
                | expression
                |
                ;

literal         : INT
                | FLOAT
                ;

assignment      : ID EQ expression SCOL                 { verifyIfDeclared($1); }
                ;

unary           : ID inOrDecrement SCOL                 { verifyIfDeclared($1); }
                | inOrDecrement ID SCOL                 { verifyIfDeclared($2); }
                ;

inOrDecrement   : INCR
                | DECR
                ;

return          : RETURN expression SCOL
                ;

if              : IF expression body else
                ;

body            : LBRAC statements RBRAC
                | LBRAC statements return RBRAC
                ;

else            : ELSE body
                |
                ;

while           : WHILE expression body
                ;

main            : FN MAIN LPAR RPAR fBody               { setScope($2); }
                ;

%%


#include "xyz.yy.c"

int yyerror(const char *msg, ...) {
	va_list args;

	va_start(args, msg);
	vfprintf(stderr, msg, args);
	va_end(args);

        return 0;
}

int find(char *id) {
        int i;
        for (i = 0; i < symbolsLength - symbolsInCurrentScope; i++) { // verify if declared globally
                if (strcmp(symbols[i].scope, "global") == 0 && strcmp(symbols[i].id, id) == 0) {
                        return 1;
                }
        }
        for (i = symbolsLength-1; i >= symbolsLength - symbolsInCurrentScope; i--) { // verify if declared in current scope
                if (strcmp(symbols[i].id, id) == 0) {
                        return 1;
                }
        }
        return 0;
}

void setScope(char *scope) {
        int i;
        for (i = symbolsLength-1; i >= symbolsLength - symbolsInCurrentScope; i--) {
                strncpy(symbols[i].scope, scope, MAXTOKEN);
        }
        install(scope, 'm');
        strncpy(symbols[symbolsLength-1].scope, "global", MAXTOKEN);
        symbolsInCurrentScope = 0;
}

void install(char *id, char type) {
        if (find(id)) {
                printf("\n\nERROR: double declaration %s.\n\n", id);
                exit(1);
        }
        symbolsInCurrentScope++;
        struct symtab *p;
        p = &symbols[symbolsLength++];
        strncpy(p->id, id, MAXTOKEN);
        p->type = type;
}

void verifyIfDeclared(char *id) {
        if (!find(id)) {
                printf("\n\nERROR: id %s not declared.\n\n", id);
                exit(1);
        }
}

int main (int argc, char **argv) {
        FILE *fp;
        int i;

        if (argc <= 0) { 
                fprintf(stderr, "usage: %s file\n", argv[0]);
		return 1;
	}

        fp = fopen(argv[1], "r");
        if (!fp) {
                perror(argv[1]);
		return errno;
	}

        yyin = fp;
        yyparse();

        printf("=====================================\n");
        for (i = 0; i < symbolsLength; i++) {
                switch (symbols[i].type) {
                        case 'i':
                        printf("\t%s.%s [i64]\n", symbols[i].scope, symbols[i].id);
                        break;
                        case 'f':
                        printf("\t%s.%s [f64]\n", symbols[i].scope, symbols[i].id);
                        break;
                        case 'm':
                        printf("END OF  %s  SCOPE\n", symbols[i].id);
                        printf("=====================================\n");
                        break;
                }

        }

        return 0;
}
