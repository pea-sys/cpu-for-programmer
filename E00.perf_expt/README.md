下記書籍のコードを自分の環境で実行した記録

![51JfPD8sVzL _SY445_SX342_](https://github.com/user-attachments/assets/21961020-2a09-4133-892f-d2b79fff9768)

# Performance experiments

## Instruction latencies

### latency_add.S

```sh
sudo perf stat -e "cycles,instructions" ./latency_add
loop-variable = 10000000

 Performance counter stats for './latency_add':

     1,002,416,876      cycles
     1,031,748,021      instructions                     #    1.03  insn per cycle

       0.421687245 seconds time elapsed

       0.421701000 seconds user
       0.000000000 seconds sys
```

### latency_mul.S

```sh
perf stat -e "cycles,instructions" ./latency_mul
loop-variable = 10000000

 Performance counter stats for './latency_mul':

     3,004,244,833      cycles
     1,033,028,982      instructions                     #    0.34  insn per cycle

       1.269554304 seconds time elapsed

       1.268614000 seconds user
       0.000000000 seconds sys
```

### latency_load.S

```sh
perf stat -e "cycles,instructions" ./latency_load
loop-variable = 10000000

 Performance counter stats for './latency_load':

     4,006,031,069      cycles
     1,033,746,722      instructions                     #    0.26  insn per cycle

       1.685422488 seconds time elapsed

       1.683444000 seconds user
       0.000000000 seconds sys
```

### OutOfOrder

```sh
perf stat -e "cycles,instructions" ./ooo_perform
loop-variable = 10000000

 Performance counter stats for './ooo_perform':

       602,075,232      cycles
       531,549,033      instructions                     #    0.88  insn per cycle

       0.254422174 seconds time elapsed

       0.254491000 seconds user
       0.000000000 seconds sys
```

### Not OutOfOrder

```sh
perf stat -e "cycles,instructions" ./ooo_wait
loop-variable = 10000000

 Performance counter stats for './ooo_wait':

       902,237,699      cycles
       531,693,330      instructions                     #    0.59  insn per cycle

       0.388354502 seconds time elapsed

       0.388380000 seconds user
       0.000000000 seconds sys
```

## Branch-prediction misses

### branch_miss_few.S

```sh
perf stat -e "cycles,instructions,branches,branch-misses" ./branch_miss_few

loop-variable = 10000000

 Performance counter stats for './branch_miss_few':

        65,825,454      cycles
       151,167,740      instructions                     #    2.30  insn per cycle
        20,209,131      branches
             7,922      branch-misses                    #    0.04% of all branches

       0.029263554 seconds time elapsed

       0.029334000 seconds user
       0.000000000 seconds sys
```

### branch_miss_many.S

```sh
perf stat -e "cycles,instructions,branches,branch-misses" ./branch_miss_many
loop-variable = 10000000

 Performance counter stats for './branch_miss_many':

       154,451,198      cycles
       156,223,832      instructions                     #    1.01  insn per cycle
        20,217,938      branches
         5,006,696      branch-misses                    #   24.76% of all branches

       0.074825373 seconds time elapsed

       0.074932000 seconds user
       0.000000000 seconds sys
```

## Cache misses (conflict-miss)

### cache_miss_few.S

```sh
perf stat -e "cycles,instructions,L1-dcache-loads,L1-dcache-load-misses" ./cache_miss_few
loop-variable = 10000000

 Performance counter stats for './cache_miss_few':

        21,318,208      cycles                                                                  (35.10%)
        91,068,370      instructions                     #    4.27  insn per cycle              (77.98%)
        10,271,803      L1-dcache-loads
             7,261      L1-dcache-load-misses            #    0.07% of all L1-dcache accesses   (64.90%)

       0.009872526 seconds time elapsed

       0.009943000 seconds user
       0.000000000 seconds sys
```

### cache_miss_many.S

```sh
perf stat -e "cycles,instructions,L1-dcache-loads,L1-dcache-load-misses" ./cache_miss_many
loop-variable = 10000000

 Performance counter stats for './cache_miss_many':

        21,425,813      cycles                                                                  (35.30%)
        91,251,647      instructions                     #    4.26  insn per cycle              (77.96%)
        10,267,280      L1-dcache-loads
        10,362,649      L1-dcache-load-misses            #  100.93% of all L1-dcache accesses   (64.70%)

       0.009914908 seconds time elapsed

       0.009985000 seconds user
       0.000000000 seconds sys
```

## TLB misses (capacity-miss)

### tlb_miss_few.S

```sh
perf stat -e "cycles,instructions,L1-dcache-loads,dTLB-loads,dTLB-load-misses" ./tlb_miss_few
loop-variable = 100000000

 Performance counter stats for './tlb_miss_few':

       526,689,780      cycles                                                                  (40.62%)
       901,414,734      instructions                     #    1.71  insn per cycle              (60.42%)
       100,052,045      L1-dcache-loads                                                         (60.41%)
       100,213,810      dTLB-loads                                                              (59.38%)
               149      dTLB-load-misses                 #    0.00% of all dTLB cache accesses  (39.59%)

       0.222877842 seconds time elapsed

       0.222877000 seconds user
       0.000000000 seconds sys
```

### tlb_miss_many.S

```sh
perf stat -e "cycles,instructions,L1-dcache-loads,dTLB-loads,dTLB-load-misses" ./tlb_miss_many
loop-variable = 100000000

 Performance counter stats for './tlb_miss_many':

     2,521,644,827      cycles                                                                  (39.69%)
       919,850,140      instructions                     #    0.36  insn per cycle              (59.68%)
       103,080,161      L1-dcache-loads                                                         (59.90%)
       100,437,024      dTLB-loads                                                              (60.31%)
       100,408,674      dTLB-load-misses                 #   99.97% of all dTLB cache accesses  (40.10%)

       1.061554971 seconds time elapsed

       1.061114000 seconds user
       0.000000000 seconds sys
```
