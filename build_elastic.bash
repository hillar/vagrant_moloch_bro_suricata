#!/bin/bash

sudo apt-get -y -qq install curl
sudo apt-get -y -qq install openjdk-7-jdk

cd /tmp

wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.4.deb
sudo dpkg -i elasticsearch-1.3.4.deb 

rm elasticsearch-1.3.4.deb

cd /usr/share/elasticsearch/bin/
sudo ./plugin -install mobz/elasticsearch-head
sudo ./plugin -install lukas-vlcek/bigdesk

# see https://github.com/aol/moloch/blob/master/single-host/etc/elasticsearch.yml
sudo echo "index.number_of_replicas: 0" >> /etc/elasticsearch/elasticsearch.yml
sudo echo "index.fielddata.cache: node" >> /etc/elasticsearch/elasticsearch.yml
sudo echo "indices.fielddata.cache.size: 40%" >> /etc/elasticsearch/elasticsearch.yml

sudo service elasticsearch start
# java is slow to start ;(
sleep 5
sudo service elasticsearch status

