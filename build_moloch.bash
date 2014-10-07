#!/bin/bash

sudo apt-get -y -qq install curl
# see https://github.com/joyent/node/wiki/installing-node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get -y -qq install nodejs
node -v
npm -v

sudo apt-get -y -qq install git

# see https://github.com/aol/moloch#building-and-installing
sudo apt-get -y -qq install wget libpcre3-dev uuid-dev libmagic-dev pkg-config g++ flex bison zlib1g-dev libffi-dev gettext libgeoip-dev make libjson-perl libbz2-dev libwww-perl libpng-dev xz-utils libffi-dev

sudo -i

cd /tmp

git clone https://github.com/aol/moloch.git
cd moloch/
TDIR="/usr/local/moloch"
ELAIP="192.168.33.111" # see Vagrantfile
ELAPORT="9200"
ELA="${ELAIP}:${ELAPORT}"

echo "MOLOCH: Creating install area"
mkdir -p ${TDIR}/data
mkdir -p ${TDIR}/logs
mkdir -p ${TDIR}/raw
mkdir -p ${TDIR}/etc
mkdir -p ${TDIR}/bin
mkdir -p ${TDIR}/db
cp single-host/etc/* ${TDIR}/etc

echo "MOLOCH: building .."
./easybutton-build.sh -d ${TDIR}
sudo make install

USERNAME="daemon"
GROUPNAME="daemon"
PASSWORD="0mgMolochRules1"
INTERFACE="eth2";

cat ${TDIR}/etc/config.ini.template | sed -e 's/_PASSWORD_/'${PASSWORD}'/g' -e 's/_USERNAME_/'${USERNAME}'/g' -e 's/_GROUPNAME_/'${GROUPNAME}'/g' -e 's/_INTERFACE_/'${INTERFACE}'/g'  -e "s,_TDIR_,${TDIR},g" -e 's/localhost:9200/'${ELA}'/g' -e 's/certFile/#certFile/g' -e 's/keyFile/#keyFile/g'> ${TDIR}/etc/config.ini

#wipe elasticsearch
curl -XDELETE "http://${ELAIP}:${ELAPORT}/*"
sleep 3
cd ${TDIR}/db
./db.pl ${ELAIP}:${ELAPORT} init

cd ${TDIR}/viewer/
node addUser.js admin 'root admin' admin -c ../etc/config.ini --admin

ln -s /usr/share/GeoIP/GeoIP.dat /usr/local/moloch/etc/GeoIP.dat
cd /usr/share/GeoIP/
wget http://www.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
gzip -d GeoIPASNum.dat.gz 
ln -s /usr/share/GeoIP/GeoIPASNum.dat /usr/local/moloch/etc/GeoIPASNum.dat
cd /usr/local/moloch/etc/
wget https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv

cd ${TDIR}/viewer
node viewer.js -c ../etc/config.ini > /tmp/viewer.log &
sleep 1
tail /tmp/viewer.log



