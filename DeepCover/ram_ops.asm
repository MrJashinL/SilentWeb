section .text
global dump_ram
global freeze_ram

dump_ram:
    push rbp
    mov rbp, rsp
    
    mov rax, 0x9
    mov rdi, 0
    mov rsi, [ram_size]
    mov rdx, PROT_READ
    mov r10, MAP_PRIVATE
    mov r8, -1
    mov r9, 0
    syscall
    
    mov rdi, [ram_buffer]
    mov rsi, rax
    mov rdx, [ram_size]
    rep movsb
    
    mov rsp, rbp
    pop rbp
    ret

freeze_ram:
    push rbp
    mov rbp, rsp
    
    mov rax, 0x1
    mov rdi, 1
    syscall
    
    mov rsp, rbp
    pop rbp
    ret
