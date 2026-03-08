# Intro to Debugging

If you haven't already:

1. Install **gdb** from [here](../assets/gdb-static-full-x86_64.tar.gz) and follow the below instructions (release acquired from [gdb-static](https://github.com/guyush1/gdb-static))

    ```bash
    # mkdir working dir
    mkdir -p ./gdbx86_64
    # untar
    tar xzf ./gdb-static-full-x86_64.tar.gz -C ./gdbx86_64
    # copy to bin
    cp ./gdbx86_64/* /usr/bin
    ```

    Then install `gef` by running

    ```bash
    bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
    ```

1. Install **radare2** from [here](../assets/radare2-6.1.0.tar.xz) and follow the below instructions

    ```bash
    # untar
    tar xf ./radare2-6.1.0.tar.xz
    cd ./radare2-6.1.0
    # install script
    bash ./radare2-6.1.0/sys/install.sh
    ```

Figure out any errors you face

## An example program

I have provided a broken interest calculator program, I need you to find the error. I compiled the file with `gcc -g` to make debugging easier

```bash
❯ gdb ./interest_calc
gef➤  b main
Breakpoint 1 at 0x1176: file buggy_interest.c, line 9.
gef➤  run
gef➤  ni
```

`b main` sets a breakpoint at the main function

`run` starts running the program until a breakpoint occurs (the one we set at main)

`ni` goes to the next instruction
- keep going through the instructions until you see the error in the program (clearly the returned answer is wrong, right?)

> [!NOTE] Hidden Win
> There is also a hidden function that has a prize for you! See if you can execute it

Pay attention to any comparisions you see

## Disassembling The Program

```bash
❯ radare2 ./interest_calc
[0x00001050]> aaa
INFO: Analyze all flags starting with sym. and entry0 (aa)
INFO: Analyze imports (af@@@i)
INFO: Analyze entrypoint (af@ entry0)
INFO: Analyze symbols (af@@@s)
INFO: Analyze all functions arguments/locals (afva@@@F)
INFO: Analyze function calls (aac)
INFO: Analyze len bytes of instructions for references (aar)
INFO: Finding and parsing C++ vtables (avrr)
INFO: Analyzing methods (af @@ method.*)
INFO: Recovering local variables (afva@@@F)
INFO: Type matching analysis for all functions (aaft)
INFO: Propagate noreturn information (aanr)
INFO: Integrate dwarf function information
INFO: Use -AA or aaaa to perform additional experimental analysis
[0x00001050]> afl
0x00001030    1      6 sym.imp.puts
0x00001040    1      6 sym.imp.printf
0x00001050    1     37 entry0
0x00001080    4     34 sym.deregister_tm_clones
0x000010b0    4     51 sym.register_tm_clones
0x000010f0    5     55 entry.fini0
0x00001140    1      9 entry.init0
0x00001274    1     13 sym._fini
0x00001149    1     37 dbg.win
0x0000116e    3    259 dbg.main
0x00001000    3     27 sym._init
[0x00001050]> s dbg.main
[0x0000116e]> pdf
```

`aaa` analyses the binary

`afl` lists the functions in the binary

`s dbg.main` seeks to main, i.e. goes to that address location

`pdf` prints disassembly of function
