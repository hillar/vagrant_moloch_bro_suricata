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
mv moloch-viewer.conf kibana3.conf
mv kibana3.conf /etc/init/

USERNAME="daemon"
TDIR="/opt/kibana-proxy/"
ELAIP="192.168.33.111"
ELAPORT="9200"
ELA="${ELAIP}:${ELAPORT}"
 
sed -i -e "s,/viewer/,,g" -e "s,_TDIR_,${TDIR},g" -e "s,_USER_,${USERNAME},g" -e "s,NODE_ENV=production,ES_URL=http://${ELA},g" -e "s,viewer.js,app.js,g" /etc/init/kibana.conf 

mkdir ${TDIR}/logs
chown ${USERNAME}:${USERNAME} ${TDIR}/logs || exit $?

# change default.json
wget -q https://raw.githubusercontent.com/aol/moloch/master/viewer/public/moloch_155.png
mv moloch_155.png /opt/kibana-proxy/kibana/src/img/
wget -q https://www.bro.org/images/bro-eyes.png
mv bro-eyes.png /opt/kibana-proxy/kibana/src/img/
wget -q http://www.openinfosecfoundation.org/images/stories/suricata.png
mv suricata.png /opt/kibana-proxy/kibana/src/img/
#TODO change this to file provision 
wget -q https://raw.githubusercontent.com/hillar/vagrant_moloch_bro_suricata/master/kibana_default.json
mv kibana_default.json /opt/kibana-proxy/kibana/src/app/dashboards/default.json
wget -q https://raw.githubusercontent.com/hillar/vagrant_moloch_bro_suricata/master/kibana_moloch.json
mv kibana_moloch.json /opt/kibana-proxy/kibana/src/app/dashboards/kibana_moloch.json
wget -q https://raw.githubusercontent.com/hillar/vagrant_moloch_bro_suricata/master/kibana_suricata.json
mv kibana_suricata.json /opt/kibana-proxy/kibana/src/app/dashboards/kibana_suricata.json
wget -q https://raw.githubusercontent.com/hillar/vagrant_moloch_bro_suricata/master/kibana_bro.json
mv kibana_bro.json /opt/kibana-proxy/kibana/src/app/dashboards/kibana_bro.json

  
start kibana3
sleep 1
status kibana3