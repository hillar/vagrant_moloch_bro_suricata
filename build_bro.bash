#!/bin/bash

sudo apt-get -y -qq install cmake make gcc g++ flex bison libpcap-dev libgeoip-dev libssl-dev python-dev zlib1g-dev libmagic-dev swig2.0
sudo apt-get -y -qq install geoip-database-contrib
sudo apt-get -y -qq install libcurl4-openssl-dev
sudo apt-get -y -qq install git

cd /tmp

git clone --recursive git://git.bro.org/bro
cd bro
./configure --disable-python --disable-broccoli
make
sudo make install
cd ..
rm -rf bro

# see https://www.bro.org/sphinx-git/scripts/policy/tuning/json-logs.bro.html?highlight=json
sudo -i

echo "@load tuning/json-logs" >> /usr/local/bro/share/bro/site/local.bro
echo "redef LogAscii::json_timestamps = JSON::TS_ISO8601;" >> /usr/local/bro/share/bro/site/local.bro
/usr/local/bro/bin/broctl check
/usr/local/bro/bin/broctl install

cd /home/vagrant
wget -q http://malware-traffic-analysis.net/2014/10/09/UpdateFlashPlayer_811e7dfc.exe-malwr.com-analysis.pcap
/usr/local/bro/bin/bro -r UpdateFlashPlayer_811e7dfc.exe-malwr.com-analysis.pcap /usr/local/bro/share/bro/site/local.bro 
#put template to elastic
wget -q https://raw.githubusercontent.com/hillar/vagrant_moloch_bro_suricata/master/elastic_template_bro.json
curl -XPUT http://192.168.33.111:9200/_template/bro -d@elastic_template_bro.json
#send weird.log to elastic
npm install byline
wget https://gist.githubusercontent.com/hillar/4b014ba3abcc07a8c5c9/raw/364e6bfcab31ea914b4aaf3a5244ee5520dee4c6/json2elastic.js
node json2elastic.js weird.log 192.168.33.111:9200/bro-1/weird



