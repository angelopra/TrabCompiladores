/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_XYZ_TAB_H_INCLUDED
# define YY_YY_XYZ_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    FN = 258,                      /* FN  */
    ID = 259,                      /* ID  */
    INT = 260,                     /* INT  */
    FLOAT = 261,                   /* FLOAT  */
    LPAR = 262,                    /* LPAR  */
    RPAR = 263,                    /* RPAR  */
    COM = 264,                     /* COM  */
    TYPE_INT = 265,                /* TYPE_INT  */
    TYPE_FLOAT = 266,              /* TYPE_FLOAT  */
    LBRAC = 267,                   /* LBRAC  */
    RBRAC = 268,                   /* RBRAC  */
    VAR = 269,                     /* VAR  */
    SCOL = 270,                    /* SCOL  */
    COL = 271,                     /* COL  */
    EQ = 272,                      /* EQ  */
    MINUS = 273,                   /* MINUS  */
    EXCL = 274,                    /* EXCL  */
    PLUS = 275,                    /* PLUS  */
    ASTR = 276,                    /* ASTR  */
    SLSH = 277,                    /* SLSH  */
    PRCT = 278,                    /* PRCT  */
    GT = 279,                      /* GT  */
    LT = 280,                      /* LT  */
    GEQ = 281,                     /* GEQ  */
    LEQ = 282,                     /* LEQ  */
    DIF = 283,                     /* DIF  */
    AND = 284,                     /* AND  */
    OR = 285,                      /* OR  */
    INCR = 286,                    /* INCR  */
    DECR = 287,                    /* DECR  */
    RETURN = 288,                  /* RETURN  */
    IF = 289,                      /* IF  */
    ELSE = 290,                    /* ELSE  */
    WHILE = 291,                   /* WHILE  */
    MAIN = 292                     /* MAIN  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define FN 258
#define ID 259
#define INT 260
#define FLOAT 261
#define LPAR 262
#define RPAR 263
#define COM 264
#define TYPE_INT 265
#define TYPE_FLOAT 266
#define LBRAC 267
#define RBRAC 268
#define VAR 269
#define SCOL 270
#define COL 271
#define EQ 272
#define MINUS 273
#define EXCL 274
#define PLUS 275
#define ASTR 276
#define SLSH 277
#define PRCT 278
#define GT 279
#define LT 280
#define GEQ 281
#define LEQ 282
#define DIF 283
#define AND 284
#define OR 285
#define INCR 286
#define DECR 287
#define RETURN 288
#define IF 289
#define ELSE 290
#define WHILE 291
#define MAIN 292

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 30 "xyz.y"

        int i;
        char *s; /* string */
        float f;

#line 147 "xyz.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_XYZ_TAB_H_INCLUDED  */
