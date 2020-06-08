Dokumentation Kata-Container mit Docker <br>

Nachdem man Docker installiert hat werden folgende Befehle verwendet um den Kata-Container zu installieren:  <br>

Was wird benötigt um Kata-Container zu installieren?  <br>

Docker: Siehe offizielle Seite.  <br>

Golang:

sudo apt-get update  <br>
sudo apt-get -y upgrade  <br>
cd /tmp  <br>
wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz  <br>
sudo tar -xvf go1.11.linux-amd64.tar.gz  <br>
sudo mv go /usr/local  <br>
export GOROOT=/usr/local/go  <br>
export GOPATH=~/go  <br>
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH  <br>
go env // Pfade überprüfen  <br>

Make:  <br>
sudo apt-get update  <br>
sudo apt-get install make  <br>

GCC:  <br>
sudo apt-get install gcc <br>
CURL: <br>
sudo apt-get update  <br>
sudo apt install curl  <br>

FLEX:  <br>
sudo apt-get update  <br>
sudo apt-get install flex  <br>
BISON:  <br>
sudo apt-get update -y  <br>
sudo apt-get install -y bison  <br>


libelf-dev:  <br>
sudo apt-get update  <br>
sudo apt-get install libelf-dev  <br>
Python:  <br>
sudo apt-get install -y python3-simpleeval  <br>
sudo apt-get install python3  <br>

Andere wichtige Tools:  <br>
sudo apt-get update  <br>
sudo apt-get install -y pkg-config  <br>
sudo apt-get install libglib2.0-dev  <br>
sudo apt-get install libpixman-1-dev  <br>

Nachdem man die Tools installiert hat beginnen wir dann mit der eigentlichen Installation.   <br>
Zunächst benötigen wir den Kata-Container und den runtime  , damit wir die Grundlegende Architektur haben, um damit dann weiter zu arbeiten. Dafür müssen wir die folgenden Befehle ausführen:  <br>

go get -d -u github.com/kata-containers/runtime  <br>
cd $GOPATH/src/github.com/kata-containers/runtime  <br>
make && sudo -E PATH=$PATH make install   <br>
Jetzt können wir auch direkt mal ausprobieren ob kata-runtime installiert wurde und ob unser Rechner überhaupt die Vorausetzungen erfüllt um ein Kata-Container zu erstellen.   <br>

Zunächst müssen wir ein Kata-Container erstellen (Ohne ein Betriebssystem).   <br>

Dafür einfach die Anleitung folgen und installieren:  <br>
https://github.com/kata-containers/documentation/blob/master/install/ubuntu-installation-guide.md (Aufpassen, den daemon.json nicht verwenden, ansonsten gibt euer Docker eine Fehlermeldung raus.)  <br>
Jetzt die Hardware überprüfen:  <br>

sudo kata-runtime kata-check  <br>

Als Ergebnis sollte folgendes Rauskommen (Bei Ubuntu 18.04 LTS):  <br>

System is capable of running Kata Containers  <br>
System can currently create Kata Containers  <br>

Jetzt haben wir unser erste Kata-Container erstellt aber ohne irgendein Betriebssystem oder Kernel. Um ein Kernel und Root File System (Rootfs) zu erstellen wird sehr viel Rechenpower und Speicher benötigt. Deswegen solltet ihr  ein stabile Rechner dafür benutzen. Sonst könnte es zu abstürzen führen oder das euer Rechner den Geist vollkommen aufgibt (ist mir 2 mal passiert). Am besten ein Rechner mit mindestens 50GB und 4 CPU verwenden!.   <br>

Kommen wir zur Installation.   <br>
Zunächst werden wir ein Rootfs Datei erstellen. Ihr könnt auch eine Intird verwenden. Bei mir hat es aber ganz gut mit dem Rootfs image funktioniert.   <br>

Bevor wir beginnen müssen wir ein paar Vorkehrungen treffen. Unter dem Pfad /usr/share/defaults/kata-containers/configuration.toml müsst ihr ab der Zeile [hypervisor.qemu] initrd = ausklammern, weil wir eine Rootfs image erstellen möchten und kein initrd.   <br>

Das sieht folgendermaßen aus:  <br>

[hypervisor.qemu]  <br>
path = "/usr/bin/qemu-system-x86_64"  <br>
kernel = "/usr/share/kata-containers/vmlinuz.container"  <br>
# initrd = "/usr/share/kata-containers/kata-containers-initrd.img"  <br>
image = "/usr/share/kata-containers/kata-containers.img"  <br>
machine_type = "pc"  <br>
Durch # haben wir es ausgeklammert.   <br>

Bevor wir die Image Datei erstellen benötigen wir noch ein Kata Proxy und Kata Shim, damit unser Kata-Container reibungslos laufen kann. Dafür müssen wir folgende Befehle ausführen:   <br>

Kata Proxy:  <br>
go get -d -u github.com/kata-containers/proxy  <br>

cd $GOPATH/src/github.com/kata-containers/proxy  <br>

make && sudo make install  <br>

