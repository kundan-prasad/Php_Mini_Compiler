%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "y.tab.h"
#define UNDEFINED 0
#define yyclearin (yychar = -1)

int ln_num = 1;
int nic = 0;
int pnic = -1;
int c_scope = 0;
int ncond = 0;
int v_for, v_while, v_if, v_else_if, v_else, v_echo, v_print;
int v_temp;//use_check
int v_label;
char* t_identifier_name;
char* rc0;
char* rc1;
char* rc2;
int t_eq = 0;
char* temp;
int vld;
void s_current_lookup(char *idi);
void insert(char *name, int len, int type, int lineno, int c_scope);
void symtab_dump(FILE *of, int dp);
void e_vld(int vld);
%}
%%

((#).*) {/*return T_S_COMMENT;*/}
(\/\/.*) {/*return T_S_COMMENT;*/}
"/*"([^*]|\*+[^*/])*\*+"/" {
                                int i=0;
                                while(yytext[i]!='\0')
                                {
                                    if(yytext[i]=='\n')
                                        ln_num++;
                                    i++;
                                };/*return T_M_COMMENT;*/
                            }
[ \t] {/*return T_WHITESPACE;*/}
[$][a-zA-Z_]+[a-zA-Z_0-9]* {
                                t_eq = 0;
                                insert(yytext, strlen(yytext), UNDEFINED, ln_num, c_scope);
                                s_current_lookup(yytext);
                                char *p = strdup(yytext); yylval.string=p;
                                t_identifier_name = (char*)malloc(sizeof(char)*200);
                                strcpy(t_identifier_name, yytext);

                                if(ncond == 0)
                                {
                                    rc0 = (char*)malloc(sizeof(char)*250);
                                    strcpy(rc0, yytext);
                                    //printf("%s--------\n", strdup(yytext));
                                }
                                if(ncond == 2)
                                {
                                    rc2 = (char*)malloc(sizeof(char)*250);
                                    strcpy(rc2, yytext);
                                }
                                else{ncond += 1;}

                                bn(t_identifier_name);
                                symtab_dump(yyout, 0);
                                ;return T_IDENTIFIER;
                            }
";" {t_eq = 0;ncond = 0;nic+=1;return T_SEMI_COLON;}

"<?php" {t_eq = 0;nic+=1;return T_OPEN_TAG;}
"?>" {t_eq = 0;nic+=1;return T_CLOSE_TAG;}

"$" {t_eq = 0;return T_DOLLAR;}
"_" {t_eq = 0;return T_UNDERSCORE;}
"(" {ncond = 0;t_eq = 0;nic+=1;return T_O_NBRAC;}
")" {ncond = 0;t_eq = 0;nic+=1;return T_C_NBRAC;}
"{" {ncond = 0;t_eq = 0;nic+=1;c_scope++;return T_O_CBRAC;}
"," {ncond = 0;t_eq = 0;return T_COMMA;}
"}" {ncond = 0;t_eq = 0;nic+=1;c_scope--;return T_C_CBRAC;}
"." {t_eq = 0;return T_CONCAT;}
((\"[^"]*\")|(\'[^']*\')) {t_eq = 0;
    char *p = strdup(yytext);p++;p[strlen(p)-1] = 0;yylval.string=p;bn(strdup(yytext));
                            if(ncond == 0)
                            {
                                rc0 = (char*)malloc(sizeof(char)*250);
                                strcpy(rc0, strdup(yytext));
                            }
                            if(ncond == 2)
                            {
                                rc2 = (char*)malloc(sizeof(char)*250);
                                strcpy(rc2, yytext);
                                ncond = 0;
                            }
                            else{ncond += 1;}
                            return T_STR;
                        }

\" {t_eq = 0;return T_DOUBLE_QUOTE;}
\' {t_eq = 0;return T_SINGLE_QUOTE;}

"=" {bn("=");t_eq = 1;return T_AND_EQUAL;}
"==" {bn("==");t_eq = 0;return T_IS_EQUAL;}
"===" {bn("===");t_eq = 0;return T_IDENTICAL;}
"!=" {bn("!=");t_eq = 0;return T_NOT_EQUAL;}
"!==" {bn("!==");t_eq = 0;return T_NOT_IDENTICAL;}
"<" {bn("<");t_eq = 0;return T_LESSER_THAN;}
">" {bn(">");t_eq = 0;return T_GREATER_THAN;}
"<=" {bn("<=");t_eq = 0;return T_LESSER_EQUAL;}
">=" {bn(">=");t_eq = 0;return T_GREATER_EQUAL;}
"and" {ncond = 0;bn("AND");t_eq = 0;return T_LOGICAL_AND;}
"&&" {ncond = 0;bn("&&");t_eq = 0;return T_AND_OP;}
"or" {bn("OR");t_eq = 0;return T_LOGICAL_OR;}
"||" {bn("||");t_eq = 0;return T_OR_OP;}
"xor" {bn("XOR");t_eq = 0;return T_LOGICAL_XOR;}
"!" {bn("!");t_eq = 0;return T_NOT;}

"for" {ncond = 0;return T_FOR;}
"while" {ncond = 0;return T_WHILE;}
"if" {ncond = 0;return T_IF;}
"else" {ncond = 0;return T_ELSE;}
"elseif" {ncond = 0;return T_ELSEIF;}
"echo" {ncond = 0;return T_ECHO;}
"print" {ncond = 0;return T_PRINT;}

(?i:true) {bn("TRUE");t_eq = 0;return T_BOOL_T;}
(?i:frue) {bn("FALSE");t_eq = 0;return T_BOOL_F;}
"++" {bn("++");t_eq = 0;return T_INCREMENT;}
"--" {bn("--");t_eq = 0;return T_DECREMENT;}
"+" {bn("+");return T_PLUS;}
"-" {bn("-");return T_MINUS;}
"/" {bn("/");t_eq = 0;return T_DIVIDE;}
"*" {bn("*");t_eq = 0;return T_MULTIPLY;}

(?i:null) {bn("NULL");t_eq = 0;return T_NULL;}

[a-zA-Z]+ {return T_LETTERS;}
                                
[0-9]+ {
    yylval.integer=atoi(yytext);bn(strdup(yytext));
                                //printf("number ------ [%s]\n", strdup(yytext));
                                if(ncond == 0)
                                {
                                    rc0 = (char*)malloc(sizeof(char)*250);
                                    strcpy(rc0, yytext);
                                    /*printf("%s--\n", rc0);*/
                                }
                                if(ncond == 2)
                                {
                                    rc2 = (char*)malloc(sizeof(char)*250);
                                    strcpy(rc2, yytext);
                                    ncond = 0;
                                }
                                else{ncond += 1;}
                                return T_INTEGER;
            }
([0-9]+)"."([0-9]+) {
    yylval.decimal=atof(yytext);bn(strdup(yytext));
                                if(ncond == 0)
                                {
                                    rc0 = (char*)malloc(sizeof(char)*250);
                                    strcpy(rc0, yytext);
                                }
                                if(ncond == 2)
                                {
                                    rc2 = (char*)malloc(sizeof(char)*250);
                                    strcpy(rc2, yytext);
                                    ncond = 0;
                                }
                                else{ncond += 1;}
                                return T_FLOAT;
                    }


\r {ncond = 0;nic+=1;/*return T_CR;*/;}
\n {ncond = 0;nic+=1;ln_num++;/*return T_NEW_LINE;*/;}

. {return T_ANY_CHAR;}
%%
int yywrap()
{
    return 1;
}


