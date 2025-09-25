    .arch armv8-a          // 指定目标架构：aarch64
    .text                  // 代码段开始
    .global a              // 声明全局变量 a

    .bss                   // 未初始化数据段
    .align 2               // 按 2^2=4 字节对齐
a:
    .zero 4                // 为 a 分配 4 字节空间，初始为 0

    .global b              // 声明全局变量 b
    .align 2
b:
    .zero 4                // 为 b 分配 4 字节空间，初始为 0

    .text
    .align 2
    .global max
max:
    sub    sp, sp, 16      // 栈顶指针下移 16 字节，为局部变量分配空间
    str    w0, [sp, 12]    // 将第一个参数存储到栈上 sp+12
    str    w1, [sp, 8]     // 将第二个参数存储到栈上 sp+8
    ldr    w1, [sp, 12]    // 将第一个参数加载到 w1
    ldr    w0, [sp, 8]     // 将第二个参数加载到 w0
    cmp    w1, w0          // 比较两个参数大小 (a-b)
    blt    .L2             // 如果 w1 < w0，跳转到 .L2
    ldr    w0, [sp, 12]    // 否则返回第一个参数
    b      .L3             // 跳转到 .L3
.L2:
    ldr    w0, [sp, 8]     // 如果 w1 < w0，返回第二个参数
.L3:
    add    sp, sp, 16      // 恢复栈顶指针（释放栈空间）
    ret                    // 返回调用者

    .section .rodata       // 只读数据段
    .align 3
.LC0:
    .string "%d,%d"        // scanf 的格式字符串
    .align 3
.LC1:
    .string "max=%d\n"     // printf 的格式字符串

    .text
    .align 2
    .global main
main:
    stp   x29, x30, [sp, -16]!   // 函数入口：保存 fp 和 lr
    mov   x29, sp                // 设置新的帧指针

    // 调用 scanf("%d,%d", &a, &b)
    adrp  x0, b                  // 加载全局变量 b 的高位地址
    add   x2, x0, :lo12:b        // 完整地址放入 x2
    adrp  x0, a                  // 加载全局变量 a 的高位地址
    add   x1, x0, :lo12:a        // 完整地址放入 x1
    adrp  x0, .LC0               // 加载格式串 LC0 的高位
    add   x0, x0, :lo12:.LC0     // 拼出格式串完整地址到 x0
    bl    __isoc99_scanf         // 调用 scanf

    // 从内存取出 a, b
    adrp  x0, a
    add   x0, x0, :lo12:a
    ldr   w2, [x0]               // w2 = a
    adrp  x0, b
    add   x0, x0, :lo12:b
    ldr   w0, [x0]               // w0 = b

    // 调用 max(a, b)
    mov   w1, w0                 // 第二个参数 = b
    mov   w0, w2                 // 第一个参数 = a
    bl    max                    // 调用 max，返回值在 w0

    // printf("max=%d\n", 返回值)
    mov   w1, w0                 // w1 = max 的返回值
    adrp  x0, .LC1               // 加载 LC1 格式串高位
    add   x0, x0, :lo12:.LC1     // 拼出完整地址到 x0
    bl    printf                 // 调用 printf

    // main 返回 0
    mov   w0, 0
    ldp   x29, x30, [sp], 16     // 恢复 fp 和 lr
    ret                          // 返回调用者（exit）
    