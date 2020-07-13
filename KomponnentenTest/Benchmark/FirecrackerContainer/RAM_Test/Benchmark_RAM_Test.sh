#bash/bin!

# Benchmark Test CPU
sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run && timeout 30 bash -c -- 'while true; do cat /proc/stat | head -n1 >> CPU_Test_fuer_Docker_Container_1.csv ;done'
