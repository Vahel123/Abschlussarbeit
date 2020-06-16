# Dokumentation Kata-Container mit Docker <br>

Nachdem man Docker installiert hat ist das System bereit Kata-Container zu erstellen  <br>
Wer Docker noch nicht installiert hat, kann es gerne über die <a href="https://docs.docker.com/get-docker/.">Docker </a> Seite oder dem <a href="https://github.com/Vahel123/Abschlussarbeit/blob/master/Docker/README.md">Link </a> nachholen. 

Was wird benötigt um Kata-Container zu installieren?  <br>
ACHTUNG! Diese Installationsanleitung ist nicht 100% gewährleistet, es dient legedglich für meine Abschlusspüfung! Es gibt mehrere Wege um ein Kata-Container zu installieren. <br>

# Wir benötigen folgende Tolls für die Installation! <br>

# Golang:
```bash
sudo apt-get update  
sudo apt-get -y upgrade  
cd /tmp  
wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
sudo tar -xvf go1.13.3.linux-amd64.tar.gz  
sudo mv go /usr/local 

export GOROOT=/usr/local/go 
export GOPATH=~/go  
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH 

go env // Pfade überprüfen  
```

# Make:  <br>
```bash
sudo apt-get update  
sudo apt-get install make 
```

# GCC:  <br>
```bash
sudo apt-get install gcc 
```

# CURL: <br> 
```bash
sudo apt-get update 
sudo apt install curl 
```

# FLEX:  <br>
```bash
sudo apt-get update  
sudo apt-get install flex 
```
# BISON: <br>
```bash
sudo apt-get update -y 
sudo apt-get install -y bison 
```


# libelf-dev:  <br>
```bash
sudo apt-get update 
sudo apt-get install libelf-dev 
```
# Python: <br>  
```bash
sudo apt-get install -y python3-simpleeval 
sudo apt-get install python3 
```

# Andere wichtige Tools die benötigt werden:  <br>
```bash
sudo apt-get update  
sudo apt-get install -y pkg-config  
sudo apt-get install libglib2.0-dev  
sudo apt-get install libpixman-1-dev  
```

# Grundlegende Architektur installieren <br>

Nachdem man die Tools installiert hat beginnen wir dann mit der eigentlichen Installation.   <br>
Zunächst benötigen wir den Kata-Container und den runtime  , damit wir die Grundlegende Architektur haben, um damit dann weiter zu arbeiten. Dafür müssen wir die folgenden Befehle ausführen:  <br>
```bash
go get -d -u github.com/kata-containers/runtime 
cd $GOPATH/src/github.com/kata-containers/runtime
make && sudo -E PATH=$PATH make install 
```
# Hardware überprüfen  <br>

Jetzt können wir auch direkt mal ausprobieren ob kata-runtime installiert wurde und ob unser Rechner überhaupt die Vorausetzungen erfüllt um ein Kata-Container zu erstellen.   <br>

Zunächst müssen wir ein Kata-Container erstellen (Ohne ein Betriebssystem).   <br>

Dafür einfach den folgenden Link folgen:  <br>
 <a href="https://github.com/kata-containers/documentation/blob/master/install/ubuntu-installation-guide.md">Kata-Container installieren </a> (Aufpassen, den daemon.json nicht verwenden, ansonsten gibt euer Docker eine Fehlermeldung raus.)  <br>
Jetzt die Hardware überprüfen:  <br>
``` bash
sudo kata-runtime kata-check 
```
Als Ergebnis sollte folgendes Rauskommen (Bei Ubuntu 18.04 LTS):  <br>
```bash
System is capable of running Kata Containers 
System can currently create Kata Containers  
```
# Image oder initrd ausklammern <br>

Jetzt haben wir unser erste Kata-Container erstellt aber ohne irgendein Betriebssystem oder Kernel. Um ein Kernel und Root File System (Rootfs) zu erstellen wird sehr viel Rechenpower und Speicher benötigt. Deswegen solltet ihr  ein stabile Rechner dafür benutzen. Sonst könnte es zu abstürzen führen oder das euer Rechner den Geist vollkommen aufgibt (ist mir 2 mal passiert). Am besten ein Rechner mit mindestens 50GB und 4 CPU verwenden!.   <br>

Zunächst werden wir ein Rootfs Datei erstellen. Ihr könnt auch eine Intird verwenden. Bei mir hat es aber ganz gut mit dem Rootfs image funktioniert.   <br>

