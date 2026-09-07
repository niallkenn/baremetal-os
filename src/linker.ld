# Entry point for kernel 
ENTRY(_start)

# declares where object files and data goes in kernel image

SECTIONS
{
    # sets start location for kernel
    . = 2M;

    # global kernel start
    _kernel_start = .;

    # put multiboot header and text / code section first
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)
        *(.text)
    }

    # read only data
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    # read write data 
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    # read write data uninitialised and stack
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }

    # global kernel end
    _kernel_end = .;
}