#!/bin/bash
docker run -it -d -p 80:80 vahelhassan/debian-test sh

# Nachdem der Container im background läuft können wir mit dem Befehl Docker exec innerhalb des Containers Commander ausführen
# Syntax: docker exec -it debian-test service apache2 start
# Benchmark
# docker exec -it ea5cd7ab9b70 sysbench --test=cpu --cpu-max-prime=20000 run
