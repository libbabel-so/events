# Library of Babel Reverse Engineering Workshop

## Agenda 

1. What is an executable
1. Debuggers and Tools
1. An introduction to x86 assembly
1. Live Reverse Engineering a binary bomb
1. Malware Analysis (briefly)

## Required Reading

- [A whirlwind tour of the ELF format](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html) (this is a fun read i promise)
- [x86 Intel Assembly](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html)

I will of course be covering these again, but I really want everyone to try going through them on their own a couple times

## Non-Required Reading

Other fun reads that are totally irrelevant to the session, feel free to skip:
- [what really happened on mars](https://www.cs.unc.edu/~anderson/teach/comp790/papers/mars_pathfinder_long_version.html)
- [one million checkboxes](https://eieio.games/blog/one-million-checkboxes/)
- [some other cmu labs](https://csapp.cs.cmu.edu/public/labs.html)

## Prerequisites

Short List:
- [linux](#linux)
- [gdb](#gdb)
- [radare2](#radare2)

### Linux

![meme](https://images3.memedroid.com/images/UPLOADED421/653bbb6a446c3.jpeg)

The executables we will be discussing will be specifically for GNU/Linux systems on x86_64 machines. To run them you will **need** to have linux.

If you use Windows, you will need to ensure you setup the Windows Subsystem for Linux. On Mac you will need to figure out how to setup a linux VM.

#### WSL Setup For Windows Users

> [!NOTE]
Alternatively, you can follow [this guide](https://learn.microsoft.com/en-us/windows/wsl/install).

1. Go to the start menu
1. Search for `Turn Windows Features On or Off`
1. Check the box next to `Windows Subsystem for Linux` and Click `OK`
1. When it prompts you for a reboot, reboot your system by choosing `Restart Now`.
1. After the reboot open Windows Terminal as Administrator (Search for `Windows PowerShell`, right click and `Run as Administrator`)
1. Type:

    ```bash
    wsl --install Ubuntu
    ```

    This, by default, installs Ubuntu on your system, and gives you a fully functional Linux Subsystem for your own system.  

1. If it prompts you to, Reboot your system (else skip to step 9).  
1. Launch terminal again and use

    ```bash
    wsl
    ```

1. It will prompt you to enter a username and then a password. Remember this since you will need these to login later. You can now access your Ubuntu Subsystem anytime using 

    ```bash
    wsl
    ```

    From `Windows PowerShell` or `Windows Terminal`(preferred).
1. Update your distro using 

    ```bash
    sudo apt update && sudo apt upgrade
    ```

    Type `y` to confirm when prompted.

**Some Useful Information**:

1. The Linux filesystem stores all your files within `/home/username`.
1. WSL launches by default in your `System32` folder. You can switch to your local folder using `cd`
1. You can see this folder as a different section in your file Explorer. 
1. You can directly paste files into the required folder to access them within your Subsystem.
1. Paste all required files in your `/home/username` folder to access them quickly

#### For Mac Users

You have entirely different architectures from Windows and Linux users, and so you'll need to setup a Linux Virtual Machine to run linux x86 executables. I'm not sure how to help you with that, all the best.

> [!NOTE] Running vs Debugging
> To run the actual program on your machine, you will need hardware suppport which requires x86 and GNU/Linux support
> 
> However even if you can't physically run the programs, you can still analyze and understand what it does, which is the point of reverse engineering. The debuggers we discuss here should still be enough to help you gather an understand of how executables and assembly work.

### GDB

![meme](./assets/gdbmeme1.png)

GDB is a debugger and a crucial part of your toolkit as an engineer.

#### Installation

1. Windows users: [follow this](https://learningorbis.com/gcc-gdb-installation-on-windows/) (i'm not testing this out, all the best)
1. Linux users: ideally you either have it already, or know how to install for your distribution. But for completeness here's a [guide](https://www.gdbtutorial.com/tutorial/how-install-gdb)
1. Mac users: apparently you simply can't install gdb, so try out [this alternative](https://lldb.llvm.org/). Again i'm not trying it out, all the best.


Once you have gdb installed, consider installating an extension script [gef (gdb-enhanced-features)](https://hugsy.github.io/gef/install/)

#### Usage

Once you have gdb setup, get a little familiar with it

**Examples**:
- [gdbtutorial.com](https://www.gdbtutorial.com/tutorial/how-use-gdb-example)
- [cmu](https://www.cs.cmu.edu/~gilpin/tutorial/)

**Cheatsheet**:
- [https://gabriellesc.github.io/teaching/resources/GDB-cheat-sheet.pdf](https://gabriellesc.github.io/teaching/resources/GDB-cheat-sheet.pdf)

### Radare2

![meme](./assets/gdbmeme2.png)

radare2 is also a debugger similar to gdb, we will be discussing this as well purely because I like the assembly output of radare2 more. It looks very nice and makes reading assembly rather fun.

#### Installation

- Cross Platform Releases are available (good4u windows and mac users!!): [follow this](https://book.rada.re/install/download.html) or check out the official releases [radareorg/radare2](https://github.com/radareorg/radare2/releases)

Apparently theres also an install script, not sure which platform though, atb

```bash
curl -Ls https://github.com/radareorg/radare2/releases/download/6.1.0/radare2-6.1.0.tar.xz | tar xJv
radare2-6.1.0/sys/install.sh
```

### Usage

- [Cheatsheet](https://scoding.de/uploads/r2_cs.pdf)

r2 commands are really easy, if you don't know something just add an `?` after it and you'll get a helpful guide

eg.

```bash
[0x08048810]> afl?
Usage: afl   List all functions
| afl            list functions
| afl.           display function in current offset (see afi.)
| afl, [query]   list functions in table format
| afl+           display sum all function sizes
| afl*           reconstruct all functions in r2 commands
| afl=           display ascii-art bars with function ranges
```
