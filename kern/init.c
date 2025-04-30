#include <stdint.h>

int64_t putchar(char ch)
{
    register uint64_t a0 asm("a0") = ch;
    register uint64_t a7 asm("a7") = 0x1;
    asm volatile("ecall"
                 : "+r"(a0)
                 : "r"(a7)
                 : "memory");
    return (int64_t)a0;
}

void halt(void)
{
    // QEMU virt机器的特殊退出机制
    *(volatile uint32_t *)(0x100000) = 0x5555; //  magic shutdown code
    while (1)
        ;
}

// 假设这是内核的主函数
void main(uint64_t hartid, uint64_t dtb_addr)
{
    (void)hartid;
    (void)dtb_addr;
    putchar('H');
    putchar('e');
    putchar('l');
    putchar('l');
    putchar('o');
    putchar(',');
    putchar(' ');
    putchar('R');
    putchar('I');
    putchar('S');
    putchar('C');
    putchar('-');
    putchar('V');
    putchar('!');
    putchar('\n');
    halt();
}