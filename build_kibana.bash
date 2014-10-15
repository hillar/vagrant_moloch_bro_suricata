#!/bin/bash

sudo apt-get -y -qq install git
sudo apt-get -y -qq install curl
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get -y -qq install nodejs
node -v
npm -v
cd /opt
git clone https://github.com/hmalphettes/kibana-proxy.git
cd kibana-proxy/
git submodule init
git submodule update
sudo npm install
# see https://github.com/hmalphettes/kibana-proxy#configuration

sudo -i 

cd /tmp

wget -q https://raw.githubusercontent.com/dollarampersand/moloch_installer/master/upstart/moloch-viewer.conf
mv moloch-viewer.conf kibana.conf
mv kibana.conf /etc/init/

USERNAME="daemon"
TDIR="/opt/kibana-proxy/"
ELAIP="192.168.33.111"
ELAPORT="9200"
ELA="${ELAIP}:${ELAPORT}"
 
sed -i -e "s,/viewer/,,g" -e "s,_TDIR_,${TDIR},g" -e "s,_USER_,${USERNAME},g" -e "s,NODE_ENV=production,ES_URL=http://${ELA},g" -e "s,viewer.js,app.js,g" /etc/init/kibana.conf 

mkdir ${TDIR}/logs
chown ${USERNAME}:${USERNAME} ${TDIR}/logs || exit $?
  
start kibana
sleep 1
status kibana