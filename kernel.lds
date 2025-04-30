OUTPUT_ARCH(riscv)
ENTRY(_start)
BASE_ADDR = 0x80200000;
KERNEL_END_ADDR = 0x80400000;
SECTIONS {
    . = BASE_ADDR;
    .text : {
        PROVIDE(stext = .);
        *(.text.boot)
        *(.text)
        PROVIDE(etext = .);
    }
    . = ALIGN(4K);
    .data : {
        PROVIDE(sdata = .);
        *(.data .data.*)
        PROVIDE(edata = .);
    }
    . = ALIGN(4K);
    .bss : {
        .bss.stack = .;
        PROVIDE(sbss = .);
        *(.bss .bss.*)
        PROVIDE(ebss = .);
    }
    . = KERNEL_END_ADDR;
}
