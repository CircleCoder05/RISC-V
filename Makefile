# 工具链配置
CC = riscv64-unknown-elf-gcc
LD = riscv64-unknown-elf-ld
QEMU = qemu-system-riscv64
CROSS_COMPILE = riscv64-unknown-elf-

# 目录和文件配置
target_dir := target
riscv_elf := $(target_dir)/riscv
link_script := kernel.lds

# 查找所有源文件
lib_srcs := $(wildcard lib/*.c)
kern_c_srcs := $(wildcard kern/*.c)
kern_asm_srcs := $(wildcard kern/*.S)

# 生成目标文件列表
lib_objs := $(patsubst %.c, $(target_dir)/%.o, $(lib_srcs))
kern_c_objs := $(patsubst %.c, $(target_dir)/%.o, $(kern_c_srcs))
kern_asm_objs := $(patsubst %.S, $(target_dir)/%.o, $(kern_asm_srcs))
objects := $(lib_objs) $(kern_c_objs) $(kern_asm_objs)

# 创建目标目录结构
$(shell mkdir -p $(target_dir)/lib $(target_dir)/kern)

# 编译选项
CFLAGS += -march=rv64imafdc -mabi=lp64d -mcmodel=medany \
          -nostdlib -nostartfiles -Wall \
          -Wextra -Werror -ffreestanding \
          -fno-builtin -fno-stack-protector

# 汇编器选项（与CFLAGS相同但可能需要调整）
ASFLAGS = $(CFLAGS)

# 链接选项
LDFLAGS += -T $(link_script) -nostdlib -nostartfiles

# QEMU 参数
QEMU_FLAGS = -machine virt -m 2G -nographic \
             -kernel $(riscv_elf) \

.PHONY: all clean run dbg_run dbg

all: $(riscv_elf)

# 链接规则
$(riscv_elf): $(objects)
	$(LD) $(LDFLAGS) -o $@ $^

# 编译C文件规则
$(target_dir)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# 编译汇编文件规则
$(target_dir)/%.o: %.S
	$(CC) $(ASFLAGS) -c $< -o $@

run: $(riscv_elf)
	$(QEMU) $(QEMU_FLAGS)

dbg_run: $(riscv_elf)
	$(QEMU) $(QEMU_FLAGS) -s -S

dbg: $(riscv_elf)
	riscv64-unknown-elf-gdb $< -ex "target remote localhost:1234" $(dbg_elf)

clean:
	rm -rf $(target_dir)