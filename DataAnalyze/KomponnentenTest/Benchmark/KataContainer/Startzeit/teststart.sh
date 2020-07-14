#/bash/bin!

# Container starten und entfernen Test
time docker run --rm --name=test --runtime kata-runtime vahelhassan/debian-test ping -c 1 8.8.8.8
