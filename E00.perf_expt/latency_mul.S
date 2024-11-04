/*
 * Latency example for x86/Linux
 *
 *   * `mul` instruction
 *
 *   * C-like pseudo-code:
 *
 *         for (i=0; i<10000000; i++) {
 *             mul instruction
 *                   :                  // 100 times
 *         }
 *
 * --------------my environment--------------
 * perf stat -e "cycles,instructions" ./latency_mul
 * loop-variable = 10000000

 * Performance counter stats for './latency_mul':

 *   3,004,994,147      cycles                                                                
 *   1,033,115,701      instructions                     #    0.34  insn per cycle            

 *   1.268495169 seconds time elapsed

 *   1.268507000 seconds user
 *   0.000000000 seconds sys
 */

        .intel_syntax noprefix
        .global main

main:
        sub     rsp, 8                  /* 16-byte alignment */


        /* loop conditions */
        mov     ecx, 0                  /* loop variable   */
        mov     rbx, 10000000           /* loop max-number */

        mov     rax, 1                  /* 1st operand for mul instructions */
        mov     r10, 1                  /* 2nd operand for mul instructions */


        /* loop body */
L_loop:
        mul     r10                     /* rdx:rax = rax * r10 */
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10
        mul     r10

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
fmt:
        .string "loop-variable = %d\n"
