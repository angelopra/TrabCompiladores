%{
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#define MAXTOKEN 32
#define MAXSYMS 256

struct symtab {
        char id[MAXTOKEN];
        int val;
};

extern void assign(char *id, int val);
// Stop warning about implicit declaration of yylex().
extern int yylex();
int yyerror(const char *msg, ...);

static struct symtab symbols[MAXSYMS];
static int nsyms = 0; /* number of symbols */

/* 
  To debug, run 
  bison --verbose --debug -d file.y 
*/
int yydebug = 1;

%}

%union {
        int i;
        char *s; /* string */
        float f;
}

/* Gramatica */

%token  FN // fn
        <s> ID // [a-zA-z][a-zA-z_]*
        <i> INT // [0-9]+
        <f> FLOAT // [0-9]*'.'[0-9]+
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
        MAIN // main()
        // PARAMS // ID TYPE(,ID TYPE)* | ''

%start program

%%

program         : functions main
                | main
                ;

functions       : function functions
                ;

function        : FN ID LPAR parameters RPAR fBody
                ;

parameters      : parameter moreParameters
                |
                ;

moreParameters  : COM parameter moreParameters
                |
                ;

parameter       : ID type
                ;

type            : TYPE_INT
                | TYPE_FLOAT
                ;

fBody           : LBRAC statements return RBRAC
                ;

statements      : statement statements
                |
                ;

statement       : VAR declarations
                | assignment
                | increment
                | decrement
                | return
                | functionCall SCOL
                | if
                | while
                ;

declarations    : declaration declarations
                | declaration
                ;

declaration     : ID COL type EQ expression SCOL
                ;

expression      : expression  op  expression
                | functionCall
                | ID
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

functionCall    : ID LPAR arguments RPAR
                ;

arguments       : expression moreArgs
                |
                ;

moreArgs        : COM expression moreArgs
                |
                ;

literal         : INT
                | FLOAT
                ;

assignment      : ID EQ expression SCOL                 //{ assign($1, $3); }
                ;

increment       : ID INCR                               
                ;

decrement       : ID DECR
                ;

return          : RETURN expression SCOL
                ;

if              : IF expression body else
                ;

body            : LBRAC statements RBRAC
                ;

else            : ELSE body
                |
                ;

while           : WHILE expression body
                ;

main            : FN MAIN fBody
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

static struct symtab *lookup(char *id) {
        int i;
        struct symtab *p;

        for (i = 0; i < nsyms; i++) {
                p = &symbols[i];
                if (strncmp(p->id, id, MAXTOKEN) == 0)
                        return p;
        }

        return NULL;
}

static void install(char *id, int val) {
        struct symtab *p;

        p = &symbols[nsyms++];
        strncpy(p->id, id, MAXTOKEN);
        p->val = val;
}

void assign(char *id, int val) {
        struct symtab *p;

        p = lookup(id);
        if(p == NULL)
                install(id, val);
        else
                p->val = val;
}


int main (int argc, char **argv) {
        FILE *fp;
        int i;
        struct symtab *p;

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
        do {
                yyparse();
        } while(!feof(yyin));


        for (i = 0; i < nsyms; i++) {
                p = &symbols[i];
                printf("%s=%d\n", p->id, p->val);
        }

        return 0;
}