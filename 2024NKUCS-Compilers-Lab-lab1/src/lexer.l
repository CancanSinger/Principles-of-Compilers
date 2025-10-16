/*定义段*/
%option noyywrap   
/* 禁用yywrap ,不读入多个文件,指出一个文件*/
%option nounput
/*允许在动作代码中将一个字符“推回”到输入流的头部,使得字符被重复扫描*/
%option noinput
/*为了提高性能,禁用不常用的函数来提高性能*/
/*这是flex文件的额定义快,flex会解析这段内容,将其内容原样复制到输出文件的顶部*/
%top{
    #include <stdarg.h>
    #include "common.h"
}
/* 这是c语言的内嵌代码快*/
%{
    extern dump_type_t dump_type;
    int yycol=0;//定义全局变量记录列号
    //重构dump_tokens函数,实现输出对齐
    typedef enum{
        KIND_STRING,
        KIND_INT,
        KIND_PTR,
        KIND_NONE,
        KIND_FLOAT} kindUncen;//用于处理最后一列不确定的类型配合通用指针void*来处理

       inline void dump_tokens(const char* type, const char* text,
                            int line, int col,
                            kindUncen kind, void* attr=NULL) {
        if (dump_type != TOKENS) return;
        // 左对齐输出前几列
        fprintf(yyout, "%-10s %-10s %-5d %-5d ", type, text, line, col);
        // 根据类型输出最后一列
        switch (kind) {
            case KIND_STRING:
                fprintf(yyout, "%-10s\n", (char*)attr);
                break;
            case KIND_INT:
                fprintf(yyout, "%-10d\n", *(int*)attr);
                break;
            case KIND_PTR:
                fprintf(yyout, "%-10p\n", attr);
                break;
            case KIND_NONE:
                fprintf(yyout,"%-10s\n","");
                break;
            case KIND_FLOAT:
                fprintf(yyout,"%-10f\n",*(float*)attr);
                break;
            default:
                fprintf(yyout, "\n");
        }
    }
%}
/*定义词法分析器接受的字符集*/
%{
    //2312130景千夏的代码
    //在flex文件中定义全局变量
    extern int yylex();
    extern FILE* yyin;
    extern int yylineno;
    extern int yycol;
%}
/*定义词法分析器接受的字符集*/
%{
    //2312130景千夏的代码
    //在flex文件中定义全局变量
    extern int yylex();
    extern FILE* yyin;
    extern int yylineno;

%}

/* definitions section */
/*十进制整数的正则表达式*/
DECIMIAL ([1-9][0-9]*|0)
/*标识符的正则表达式*/
ID [[:alpha:]_][[:alpha:][:digit:]_]*
/*2312130景千夏的代码*/
/* ID [a-zA-Z_][a-zA-Z0-9_]* */
/*换行符的正则表达式*/
EOL (\r\n|\n|\r)
WHITE [\t]
/*  Your code here (lab1). */
/* 定义int的各种进制的正则表达式*/
OctNum (0[0-7][0-7]*|0[oO][0-7]+)

HexNum (0[xX][0-9a-fA-F]+|[0-9a-fA-F]+[hH])
/* 浮点型常量的正则表达式*/
FloatNum ([0-9]+.[0-9]*[eE]?[+-]?[0-9]*|[0-9]+[.]?[0-9]*)
/* floatnum的另外一种定义方式*/
Dight [0-9]
EXP ([eE][+-]?[Dight]+)
FloatNum2 (({Dight}+\.{Dight}*{EXP}?)|({Dight}+{EXP})|\.{Dight}+{EXP}?)
/*注释的正则表达式*/
/* 为了更简单的处理注释的正则表达式,对注释的表达式分开来写*/
/*单行注释*/
ANNOTATION1 "//"[^\n]* 
/*多行注释*/
ANNOTATION2 "/*"([^*]|\*+[^/])*\*+"/"
%%
    /* rules section */
    //引用底座的代码
    //2312130景千夏的代码(在底座的基础上对代码进行修改)
    //这些内容是标识符和界限符的处理,该类单词是一词一码
"int" {
    dump_tokens("INT", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"void" {
    dump_tokens("VOID", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"if" {
    dump_tokens("IF", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"else" {
    dump_tokens("ELSE", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"return" {
    dump_tokens("RETURN", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"=" {
    dump_tokens("ASSIGN", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"<" {
    dump_tokens("LESS", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"+" {
    dump_tokens("ADD", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

";" {
    dump_tokens("SEMICOLON", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}
"," {
    dump_tokens("COMMA", yytext, yylineno, yycol,KIND_NONE,NULL);
}

"(" {
    dump_tokens("LPAREN", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

")" {
    dump_tokens("RPAREN", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"{" {
    dump_tokens("LBRACE", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

"}" {
    dump_tokens("RBRACE", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

{ID} {
    dump_tokens("ID", yytext, yylineno, yycol,KIND_NONE,NULL);
    yycol+=yyleng;//列号加上单词长度
}

{EOL}  {
    yylineno++;//行号加1
    yycol=0;//列号归零
}

{WHITE} {yycol++;} //为了记录列号,将空白符号加上列号

{DECIMIAL} {
    int decimal;
    decimal = atoi(yytext);
    dump_tokens("DECIMAL", yytext, yylineno,yycol, KIND_INT,&decimal);
    yycol+=yyleng;//列号加上单词长度
}

{HexNum} {//十六进制的处理
    long int decimal;
    decimal =strtol(yytext,NULL ,16);//十六进制的处理
    dump_tokens("HEXADECIMAL ",yytext, yylineno,yycol,KIND_INT, &decimal);
    yycol+=yyleng;//列号加上单词长度

}

{OctNum} {//八进制处理
    long int decimal;
    decimal =strtol(yytext,NULL ,8); //八进制转化为十进制
    dump_tokens("OCTAL ",yytext, yylineno,yycol,KIND_INT,&decimal);
    yycol+=yyleng;//列号加上单词长度
}

{FloatNum2} {//浮点数处理
    float fnum;
    fnum=strtof(yytext,NULL);
    dump_tokens("FLOAT ", yytext, yylineno ,yycol,KIND_FLOAT,&fnum);
    yycol+=yyleng;//列号加上单词长度
}
{ANNOTATION1}|{ANNOTATION2} {
    //忽略注释并且处理行号和列号
    //递增行号,如果遇到换行符就行号加1,列号归零
    int i;
    for (i=0;i<yyleng;i++){
        if(yytext[i]=='\n'){
            yylineno++;
            yycol=0;
        }else{
            yycol++;
        }
    }
}
%%
/* user code section */
