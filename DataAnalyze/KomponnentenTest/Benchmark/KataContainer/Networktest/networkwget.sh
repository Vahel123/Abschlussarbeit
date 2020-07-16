#/bash/bin!

# Test wie lange benötigt er u

i=1
while [ $i -le 25 ]
do
 wget -nv -r -k -E -l 8 http://192.168.1.109/ -o networktestganz
 cat networktestganz | head -n16 | tail -n1 >> networktestvoll
 rm -rf 192.168.1.109
 sleep 10s
 i=`expr $i + 1`
done
