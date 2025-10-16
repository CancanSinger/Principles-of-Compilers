//本文件用来实现具体的函数
/*2312136宋灿灿的文件夹*/
#include "SymbolTable.h"//makefile中会包含-Iinclude

// 构造函数，初始化一个空的哈希表
SymbolTable::SymbolTable() {
    // 初始时，符号表栈中包含一个空的哈希表，代表全局作用域
    scope_stack.emplace_back();//emplace_back()在vector末尾创建一个空的元素
}

// 析构函数，释放所有符号条目的内存
SymbolTable::~SymbolTable() {
    // 遍历所有作用域
    for (auto& scope : scope_stack) {
        // 遍历该作用域中的所有符号条目
        for (auto const& [name, entry] : scope) {
            delete entry; // 释放为 SymbolEntry 分配的内存
        }
    }
}

//实现进入一个新的作用域
void SymbolTable::enter_scope() {
    // 在栈顶添加一个新的空哈希表，代表新的作用域
    scope_stack.emplace_back();
}

//实现退出当前作用域
void SymbolTable::exit_scope() {
    if (scope_stack.size() > 1) { // 保证至少有两个作用域，才能退出一个
        scope_stack.pop_back(); // 移除栈顶的哈希表，退出当前作用域
    }
}
//在当前作用域插入一个新符号
bool SymbolTable::insert(SymbolEntry* entry) {
    if (scope_stack.empty()) {
        return false; // 如果没有作用域，插入失败
    }
    auto& current_scope = scope_stack.back(); // back是最末尾的意思，为了获取当前作用域的哈希表
    // 检查当前作用域是否已经存在同名符号
    if (current_scope.find(entry->name) != current_scope.end()) {
        return false; // end()是指的最后一个元素的下一个位置，
                    //默认没找到的时候find会返回end()，说明是重复定义，插入失败
    }
    // 插入新符号
    current_scope[entry->name] = entry;
    return true; // 插入成功
}
//通过词素来向外部查找符号，比如打印的时候，同一个元素名，先用当前的，如果没有，再用上一层的以此类推
SymbolEntry* SymbolTable::lookup(const std::string& name) {
    // 从栈顶开始，逐层向下查找
    for (auto it = scope_stack.rbegin(); it != scope_stack.rend(); ++it) {//注意；
        auto& scope = *it; // 当前作用域的哈希表
        auto found = scope.find(name);
        if (found != scope.end()) {
            return found->second; // 找到符号，返回对应的 SymbolEntry 指针
        }
    }
    return nullptr; // 没有找到符号，返回空指针
}
//只在当前作用域查找符号
SymbolEntry* SymbolTable::lookup_current_scope(const std::string& name) {
    if (scope_stack.empty()) {
        return nullptr; // 如果没有作用域，返回空指针
    }
    auto& current_scope = scope_stack.back(); // 获取当前作用域的哈希表
    auto found = current_scope.find(name);
    if (found != current_scope.end()) {
        return found->second; // 找到符号，返回对应的 SymbolEntry 指针
    }
    return nullptr; // 没有找到符号，返回空指针
}



