/* src/parser.y - 语法分析器定义文件 */
%{
#include "common.h"
#include "SymbolTable.h"
#include <stdio.h>
#include <string.h>

// 从词法分析器中导入的外部函数和变量
extern int yylex();
extern int yylineno;
extern char* yytext;
extern FILE* yyin;

// 语法分析器的错误报告函数
void yyerror(const char *s);

// 全局符号表实例
SymbolTable symbol_table;

// 声明一个函数，用于从 parser.tab.h 中获取 token 名称
const char* get_token_name(int token);

%}

/* Bison 声明段 */

// 定义 token 和非终结符可能携带的语义值类型
%union {
    int int_val;
    float float_val;
    char* str_val;
    // 以后可以添加指向 AST 节点或符号表条目的指针
    struct SymbolEntry* entry; 
}

// 定义词法分析器将返回的 token 类型
// %token <union字段> TOKEN名
// 不带值的 token
%token T_INT T_VOID T_IF T_ELSE T_RETURN T_CONST T_WHILE T_BREAK T_CONTINUE

// 带字符串值的 token (标识符)
%token <str_val> T_ID

// 带整数值的 token
%token <int_val> T_DEC_INT T_OCT_INT T_HEX_INT

// 带浮点数值的 token
%token <float_val> T_FLOAT

// 运算符和分隔符 (通常不需要在 %token 中声明，除非它们有特殊的优先级或关联性)
// Bison 会将单字符字面量（如 '+' ';'）自动视为 token
// 这里为了清晰，我们也可以声明它们
%token T_ASSIGN T_LESS T_ADD T_SUB T_MUL T_DIV T_MOD
%token T_EQ T_NE T_LT T_GT T_LE T_GE
%token T_AND T_OR T_NOT
%token T_SEMICOLON T_COMMA T_LPAREN T_RPAREN T_LBRACE T_RBRACE T_LBRACK T_RBRACK


/* 语法规则段 */
%%

// 这是一个开始符号，代表整个编译单元
program:
    /* 一个程序由一系列外部声明组成，这里暂时为空 */
    ;

%%

/* C 代码段 */

// 语法分析错误报告函数
void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
}
