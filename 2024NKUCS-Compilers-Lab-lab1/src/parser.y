%{
    #include<iostream>
    #include<string>
    #include<vector>
    #include"ast.h"
    #include"SymbolTable.h"

    //声明词法分析函数和符号表
    extern int yylex();
    extern FILE *yyin;
    extern FIFE *yyout;
    extern int yylineno;
    extern char *yytext;

}