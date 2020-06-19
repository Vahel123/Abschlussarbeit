# Docker mit Debian Image installieren und diese dann innerhalb eines Container ausführen. <br>

Zunächst installieren wir Docker. <br>

Je nachdem was für ein System ihr benutzt müsst ihr ein andere Installationsnaleitung benutzen. Weitere Informationen findet ihr auf der  <a href="https://docs.docker.com/get-docker/">Docker </a> Seite. <br> 
Wir installieren Docker auf ein Ubuntu 18.04 LTS. <br>

# Ältere Docker Versionen löschen <br>
```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

# Docker installieren <br>
```bash
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```

# GPG überprüfen <br>
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

# Docker Repository einrichten <br>
```bash
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

# Docker Engine installieren <br>
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

# Docker Version Engine auswählen <br>
```bash
apt-cache madison docker-ce

  docker-ce | 5:18.09.1~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
  docker-ce | 5:18.09.0~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
  docker-ce | 18.06.1~ce~3-0~ubuntu       | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
  docker-ce | 18.06.0~ce~3-0~ubuntu       | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
  
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io

sudo docker run hello-world
```

Jetzt könnt ihr mit dem Befehl ```sudo service Docker start/status/stop``` überprüfen ob alles funktioniert. <br>

Jetzt kommen wir zu dem Image Debian! <br>

# Docker Image Debian installieren <br>

Zunächst installieren wir die Image Datei. <br>
```bash 
docker pull debian
```

# Debian Docker Run <br>
```bash
docker run -it debian /bin/sh
```
Jetzt müssten wir uns in dem Container befinden. <br>

# Docker Container überprüfen  <br>
```bash
docker ps -a
CONTAINER ID        IMAGE                  COMMAND                  CREATED              STATUS                        PORTS                                           NAMES
8647ce2b84a5        debian                 "/bin/sh"                About a minute ago   Up About a minute                                                             elegant_rosalind
```
Erledigt! <br>

# Eigene Docker image erzeugen <br>
```bash 
sudo nano Dockerfile
```
Inahlt von Dockerfile:
```bash
# Dockerfile für Firecracker-Container, Kata-Container und Docker-Container erstellen.
# Installation von: Debian System, tools für die Bewertung von Containern, Webserver apache2
from docker.io/debian

MAINTAINER Vahel Hassan

RUN echo 'Debian wird installiert..'
RUN apt-get update && apt-get dist-upgrade

RUN echo 'sudo wird installiert..'
RUN apt-get install sudo -y

RUN echo 'systemd wird installiert..'
RUN apt-get install systemd -y

# Tools die wir später für unsere Leistungsbewertung benötigen
RUN echo 'fuer die Messung der Perfomance werden einige tools installiert..'
RUN sudo apt-get install stress

RUN echo 'sysstat wird installiert..'
RUN sudo apt-get install sysstat -y

RUN echo 'nistat wird installiert..'
RUN sudo apt-get install nicstat -y

# Webserver installieren
RUN echo 'Webserver apache2 wird installiert..'
RUN sudo apt install apache2 -y

RUN echo 'der Webserver wird gestartet..'
RUN sudo service apache2 start
```

# Dockerfile build
```bash
docker build -t test .
docker images 
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
test                            latest              3417c1c607bc        5 seconds ago       352MB
```