Bevor wir beginnen müssen wir ein paar Vorkehrungen treffen. Unter dem Pfad `/usr/share/defaults/kata-containers/configuration.toml` und `/etc/kata-containers/configuration.toml` müsst ihr ab der Zeile `[hypervisor.qemu] initrd = `ausklammern, weil wir eine Rootfs image erstellen möchten und kein initrd.   <br>

Das sieht folgendermaßen aus:  <br>
```bash
[hypervisor.qemu] 
path = "/usr/bin/qemu-system-x86_64" 
kernel = "/usr/share/kata-containers/vmlinuz.container"  
(#) initrd = "/usr/share/kata-containers/kata-containers-initrd.img"  
image = "/usr/share/kata-containers/kata-containers.img" 
machine_type = "pc" 
Durch # haben wir es ausgeklammert. 
```
Bevor wir die Image Datei erstellen benötigen wir noch ein Kata Proxy und Kata Shim, damit unser Kata-Container reibungslos laufen kann. Dafür müssen wir folgende Befehle ausführen:   <br>

# Full debug aktivieren (shim) <br>
```bash
sudo mkdir -p /etc/kata-containers/
sudo install -o root -g root -m 0640 /usr/share/defaults/kata-containers/configuration.toml /etc/kata-containers
sudo sed -i -e 's/^# *\(enable_debug\).*=.*$/\1 = true/g' /etc/kata-containers/configuration.toml
sudo sed -i -e 's/^kernel_params = "\(.*\)"/kernel_params = "\1 agent.log=debug initcall_debug"/g' /etc/kata-containers/configuration.toml
```
Jetzt in der Datei `/etc/containerd/config.toml` folgende Zeilen hinzufügen:
```bash
[debug]
  level = "debug"
```

# Kata Proxy:  <br>
```bash
go get -d -u github.com/kata-containers/proxy

cd $GOPATH/src/github.com/kata-containers/proxy

make && sudo make install  
```

# Kata Shim: <br>
```bash
go get -d -u github.com/kata-containers/shim

cd $GOPATH/src/github.com/kata-containers/shim

make && sudo make install
```

Sehr wichtig! Damit wir die Rootfs Datei auch aufbauen und erstellen können benötigen wir den folgenden Git Repository.  <br>

# Osbuilder <br>
```bash
go get -d -u github.com/kata-containers/osbuilder
```
# Rootfs Datei erstellen und installieren <br> 

Jetzt erstellen wir unser Rootfs Image mit den folgenden Befehlen:  <br>
```bash
export ROOTFS_DIR=${GOPATH}/src/github.com/kata-containers/osbuilder/rootfs-builder/rootfs
sudo rm -rf ${ROOTFS_DIR}  
cd $GOPATH/src/github.com/kata-containers/osbuilder/rootfs-builder 
```
Jetzt wählt ihr euer Ubuntu System aus in meinem Fall verwende ich Debian. Ihr könnt aber auch Fedore, Centos, oder Alpine verwenden. <br>
```bash
export distro=debian   
script -fec 'sudo -E GOPATH=$GOPATH USE_DOCKER=true SECCOMP=no ./rootfs.sh ${distro}'  
```
# Rootfs aufbauen <br>

Jetzt haben wir unsere Image Datei erstellt. Was wir jetzt machen ist unser Rootfs datei aufzubauen. Diese können wir mit den folgenden Befehlen erstellen:   <br>
```bash
cd $GOPATH/src/github.com/kata-containers/osbuilder/image-builder 
script -fec 'sudo -E USE_DOCKER=true ./image_builder.sh ${ROOTFS_DIR}'  
```
# Rootfs installieren <br>

Jetzt können wir unser Image Datei installieren:  <br>
```bash
commit=$(git log --format=%h -1 HEAD)

date=$(date +%Y-%m-%d-%T.%N%z)

image="kata-containers-${date}-${commit}"  

cd /usr/share/kata-containers 

sudo install -o root -g root -m 0640 -D kata-containers.img "/usr/share/kata-containers/${image}" 

(cd /usr/share/kata-containers && sudo ln -sf "$image" kata-containers.img) 
```
# Kernel erstellen <br>

Nachdem wir unsere Image Datei erstellt und installiert haben benötigen wir ein Kernel.   <br>

