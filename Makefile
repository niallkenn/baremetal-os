CC = i386-elf-gcc
AS = i386-elf-as
LD = i386-elf-gcc

CC_FLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LD_FLAGS = -ffreestanding -O2 -nostdlib -lgcc

SRC_DIR = src
BUILD_DIR = build
ISO_DIR = iso

BOOT_SRC = $(SRC_DIR)/boot/boot.s
BOOT_OBJ = $(BUILD_DIR)/boot.o

KERNEL_SRC = $(SRC_DIR)/kernel.c
KERNEL_OBJ = $(BUILD_DIR)/kernel.o

LINKER_SCRIPT = $(SRC_DIR)/linker.ld

KENOS = $(BUILD_DIR)/KENOS
KENOS_ISO = $(ISO_DIR)/KENOS.iso

.PHONY: all clean

all: $(KENOS_ISO)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ISO_DIR):
	mkdir -p $(ISO_DIR)/boot/grub

$(BOOT_OBJ): $(BOOT_SRC) | $(BUILD_DIR)
	$(AS) $(BOOT_SRC) -o $(BOOT_OBJ)

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) -c $(KERNEL_SRC) -o $(KERNEL_OBJ) $(CC_FLAGS)

$(KENOS): $(BOOT_OBJ) | $(KERNEL_OBJ)
	$(LD) -T $(LINKER_SCRIPT) -o $(KENOS) $(LD_FLAGS) $(BOOT_OBJ) $(KERNEL_OBJ)

$(KENOS_ISO): $(ISO_DIR) | $(KENOS)
	cp $(KENOS) $(ISO_DIR)/boot/KENOS
	cp $(SRC_DIR)/grub/grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(KENOS_ISO) $(ISO_DIR)

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR)

run: $(KENOS_ISO)
	qemu-system-i386 -cdrom $(KENOS_ISO)