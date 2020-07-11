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

# Webserver installieren

RUN apt-get install apache2 -y

ENV APACHE_RUN_USER www-data

ENV APACHE_RUN_GROUP www-data

ENV APACHE_LOG_DIR /var/log/apache2

RUN echo 'Hello, docker' > /var/www/index.html

CMD service apache2 start && tail -F /var/log/mysql/error.log

# Install Benchmark

RUN echo "deb http://deb.debian.org/debian  stretch main" >> /etc/apt/sources.list

RUN echo "deb-src http://deb.debian.org/debian  stretch main" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y libmariadbclient18

RUN apt-get install -y sysbench
