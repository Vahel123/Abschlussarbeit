#/bash/bin!

# RAM-Benchmark Test
# timeout 30 bash -c -- 'while true; do docker exec -it 89453050352d sysbench --num-threads=1 --test=memory --memory-block-size=1M --memory-total-size=100G run | head -n18 | tail -n1 >> RAM_Test_fuer_Docker_Container_1.csv ;done'

i=1
while [ $i -le 5 ]
do
 docker exec -it 2abd1aed4ec7 sysbench --num-threads=1 --test=memory --memory-block-size=1M --memory-total-size=100G run | head -n18 | tail -n1 >> RAM_Test_fuer_Docker_Container.csv
 sleep 30s
 i=`expr $i + 1`
done

