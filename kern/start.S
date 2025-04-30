.section .bss.stack
.global KERNEL_STACK
KERNEL_STACK:
    .skip 1 << 12 # 预留 4KiB 内核栈空间

.section .text.boot
.global _start
_start:
    # 设置栈指针
    la t0, KERNEL_STACK
    li t1, 1
    slli t1, t1, 12
    add sp, t0, t1
    # 跳转到内核主函数
    call main