Diese können wir mit den entsprechenden Befehle installieren:  <br>
```bash
go get -d -u github.com/kata-containers/packaging 

cd $GOPATH/src/github.com/kata-containers/packaging/kernel

./build-kernel.sh setup 

./build-kernel.sh install  
```
Achtung! Dabei könnte es zu fehlermeldungen kommen. Wenn das der Fall ist habt ihr sehr Wahrscheinlich  Flex, Bison oder libelf-dev nicht installiert.   <br>

Dabei sollten folgende Ergebnisse kommen:  <br>
```bash
Setup is 16060 bytes (padded to 16384 bytes). 
System is 5093 kB 
CRC e49589f4  
Kernel: arch/x86/boot/bzImage is ready  (#1)
lrwxrwxrwx 1 root root 17 Jun  5 12:06 /usr/share/kata-containers/vmlinux.container -> vmlinux-5.4.32-79 
lrwxrwxrwx 1 root root 17 Jun  5 12:06 /usr/share/kata-containers/vmlinuz.container -> vmlinuz-5.4.32-79  
Soweit so gut. 
```
# Hypervisor installieren <br>

Damit unser Kata-Container auch unabhängig von unsere Host System ist, benötigen wir ein Hypervisor um den Kata-Container uns Host Sytem voneinander abzuschotten.   <br>

Es könnten hier zu mehrere Fehlermeldung kommen. Man braucht viel Geduld und Zeit aber es klappt am Ende. Bitte aufpassen das ihr wirklich die Neuste Github Repository verwendet ansonsten klappt es nicht.   <br>

Diese Befehle müssen ausgeführt werden:   <br>
```bash
go get -d github.com/qemu/qemu

mv ${GOPATH}/root/go/src/github.com kata-containers 

cd ${GOPATH}/src/github.com/kata-containers/qemu/qemu

mkdir build 

cd build  

../configure 

make -j $(nproc) 
sudo -E make install  
```
Achtung! Dieser Vorgang kann mehr als 60Minuten benötigen. Ihr benötigt sehr viel Rechenpower!  <br>

# Kata-Container über Docker Container starten. <br>
```bash
sudo mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/kata-containers.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -D --add-runtime kata-runtime=/usr/bin/kata-runtime --default-runtime=kata-runtime
EOF
```
Docker Konfigurations Ordner erstellen. <br>
```bash
sudo mkdir -p /etc/docker
```
Folgende Zeilen unter der Dateo `/etc/docker/daemon.json` hinzufpügen. <br>
```bash
{
  "default-runtime": "kata-runtime",
  "runtimes": {
    "kata-runtime": {
      "path": "/usr/bin/kata-runtime"
    }
  }
}
```

Neustart von Docker Systemd <br>
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```
Kata-Container RUN
```bash
sudo docker run busybox uname -a
```

# Docker systmd file updaten <br>
```bash
dockerUnit=$(systemctl show -p FragmentPath docker.service | cut -d "=" -f 2)
unitFile=${dockerUnit:-/etc/systemd/system/docker.service.d/kata-containers.conf}
test -e "$unitFile" || { sudo mkdir -p "$(dirname $unitFile)"; echo -e "[Service]\nType=simple\nExecStart=\nExecStart=/usr/bin/dockerd -D --default-runtime runc" | sudo tee "$unitFile"; }
grep -q "kata-runtime=" $unitFile || sudo sed -i 's!^\(ExecStart=[^$].*$\)!\1 --add-runtime kata-runtime=/usr/local/bin/kata-runtime!g' "$unitFile"
sudo systemctl daemon-reload
sudo systemctl restart docker
```
# Erstellte Container ausführen (run) <br>
```bash
sudo docker run -ti --runtime kata-runtime busybox sh
```

# Networking <br>
Sollte automatisch von Docker gemacht sein. <br>
Test: <br>
```bash
/ # ping google.de
PING google.de (172.217.18.3): 56 data bytes
64 bytes from 172.217.18.3: seq=0 ttl=116 time=19.355 ms
64 bytes from 172.217.18.3: seq=1 ttl=116 time=16.719 ms
^C
--- google.de ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 16.719/18.037/19.355 ms
```

# Mit Kata-runtime starten <br>
```bash
bundle="/tmp/bundle"
rootfs="$bundle/rootfs"
mkdir -p "$rootfs" && (cd "$bundle" && kata-runtime spec)
sudo docker export $(sudo docker create busybox) | tar -C "$rootfs" -xvf -
sudo kata-runtime --log=/dev/stdout run --bundle "$bundle" foo
```
Achtung: die erstellte rootfs (siehe oben)  ordner im Verzeichnis `/tmp/bundle` davor anhängen! <br>
