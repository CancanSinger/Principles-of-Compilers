#pragma once
#include <string>
#include <vector>

//AST节点的基类
class ASTNode {
    public:
        virtual ~ASTNode() = default; //虚析构函数，确保派生类的析构函数被调用
};

//表达式节点基类
class ExprNode: public ASTNode {
    public:
        enum ExprType {
            LITERAL,//literal的翻译是“字面值”，表示直接在代码中写出的固定值，比如数字5、字符串"hello"等
            IDENTIFIER,//identifier的翻译是“标识符”，表示代码中的一个变量名、函数名、结构体名等
            BINARY_OP,//binary operator的翻译是“二元运算符”，表示两个操作数之间的运算符，比如+、-、*、/等
            UNARY_OP,//unary operator的翻译是“一元运算符”，表示一个操作数之前的运算符，比如-、!.等
    
        };
    ExprType type;
    ExprNode(ExprType t):type(t) {}
};

//字面量表达式节点
class LiteralNode: public ExprNode {
    public:
        int value; // 假设字面量是整数类型
        LiteralNode(int val): ExprNode(LITERAL), value(val) {}
};

//标识符表达式节点
class IdentifierNode: public ExprNode {
    public:
        std::string name;
        IdentifierNode(std::string n): ExprNode(IDENTIFIER), name(n) {}
};
//二元运算表达式节点

// 二元操作表达式节点
class BinaryOpExprNode : public ExprNode {
public:
    ExprNode* left;
    ExprNode* right;
    std::string op;
    
    BinaryOpExprNode(ExprNode* l, const std::string& o, ExprNode* r) 
        : ExprNode(BINARY_OP), left(l), op(o), right(r) {}
};

// 一元操作表达式节点
class UnaryOpExprNode : public ExprNode {
public:
    ExprNode* operand;
    std::string op;
    
    UnaryOpExprNode(const std::string& o, ExprNode* expr) 
        : ExprNode(UNARY_OP), op(o), operand(expr) {}
};

//-----------------------------------------------------------------------------

// 语句节点基类
class StmtNode : public ASTNode {
public:
    enum StmtType {
        DECL,         // 声明语句
        ASSIGN,       // 赋值语句
        PRINT,        // 打印语句
        READ,         // 读取语句
        WHILE,        // while 循环语句
        IF,           // if 条件语句
        RETURN,       // return 返回语句
        BLOCK,        // 代码块语句
        EXPRESSION    // 表达式语句
    };
    StmtType type;
    
    StmtNode(StmtType t) : type(t) {}
};
//生明
class DeclStmtNode : public StmtNode {
public:
    std::string type;//变量类型
    std::string name;//变量名
    
    DeclStmtNode(const std::string& t, const std::string& n)
        : StmtNode(DECL), type(t), name(n) {}
        //t指的是变量类型，n指的是变量名
};
//赋值
class AssignStmtNode :public StmtNode {
public:
    std::string name;//赋值目标
    ExprNode* expr;//赋值表达式
    
    AssignStmtNode(const std::string& n, ExprNode* e)
        : StmtNode(ASSIGN), name(n), expr(e) {}
}
//打印
class PrintStmtNode : public StmtNode {
public:
    ExprNode* expr;//打印的表达式
    
    PrintStmtNode(ExprNode* e)
        : StmtNode(PRINT), expr(e) {}
};

//循环
class WhileStmtNode : public StmtNode {
public:
    ExprNode* condition;//循环条件
    StmtNode* body;//循环体
    
    WhileStmtNode(ExprNode* c, StmtNode* b)
        : StmtNode(WHILE), condition(c), body(b) {}
};

// if条件语句节点
class IfStmtNode : public StmtNode {
public:
    ExprNode* condition;      // 条件表达式
    StmtNode* thenStmt;       // then分支语句
    StmtNode* elseStmt;       // else分支语句
    
    IfStmtNode(ExprNode* cond, StmtNode* thenS, StmtNode* elseS = nullptr)
        : StmtNode(IF), condition(cond), thenStmt(thenS), elseStmt(elseS) {}
};

//return 语句节点
class ReturnStmtNode : public StmtNode {
public:
    ExprNode* expr;//返回表达式
    ReturnStmtNode(ExprNode* e)
        : StmtNode(RETURN), expr(e) {}
};

//代码块语句节点
class BlockStmtNode : public StmtNode {
public:
    std::vector<StmtNode*> statements;//语句列表
    BlockStmtNode(const std::vector<StmtNode*>& stmts)
        : StmtNode(BLOCK), statements(stmts) {} 
};

//表达式语句节点
class ExprStmtNode : public StmtNode {
public:
    ExprNode* expr;//表达式
    ExprStmtNode(ExprNode* e)
        : StmtNode(EXPRESSION), expr(e) {}
};
