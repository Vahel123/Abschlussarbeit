#/bash/bin!

# Container starten und entfernen Test
i=1
while [ $i -le 25 ]
do
  { time docker exec -it ba142a1ce87f sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run ; } 2> test
  cat test | head -n2 | tail -n1 >> Start_Test_fuer_Docker_Container.csv
  sleep 30s
  i=`expr $i + 1`
done
