
Experiments with multiprocessors
================================

## Cache-line(s) with line-invalidation

### cacheline_different.S

```sh
perf stat -e "cycles, instructions,L1-dcache-loads,L1-dcache-load-misses" ./cacheline_different
main(): start
child1(): start
child2(): start
child1(): finish
child2(): finish
main(): finish

 Performance counter stats for './cacheline_different':

        71,898,124      cycles                                                                  (47.27%)
        61,275,010       instructions                    #    0.85  insn per cycle              (73.62%)
        10,360,402      L1-dcache-loads                                                         (73.62%)
             4,253      L1-dcache-load-misses            #    0.04% of all L1-dcache accesses   (79.34%)

       0.016066239 seconds time elapsed

       0.030838000 seconds user
       0.000000000 seconds sys
```


### cacheline_same.S

```sh
perf stat -e "cycles, instructions,L1-dcache-loads,L1-dcache-load-misses" ./cacheline_same
main(): start
child1(): start
child2(): start
child2(): finish
child1(): finish
main(): finish

 Performance counter stats for './cacheline_same':

       406,452,259      cycles                                                                  (49.37%)
        59,046,680       instructions                    #    0.15  insn per cycle              (76.91%)
        10,608,550      L1-dcache-loads                                                         (77.19%)
         3,114,531      L1-dcache-load-misses            #   29.36% of all L1-dcache accesses   (73.94%)

       0.089491661 seconds time elapsed

       0.166387000 seconds user
       0.003869000 seconds sys
```
single core

```sh
perf stat -e "cycles, instructions,L1-dcache-loads,L1-dcache-load-misses" taskset --cpu-list 0 ./cacheline_same
main(): start
child2(): start
child1(): start
child2(): finish
child1(): finish
main(): finish

 Performance counter stats for 'taskset --cpu-list 0 ./cacheline_same':

        72,365,348      cycles                                                                  (47.70%)
        62,845,428       instructions                    #    0.87  insn per cycle              (74.11%)
        10,760,061      L1-dcache-loads                                                         (82.08%)
             6,466      L1-dcache-load-misses            #    0.06% of all L1-dcache accesses   (70.89%)

       0.032227413 seconds time elapsed

       0.030105000 seconds user
       0.000000000 seconds sys
```



## Memory ordering

### ordering_unexpected.S

```sh
./ordering_unexpected
main(): start
child1(): start
child2(): start
child2(): UNEXPECTED!: r14 == 0 && r15 == 0; loop-variable = 1
child1(): UNEXPECTED!: r14 == 0 && r15 == 0; loop-variable = 1
main(): finish
```


### ordering_force.S

```sh
./ordering_force
main(): start
child1(): start
child2(): start
child1(): finish: loop-variable = 5000000
child2(): finish: loop-variable = 5000000
main(): finish
```




## Shared-counter with atomicity

### counter_atomic.S

```sh
main(): start
child1(): start
child2(): start
child2(): finish: loop-variable = 5000000
child1(): finish: loop-variable = 5000000
main(): finish: counter = 10000000
```

### counter_bad.S

```sh
main(): start
child1(): start
child2(): start
child1(): finish: loop-variable = 5000000
child2(): finish: loop-variable = 5000000
main(): finish: counter = 5311480
```

