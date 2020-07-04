# Mac OS Match-O x64 Assembler Samples

# Registers

| 64-bit register | Lower 32 bits | Lower 16 bits | Lower 8 bits |
| --------------- | ------------- | ------------- |------------- |
| r(a|b|c|d)x     | e(a|b|c|d)x   | (a|b|c|d)x    | (a|b|c|d)l   |
| rsi             | esi           | si            | sil          |
| rdi             | edi           | di            | dil          |
| rbp             | ebp           | bp            | bpl          |
| rsp             | esp           | sp            | spl          |
| r(8-15)         | r(8-15)d      | r(8-15)w      | r(8-15)b     |

# Data types
- byte - 1 byte
- long - 2 bytes
- quad - 4 bytes

# Instructions
Suffixes: l - long, q - quad
| Instruction | Description |
| ----------- | ----------- |
| mov S, D    | Move source to destination
| lea S, D    | Load effective address of source into destination
| syscall     | Perform syscall, described later

# Utils
- Get address of data: variable_name(%rip)

# Syscall

## Syscall constants
To perform syscall find it number here:
**/usr/include/sys/syscall.h** or **/Library/CommandLineTools/SDKs/MacOSX.?.sdk/usr/include/sys/syscall.h**

## Data type representation
- **int**: 32 bit / 4 byte (signed)
- **void, size_t**: 64bit / 8 byte (unsigned)
- **ssize_t**: 64bit / 8 byte (signed)

## Execution
Put syscall number in %eax with offset 0x2000000

Parameters should be in %rdi, %rsi, %rdx, %r10, %r8 and %r9

Return value is %rax

## Syscall declarations
- void exit(int exit_code)
- ssize_t write(int fd, const void *buf, size_t count)