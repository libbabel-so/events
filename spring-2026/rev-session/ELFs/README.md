# The Executable and Linkable Format (ELF)

This is standard executable format on Unix-like systems. Most of your actually executable programs are ELFs

```bash
❯ file /bin/bash
/bin/bash: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=39f4023d0e6da60682ddf10daca05f2f7ca4a47d, for GNU/Linux 4.4.0, stripped
❯ file /usr/lib/firefox/firefox
/usr/lib/firefox/firefox: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=34b998a5f04dcc7a378ee9ce1e3ffbc48729dc2b, stripped
```

![ELF Format](https://camo.githubusercontent.com/831bf5c1aeac803a74ab486b23749e40639dd303e0f12bf9e81cfa01767f364d/68747470733a2f2f692e696d6775722e636f6d2f4169394f714f422e706e67)

> [!TIP]
> Checkout `/usr/include/linux/elf.h` for the *exact* structure

## Executable Header

In the [forensics session](../../forensics-session/Forensics Session Installation Documentation.md) you learnt about files and magic bytes and file headers. The ELF format has its own header too with the below structure

```bash
❯ readelf -h test
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Position-Independent Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x1040
  Start of program headers:          64 (bytes into file)
  Start of section headers:          14000 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         14
  Size of section headers:           64 (bytes)
  Number of section headers:         30
  Section header string table index: 29
```

The Header contains a lot of 1-2 byte valued attributes and flags, but some of the important information is in the addresses and offsets

```bash
  # addresses/offsets
  Entry point address:               0x1040
  Start of program headers:          64 (bytes into file)
  Start of section headers:          14000 (bytes into file)
  # and their sizes
  Size of program headers:           56 (bytes)
  Number of program headers:         14
  Size of section headers:           64 (bytes)
  Number of section headers:         30
```

Let's focus on the **Program Headers** and the **Section Headers**

## Program Headers

An ELF is just a container for machine code, it must give the machine to run right? To execute a piece of machine code, the code must be loaded into the memory (RAM). The Program Header specifies to the **Program Loader** where and how to load the memory

The program header lists the different types of mappings and specifies their 
- `offset`: location in the file
- `virtualaddress`: memory address to load into
- `align`: tells how to align the data correctly for this type
- `filesize`: amount of data to read from the file
- `memsize`: the amount of space to reserve in the RAM for this mapping (may be larger than `filesize`)
- `flags`: `rwx` permissions for the mapping

Here are the common program segments

```bash
❯ objdump -p test

test:     file format elf64-x86-64

Program Header:
    PHDR off    0x0000000000000040 vaddr 0x0000000000000040 paddr 0x0000000000000040 align 2**3
         filesz 0x0000000000000310 memsz 0x0000000000000310 flags r--
  INTERP off    0x0000000000000374 vaddr 0x0000000000000374 paddr 0x0000000000000374 align 2**0
         filesz 0x000000000000001c memsz 0x000000000000001c flags r--
    LOAD off    0x0000000000000000 vaddr 0x0000000000000000 paddr 0x0000000000000000 align 2**12
         filesz 0x0000000000000600 memsz 0x0000000000000600 flags r--
    LOAD off    0x0000000000001000 vaddr 0x0000000000001000 paddr 0x0000000000001000 align 2**12
         filesz 0x0000000000000169 memsz 0x0000000000000169 flags r-x
    LOAD off    0x0000000000002000 vaddr 0x0000000000002000 paddr 0x0000000000002000 align 2**12
         filesz 0x0000000000000118 memsz 0x0000000000000118 flags r--
    LOAD off    0x0000000000002dd0 vaddr 0x0000000000003dd0 paddr 0x0000000000003dd0 align 2**12
         filesz 0x0000000000000248 memsz 0x0000000000000250 flags rw-
 DYNAMIC off    0x0000000000002de0 vaddr 0x0000000000003de0 paddr 0x0000000000003de0 align 2**3
         filesz 0x00000000000001e0 memsz 0x00000000000001e0 flags rw-
   STACK off    0x0000000000000000 vaddr 0x0000000000000000 paddr 0x0000000000000000 align 2**4
         filesz 0x0000000000000000 memsz 0x0000000000000000 flags rw-
```


| Type | Purpose | 
| --- | -------- |
| PHDR | the location of the header itself | 
| INTERP | the path to the linker program |
| LOAD | the actual code and data sections |
| DYNAMIC | information for the linker |
| STACK | program stack information |


## Section Headers

Like how program headers are used by the program loader, the **Section Headers** are used by the **compiler** and **linker**. They tell them the various logical chunks of the machine code

```bash
❯ objdump -h test

test:     file format elf64-x86-64

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
 11 .text         00000119  0000000000001040  0000000000001040  00001040  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 13 .rodata       0000001b  0000000000002000  0000000000002000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 23 .data         00000010  0000000000004008  0000000000004008  00003008  2**3
                  CONTENTS, ALLOC, LOAD, DATA
 24 .bss          00000008  0000000000004018  0000000000004018  00003018  2**0
                  ALLOC
```

The various fields are the 
- `Size`
- `Virual Memory Address`
- `Load Memory Address`
- `File Offset` 
- `Alignment`
- `Attributes`
    - Alloc: memory must be allocated for this section
    - Load: data must be loaded from the file into memory
    - Readonly: The section can not be written to

Notice how the sections are far more granular then the program headers (you may also remember from the ELF header how there are a lot more section headers than program headers)

## Sections

Let's look at the important section headers

| Section Name | Purpose |
| ------------ | ------- | 
| `.text`      | actual machine code **IMPORTANT SECTION** |
| `.rodata`    | read only data |
| `.data`      | initialized global and static variables | 
| `.bss`       | uninitialized global variables |


Since the actual code lives in the `.text` section, that's going to be our main focus when reverse engineering

We can also inspect the machine code in `.text` with objdump as below

```bash
❯ objdump -d -j .text test

test:     file format elf64-x86-64


Disassembly of section .text:

0000000000001040 <.text>:
    1040:	48 83 ec 08          	sub    $0x8,%rsp
    1044:	48 8d 3d b9 0f 00 00 	lea    0xfb9(%rip),%rdi        # 2004 <puts@plt+0xfd4>
    104b:	e8 e0 ff ff ff       	call   1030 <puts@plt>
    1050:	31 c0                	xor    %eax,%eax
    1052:	48 83 c4 08          	add    $0x8,%rsp
    1056:	c3                   	ret
```
