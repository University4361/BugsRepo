          global    _start

          section   .text
_start:
          mov       rax, 0x2000003          ; system call for read
          mov       rdi, 0                  ; file handle 1 is stdout
          mov       rsi, message            ; address of string to output
          mov       rdx, 256                ; number of bytes
          syscall 

          mov       r8, 0
          mov       r9, message
          
strlen:
          inc       r9
          inc       r8
          cmp       byte[r9], 0
          jne       strlen

check_error:
          dec       r8
          dec       r8

          cmp       r8, 7
          jge       stack_overflow

          inc       r8

          mov       rcx, r8
          mov       rbx, message
          mov       rdx, new_m
          
          dec       r8

          add       rdx, r8

push_to_stack:
          xor       rax, rax
          mov       al, byte[rbx]
          mov       byte[rdx], al
          inc       rbx  

          dec       rdx
          dec       rcx
          cmp       rcx, 0
          jne       push_to_stack

pull_from_stack:
          mov       rax, 0x2000004          ; system call for read
          mov       rdi, 1                  ; file handle 1 is stdout
          mov       rsi, new_m              ; address of string to output
          mov       rdx, 7                  ; number of bytes
          syscall 

          mov       rax, 0x2000004          ; system call for read
          mov       rdi, 1                  ; file handle 1 is stdout
          mov       rsi, mynewline          ; address of string to output
          mov       rdx, 1                  ; number of bytes
          syscall     

          mov       rax, 0x2000001          ; system call for exit
          xor       rdi, rdi                ; exit code 0
          syscall 

stack_overflow:
          mov       rax, 0x2000004          ; system call for read
          mov       rdi, 1                  ; file handle 1 is stdout
          mov       rsi, error              ; address of string to output
          mov       rdx, 25                 ; number of bytes
          syscall   

          mov       rax, 0x2000001          ; system call for exit
          xor       rdi, rdi                ; exit code 0
          syscall 

          section   .bss
message:  resb      10                      
new_m:    resb      7                       


          section   .data
mynewline:
          db        10
error:    
          db        " Your message is too long", 10