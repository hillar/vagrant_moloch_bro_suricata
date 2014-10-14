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


#put template to elastic
#curl -XPUT http://192.168.33.111:9200/_template/bro -d@elastic_template_bro.json
