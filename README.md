vagrant_moloch_bro_suricata
===========================

vagrant multi-machine: Moloch, Bro, Suricata, ElasticSearch, Kibana

vagrant base box :: robwc/minitrusty64

provision :: 

* build Moloch
* build Bro from source
* build Suricata from source
* install Elasticsearch
* install Kibana

port forwarding ::

| localhost  | host|
| ------------- | ------------- |
| localhost:9200  | elastic:9200  | 
| localhost:8005  | moloch:8005  |
| localhost:3003  | kibana:3003 |


## Prerequisites

- 8(+) GB RAM 
- [Vagrant](http://vagrantup.com) 
- [Virtualbox](https://www.virtualbox.org/wiki/Linux_Downloads) 
- A internet connection. The system will download about 1'ish GB of data over the Internets for the first deployment.

see also http://slid.es/hillar/network-forensics
