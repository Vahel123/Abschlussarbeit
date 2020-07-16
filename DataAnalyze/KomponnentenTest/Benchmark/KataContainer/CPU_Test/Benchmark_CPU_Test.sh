#/bash/bin!
# Benchmark-CPU

# docker exec -it 2da8db12b3a7 sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run && timeout 30 bash -c -- 'while true; do cat /proc/stat | head -n1 >> CPU_Test_fuer_Docker_Container_1.csv ;done'
i=1
while [ $i -le 25 ]
do
  sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run | head -n15 | tail -n1 >> CPU_Test_fuer_Docker_Container.csv
  sleep 30s
  i=`expr $i + 1`
done
