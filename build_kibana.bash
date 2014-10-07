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
echo '#!/bin/bash' > /opt/run_kibana.bash
echo "cd /opt/kibana-proxy/" >> /opt/run_kibana.bash
echo "ES_URL=\"http://192.168.33.111:9200\" node app.js > /tmp/kiba.log & " >> /opt/run_kibana.bash
bash /opt/run_kibana.bash
sleep 1
tail /tmp/kiba.log