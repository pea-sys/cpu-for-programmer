/*
 * Branch prediction example for x86/Linux
 *
 *   * Branch conditions change randomly.
 *   * MANY branch mispredictions occur.
 *
 *   * C-like pseudo-code:
 *
 *         for (i=0; i<10000000; i++) {
 *
 *             x = xorshift();                // generate a random number
 *
 *             if ((x & 1) == 0) goto L_br;   // branch-prediction test
 *             nop;
 *         L_br:
 *
 *         }
 *
 * --------------my environment--------------
 * loop-variable = 10000000
 * Performance counter stats for './branch_miss_many':

 *      154,741,718      cycles                                                                
 *      156,248,981      instructions                     #    1.01  insn per cycle            
 *       20,222,350      branches                                                              
 *        5,010,863      branch-misses                    #   24.78% of all branches           

 *      0.075935049 seconds time elapsed

 *      0.075990000 seconds user
 *      0.000000000 seconds sys
 */

        .intel_syntax noprefix
        .global main

main:
        sub     rsp, 8                  /* 16-byte alignment */


        /* loop conditions */
        mov     ecx, 0                  /* loop variable   */
        mov     rbx, 10000000           /* loop max-number */

        mov     rax, [rip + random]     /* initial number of xorshift(xor64) */

L_loop:
        /* generate a random number with the xorshift algorithm */
        mov     rdx, rax                /* x = x ^ (x << 13) */
        sal     rax, 13
        xor     rax, rdx

        mov     rdx, rax                /* x = x ^ (x >> 7) */
        sar     rax, 7
        xor     rax, rdx

        mov     rdx, rax                /* x = x ^ (x << 17) */
        sal     rax, 17
        xor     rax, rdx


        /* branch-prediction test */
        mov     r10, rax
        and     r10, 1                  /* zero(eq) flag changes randomly */
        jz      L_br                    /* branch-prediction test */
        nop
L_br:

        /* increment the loop-variable and loop-back */
        add     rcx, 1
        cmp     rcx, rbx
        jl      L_loop


        /* print the last loop-variable */
        lea     rdi, [rip + fmt]        /* 1st argument for printf */
        mov     rsi, rcx                /* 2nd argument */
        mov     eax, 0                  /* the number of vector regsters */
        call    printf


        /* return from main */
        add     rsp, 8                  /* 16-byte alignment */
        ret


        /* read-only data */
        .section .rodata
random:
        .quad   88172645463325252       /* xorshift(xor64)'s initial value */

fmt:
        .string "loop-variable = %d\n"
