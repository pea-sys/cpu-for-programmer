/*
 * Cache-miss example for x86/Linux
 *
 *   * Cache accesses with 64-byte (line-size) stride.
 *   * FEW cache-miss occur.
 *
 *   * C-like pseudo-code:
 *
 *         stride = 64;
 *         wrap   = 0x1f;  // 32times - 1
 *
 *         for (i=0; i<10000000; i++) {
 *             load(address);
 *             address = address + ((i & wrap) * stride)
 *         }
 *
 * --------------my environment--------------
 * loop-variable = 10000000

 * Performance counter stats for './cache_miss_few':

 *       21,282,212      cycles                                                                  (30.01%)
 *       90,325,969      instructions                     #    4.24  insn per cycle              (67.32%)
 *       10,273,288      L1-dcache-loads                                                       
 *            6,373      L1-dcache-load-misses            #    0.06% of all L1-dcache accesses   (69.99%)

 *      0.011332944 seconds time elapsed

 *      0.011421000 seconds user
 *      0.000000000 seconds sys 
 */

        .intel_syntax noprefix
        .global main

main:
        sub     rsp, 8                  /* 16-byte alignment */


        /* access parameters */
        mov     r12, 64         /* stride is 64byte (cache-line size)   */
        mov     r13, 0x1f       /* wrap for 32 times                    */


        /* loop conditions */
        mov     ecx, 0                  /* loop variable   */
        mov     rbx, 10000000           /* loop max-number */

L_loop:
        /* calc address */
        mov     rax, rcx                /*  i                  */
        and     rax, r13                /*  i & wrap           */
        imul    rax, r12                /* (i % wrap) x stride */

        lea     r10, [rip + work_area]
        add     rax, r10

        /* cache access (simple load) */
        mov     rdx, [rax]              /* rdx = load(rax) */

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


        .balign 8
work_area:
        .skip 0x40000

dummy_tail:
        .quad   0
