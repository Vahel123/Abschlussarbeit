#bash/bin!

# Benchmark Test CPU
docker exec -it b19163fd28e1 sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run && timeout 30 bash -c -- 'while true; do cat /proc/stat | head -n1 >> CPU_Test_fuer_Kata_Container_1.csv ;done'

docker exec -it b19163fd28e1 sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run && timeout 30 bash -c -- 'while true; do cat /proc/stat | head -n1 >> CPU_Test_fuer_Kata_Container_2.csv ;done'

docker exec -it b19163fd28e1 sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run && timeout 30 bash -c -- 'while true; do cat /proc/stat | head -n1 >> CPU_Test_fuer_Kata_Container_3.csv ;done'
