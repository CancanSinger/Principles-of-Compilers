/* 2312136宋灿灿的代码-begin*/
//本文件用来声明

#pragma once
#include <string>
#include <unordered_map>
#include <vector>

enum BaseType {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_VOID,
    // 以后还可以加
    // TYPE_CONST_INT,
    // TYPE_ARRAY,
    // TYPE_FUNC
};

// 符号表条目，暂时包含符号名称信息
struct SymbolEntry{
    std::string name; //词素
    BaseType type; //类型
    //--------------------------

};

//符号表类，用来封装操作符号表的各种方法
class SymbolTable {
    private:
        //作用域的栈，比如递归调用时会有多个作用域，每一个栈存放一个哈希表
        std::vector<std::unordered_map<std::string,SymbolEntry*>> scope_stack;
    public:
        SymbolTable(); //构造函数
        ~SymbolTable(); //析构函数
        void enter_scope(); //进入一个新的作用域
        void exit_scope(); //退出当前作用域
        bool insert(SymbolEntry* entry); //在当前作用域插入一个新符号
        /*通过名字来向外部查找符号,
        比如：同一个函数名，先用当前的，如果没有，再用上一层的以此类推*/
        SymbolEntry* lookup(const std::string& name);
        /*只在当前作用域查找符号//用于检查重复定义*/
        SymbolEntry* lookup_current_scope(const std::string& name);
};
