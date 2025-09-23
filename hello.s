/*
 * Simple "Hello, World!" program
 */
    .global _start

    .text
_start:
    // write(1, "Hello, World!\n", 14)
    mov x0, #1      // stdout
    ldr x1, =msg    // message address
    mov x2, #14     // message length
    mov x8, #64     // write syscall
    svc #0          // make syscall

    // exit(0)
    mov x0, #0      // exit code
    mov x8, #93     // exit syscall
    svc #0          // make syscall

    .data
msg:
    .asciz "Hello, World!\n"
