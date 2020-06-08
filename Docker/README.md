# Docker mit Alpine Image installieren und diese dann innerhalb eines Container ausführen. <br>

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

Jetzt könnt ihr mit dem Befehl ```bash sudo service Docker start/status/stop``` überprüfen ob alles funktioniert. <br>

Jetzt kommen wir zu dem Image Alpine! <br>

# Docker Image Alpine installieren <br>

Zunächst installieren wir die Image Datei. <br>
```bash 
docker pull alpine
```

# Alpine Docker Run <br>
```bash
docker run -it alpine /bin/sh
```
Jetzt müssten wir uns in dem Container befinden. <br>

# Docker Container überprüfen  <br>
```bash
docker ps -a
CONTAINER ID        IMAGE                  COMMAND                  CREATED              STATUS                        PORTS                                           NAMES
8647ce2b84a5        alpine                 "/bin/sh"                About a minute ago   Up About a minute                                                             elegant_rosalind
```
Erledigt! <br>