Kata Shim:  <br>
go get -d -u github.com/kata-containers/shim  <br>

cd $GOPATH/src/github.com/kata-containers/shim  <br>

make && sudo make install  <br>

Sehr wichtig! Damit wir die Rootfs Datei auch aufbauen und erstellen können benötigen wir den folgenden Git Repository.  <br>

go get -d -u github.com/kata-containers/osbuilder  <br>

Jetzt erstellen wir unser Rootfs Image mit den folgenden Befehlen:  <br>

export ROOTFS_DIR=${GOPATH}/src/github.com/kata-containers/osbuilder/rootfs-builder/rootfs  <br>
sudo rm -rf ${ROOTFS_DIR}  <br>
cd $GOPATH/src/github.com/kata-containers/osbuilder/rootfs-builder  <br>
Jetzt wählt ihr euer Ubuntu System aus in meinem Fall verwende ich Alpine. Ihr könnt aber auch Fedore, Centos usw. verwenden, 
export distro=alpine   <br>
script -fec 'sudo -E GOPATH=$GOPATH USE_DOCKER=true SECCOMP=no ./rootfs.sh ${distro}'  <br>

Jetzt haben wir unsere Image Datei erstellt. Was wir jetzt machen ist unser Rootfs datei aufzubauen. Diese können wir mit den folgenden Befehlen erstellen:   <br>

cd $GOPATH/src/github.com/kata-containers/osbuilder/image-builder  <br>
script -fec 'sudo -E USE_DOCKER=true ./image_builder.sh ${ROOTFS_DIR}'  <br>

Jetzt können wir unser Image Datei installieren:  <br>

commit=$(git log --format=%h -1 HEAD)  <br>

date=$(date +%Y-%m-%d-%T.%N%z)  <br>

image="kata-containers-${date}-${commit}"  <br>

cd /usr/share/kata-containers  <br>

sudo install -o root -g root -m 0640 -D kata-containers.img "/usr/share/kata-containers/${image}"  <br>

(cd /usr/share/kata-containers && sudo ln -sf "$image" kata-containers.img)  <br>

Nachdem wir unsere Image Datei erstellt und installiert haben benötigen wir ein Kernel.   <br>

Diese können wir mit den entsprechenden Befehle installieren:  <br>

go get -d -u github.com/kata-containers/packaging  <br>

cd $GOPATH/src/github.com/kata-containers/packaging/kernel  <br>

./build-kernel.sh setup  <br>

./build-kernel.sh install  <br>

Achtung! Dabei könnte es zu fehlermeldungen kommen. Wenn das der Fall ist habt ihr sehr Wahrscheinlich  Flex, Bison oder libelf-dev nicht installiert.   <br>

Dabei sollten folgende Ergebnisse kommen:  <br>

Setup is 16060 bytes (padded to 16384 bytes).  <br>
System is 5093 kB  <br>
CRC e49589f4  <br>
Kernel: arch/x86/boot/bzImage is ready  (#1)
lrwxrwxrwx 1 root root 17 Jun  5 12:06 /usr/share/kata-containers/vmlinux.container -> vmlinux-5.4.32-79  <br>
lrwxrwxrwx 1 root root 17 Jun  5 12:06 /usr/share/kata-containers/vmlinuz.container -> vmlinuz-5.4.32-79  <br>
Soweit so gut.   <br>

Damit unser Kata-Container auch unabhängig von unsere Host System ist, benötigen wir ein Hypervisor um den Kata-Container uns Host Sytem voneinander abzuschotten.   <br>

Es könnten hier zu mehrere Fehlermeldung kommen. Man braucht viel Geduld und Zeit aber es klappt am Ende. Bitte aufpassen das ihr wirklich die Neuste Github Repository verwendet ansonsten klappt es nicht.   <br>

Diese Befehle müssen ausgeführt werden:   <br>

go get -d github.com/qemu/qemu  <br>

mv ${GOPATH}/root/go/src/github.com kata-containers  <br>

cd ${GOPATH}/src/github.com/kata-containers/qemu/qemu  <br>

mkdir build  <br>

cd build  <br>

../configure  <br>

make -j $(nproc)  <br>
sudo -E make install  <br>

Achtung! Dieser Vorgang kann mehr als 60Minuten benötigen. Ihr benötigt sehr viel Rechenpower!  <br>

Jetzt können wir unser erste Container mit einer Image Datei starten:  <br>
Dafür einfach ein Bash script erstellen und die Folgenden Zeilen hinzufügen.  <br>
#!/bin/bash  <br>
bundle="/tmp/bundle"  <br>
rootfs="$bundle/rootfs"  <br>
mkdir -p "$rootfs" && (cd "$bundle" && kata-runtime spec)  <br>
sudo docker export $(sudo docker create busybox) | tar -C "$rootfs" -xvf -  <br>
sudo kata-runtime --log=/dev/stdout run --bundle "$bundle" foo  <br>

Jetzt müsstet ihr in euer Container angemeldet sein.   <br>
Der Kata-Container wird mithilfe von Docker-Container (bussybox) erstellt und dann auch ausgeführt.   <br>
