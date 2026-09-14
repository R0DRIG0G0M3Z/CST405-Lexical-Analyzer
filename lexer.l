%{
/* CST-405 Principles of Compiler Design
 * Project 1 - Lexical Analyzer
 * Rodrigo Gomez
 *
 * This lexer is based on my CST-301 project. It reads a .gcupl file,
 * returns the correct token, and prints the token kind and location.
 */

#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylineno;
extern char *yytext;

/* Token values returned by yylex(). */
enum TokenType {
    TOKEN_ERROR = 256,
    KW_INT,
    KW_CHAR,
    KW_RETURN,
    KW_READ,
    KW_WRITE,
    KW_WRITELN,
    KW_BREAK,
    KW_IF,
    KW_ELSE,
    KW_WHILE,
    ID,
    NUM,
    EQ,
    NE,
    LE,
    GE,
    AND,
    OR,
    ASSIGN,
    LT,
    GT,
    PLUS,
    MINUS,
    TIMES,
    DIVIDE,
    NOT,
    SEMICOLON,
    COMMA,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,
    LBRACKET,
    RBRACKET
};

int current_line = 1;
int current_column = 1;
int token_line = 1;
int token_column = 1;
int lexical_errors = 0;
const char *error_message = "";

const char *token_name(int token);
const char *token_kind(int token);

/* This saves where a token starts before Flex runs its action. */
#define YY_USER_ACTION                     \
    token_line = yylineno;                 \
    token_column = current_column;         \
    current_column += yyleng;
%}

%option noyywrap yylineno nodefault

DIGIT      [0-9]
LETTER     [A-Za-z]
ID_PATTERN {LETTER}({LETTER}|{DIGIT})*
NUM_PATTERN {DIGIT}+
BAD_ID     {DIGIT}+{LETTER}({LETTER}|{DIGIT})*
SPACE      [ \t\r]+

%%

"//".*              { /* Single line comments are ignored. */ }

"int"               { return KW_INT; }
"char"              { return KW_CHAR; }
"return"            { return KW_RETURN; }
"read"              { return KW_READ; }
"write"             { return KW_WRITE; }
"writeln"           { return KW_WRITELN; }
"break"             { return KW_BREAK; }
"if"                { return KW_IF; }
"else"              { return KW_ELSE; }
"while"             { return KW_WHILE; }

"=="                { return EQ; }
"!="                { return NE; }
"<="                { return LE; }
">="                { return GE; }
"&&"                { return AND; }
"||"                { return OR; }

"="                 { return ASSIGN; }
"<"                 { return LT; }
">"                 { return GT; }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return TIMES; }
"/"                 { return DIVIDE; }
"!"                 { return NOT; }

";"                 { return SEMICOLON; }
","                 { return COMMA; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }

{BAD_ID}            {
                        lexical_errors++;
                        error_message = "identifier cannot start with a number";
                        return TOKEN_ERROR;
                    }
{ID_PATTERN}        { return ID; }
{NUM_PATTERN}       { return NUM; }

{SPACE}             { /* Spaces and tabs do not make tokens. */ }
\n                  { current_column = 1; }

.                   {
                        lexical_errors++;
                        error_message = "invalid character";
                        return TOKEN_ERROR;
                    }

%%

/* Returns the readable name of each token. */
const char *token_name(int token)
{
    switch (token) {
        case KW_INT: return "KW_INT";
        case KW_CHAR: return "KW_CHAR";
        case KW_RETURN: return "KW_RETURN";
        case KW_READ: return "KW_READ";
        case KW_WRITE: return "KW_WRITE";
        case KW_WRITELN: return "KW_WRITELN";
        case KW_BREAK: return "KW_BREAK";
        case KW_IF: return "KW_IF";
        case KW_ELSE: return "KW_ELSE";
        case KW_WHILE: return "KW_WHILE";
        case ID: return "ID";
        case NUM: return "NUM";
        case EQ: return "EQ";
        case NE: return "NE";
        case LE: return "LE";
        case GE: return "GE";
        case AND: return "AND";
        case OR: return "OR";
        case ASSIGN: return "ASSIGN";
        case LT: return "LT";
        case GT: return "GT";
        case PLUS: return "PLUS";
        case MINUS: return "MINUS";
        case TIMES: return "TIMES";
        case DIVIDE: return "DIVIDE";
        case NOT: return "NOT";
        case SEMICOLON: return "SEMICOLON";
        case COMMA: return "COMMA";
        case LPAREN: return "LPAREN";
        case RPAREN: return "RPAREN";
        case LBRACE: return "LBRACE";
        case RBRACE: return "RBRACE";
        case LBRACKET: return "LBRACKET";
        case RBRACKET: return "RBRACKET";
        default: return "UNKNOWN";
    }
}

/* Returns the general kind of the token. */
const char *token_kind(int token)
{
    if (token >= KW_INT && token <= KW_WHILE) return "KEYWORD";
    if (token == ID) return "IDENTIFIER";
    if (token == NUM) return "CONSTANT";
    if (token >= EQ && token <= NOT) return "OPERATOR";
    if (token >= SEMICOLON && token <= RBRACKET) return "SYMBOL";
    return "ERROR";
}

int main(int argc, char *argv[])
{
    int token;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <sourcefile.gcupl>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("Could not open input file");
        return 1;
    }

    printf("%-15s %-12s %-18s %s\n", "TOKEN", "KIND", "LEXEME", "LOCATION");
    printf("----------------------------------------------------------------\n");

    /* yylex returns one token at a time until it reaches the end. */
    while ((token = yylex()) != 0) {
        if (token == TOKEN_ERROR) {
            printf("%-15s %-12s %-18s line %d, column %d - %s\n",
                   "LEXICAL_ERROR", "ERROR", yytext,
                   token_line, token_column, error_message);
        } else {
            printf("%-15s %-12s %-18s line %d, column %d\n",
                   token_name(token), token_kind(token), yytext,
                   token_line, token_column);
        }
    }

    fclose(yyin);

    if (lexical_errors == 0) {
        printf("\nSOURCE IS LEXICALLY CORRECT: no lexical errors found.\n");
        return 0;
    }

    printf("\nLexical analysis failed: %d lexical error(s) found.\n",
           lexical_errors);
    return 1;
}
