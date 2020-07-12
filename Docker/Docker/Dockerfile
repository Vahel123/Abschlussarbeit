# Dockerfile für Firecracker-Container, Kata-Container und Docker-Container erstellen.
# Installation von: Debian System, tools für die Bewertung von Containern, Webserver apache2
from debian

MAINTAINER Vahel Hassan <Vahel.Hassan@outlook.de>

RUN apt-get update && apt-get install -y

# Tools die wir später für unsere Leistungsbewertung benötigen

RUN apt-get install stress -y

RUN apt-get install sysstat -y

RUN apt-get install nicstat -y

RUN apt-get install iftop -y

RUN apt-get install -y tshark 

# Install Benchmark

RUN echo "deb http://deb.debian.org/debian  stretch main" >> /etc/apt/sources.list

RUN echo "deb-src http://deb.debian.org/debian  stretch main" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y libmariadbclient18

RUN apt-get install -y sysbench
