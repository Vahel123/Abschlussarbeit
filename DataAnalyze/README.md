# Leistungsbewertung für Docker Container <br>
An einem Beispiel für Docker Container. 
# Benschmark-CPU <br>
```bash
#/bash/bin!
# Benchmark-CPU
i=1
while [ $i -le 5 ]
do
  docker exec -it f8b1c2a8f64e sysbench --num-threads=1 --test=cpu --cpu-max-prime=20000 run | head -n15 | tail -n1 >> CPU_Test_fuer_Docker_Container.csv
  sleep 30s
  i=`expr $i + 1`
done

```

Ergebnis CPU: <br>
```bash
    total time:                          15.8419s
    total time:                          15.6571s
    total time:                          15.9258s
    total time:                          15.9217s
    total time:                          15.6586s
```

# Benchmark-RAM <br>
```bash
#/bash/bin!
# Benchmark-RAM 
i=1
while [ $i -le 5 ]
do
 docker exec -it 2abd1aed4ec7 sysbench --num-threads=1 --test=memory --memory-block-size=1M --memory-total-size=100G run | head -n18 | tail -n1 >> RAM_Test_fuer_Docker_Container.csv
 sleep 30s
 i=`expr $i + 1`
done
```

Ergebnis CPU: <br>
```bash
102400.00 MB transferred (11736.10 MB/sec)
102400.00 MB transferred (12136.00 MB/sec)
102400.00 MB transferred (11346.53 MB/sec)
102400.00 MB transferred (9484.08 MB/sec)
102400.00 MB transferred (10689.73 MB/sec)
```

# Startzeit <br>
```bash
time docker run --rm  --name=test vahelhassan/debian-test ping -c 1 8.8.8.8
```

Ergebnis CPU <br>
```bash
Durchlauf 1
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=20.5 ms

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 20.513/20.513/20.513/0.000 ms

real	0m4,574s
user	0m0,027s
sys	0m0,019s

Durchauf 2
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=50.5 ms

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 50.465/50.465/50.465/0.000 ms

real	0m4,119s
user	0m0,026s
sys	0m0,026s

Durchlauf 3
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=26.6 ms

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 26.589/26.589/26.589/0.000 ms

real	0m4,064s
user	0m0,035s
sys	0m0,015s

Durchlauf 4
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=45.7 ms

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 45.745/45.745/45.745/0.000 ms

real	0m4,204s
user	0m0,022s
sys	0m0,027s


Durchlauf 5
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=67.7 ms

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 67.727/67.727/67.727/0.000 ms

real	0m4,599s
user	0m0,031s
sys	0m0,018s

```
