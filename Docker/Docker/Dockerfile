# Dockerfile für Firecracker-Container, Kata-Container und Docker-Container erstellen.
# Installation von: Debian System, tools für die Bewertung von Containern, Webserver apache2
from debian

MAINTAINER Vahel Hassan <Vahel.Hassan@outlook.de>

RUN apt-get update && apt-get install -y

RUN apt-get install sudo -y

RUN sudo apt-get install systemd -y

# Tools die wir später für unsere Leistungsbewertung benötigen
RUN sudo apt-get install stress

RUN sudo apt-get install sysstat -y

RUN sudo apt-get install nicstat -y 

# Webserver installieren
RUN sudo apt install apache2 -y

CMD sudo service apache2 start



