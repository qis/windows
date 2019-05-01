          global    _start

          section   .text
_start:
          xor       rdi, rdi                ; exit code 0
          syscall                           ; invoke operating system to exit
