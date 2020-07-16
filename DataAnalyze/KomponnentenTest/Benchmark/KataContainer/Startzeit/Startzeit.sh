#/bash/bin!

# Container starten und entfernen Test
time docker exec -it 2da8db12b3a7 sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run | head -n15 | tail -n1 >> Start_Test_fuer_Docker_Container.csv
