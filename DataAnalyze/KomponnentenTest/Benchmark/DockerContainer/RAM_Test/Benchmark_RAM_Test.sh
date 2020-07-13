#/bash/bin!

# RAM-Benchmark Test
docker exec -it 3581e6f91720 sysbench --num-threads=1 --test=memory --memory-block-size=1M --memory-total-size=100G run && timeout 30 bash -c -- 'while true; do cat /proc/stat |  vmstat | tail +3 >> RAM_Test_fuer_Docker_Container_1.csv ;done'

docker exec -it 3581e6f91720 sysbench --num-threads=1 --test=memory --memory-block-size=1M --memory-total-size=100G run && timeout 30 bash -c -- 'while true; do cat /proc/stat |  vmstat | tail +3 >> RAM_Test_fuer_Docker_Container_2.csv ;done'

docker exec -it 3581e6f91720 sysbench --num-threads=1 --test=memory --memory-block-size=1M --memory-total-size=100G run && timeout 30 bash -c -- 'while true; do cat /proc/stat |  vmstat | tail +3 >> RAM_Test_fuer_Docker_Container_2.csv ;done'
