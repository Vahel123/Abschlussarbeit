#bash/bin!


# Benchmark Test CPU
# docker exec -it 2da8db12b3a7 sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run && timeout 30 bash -c -- 'while true; do cat /proc/stat | head -n1 >> CPU_Test_fuer_Docker_Container_1.csv ;done'

# docker exec -it 2da8db12b3a7 sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run && timeout 30 bash -c -- 'while true; do cat /proc/stat | head -n1 >> CPU_Test_fuer_Docker_Container_2.csv ;done'

# docker exec -it 2da8db12b3a7 sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run && timeout 30 bash -c -- 'while true; do cat /proc/stat | head -n1 >> CPU_Test_fuer_Docker_Container_3.csv ;done'

# Benchmark Test RAM



