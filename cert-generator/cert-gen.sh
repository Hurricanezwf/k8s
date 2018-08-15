#!/bin/bash

source ${K8S_SCRIPTS_HOME}/env.sh


function cert_init(){
	echo '{
	"signing": {
		"default": {
			"expiry": "8760h"
 		},
    		"profiles": {
      			"kubernetes": {
        			"usages": [
          				"signing",
          				"key encipherment",
          				"server auth",
          				"client auth"
        			],
        			"expiry": "8760h"
      			}
    		}
	}
}'  > ${__CERT_DIR__}/ca-config.json

	echo '{
	"CN": "kubernetes",
	"hosts": [
		"127.0.0.1",
		"kubernetes",
		"kubernetes.default",
		"kubernetes.default.svc",
		"kubernetes.default.svc.cluster",
		"kubernetes.default.svc.cluster.local",
		"<MASTER_IP>",
		"<MASTER_CLUSTER_IP>"
	],
	"key": {
		"algo": "rsa",
		"size": 2048
	},
  	"names":[{
    		"C": "CN",
    		"ST": "Shanghai",
    		"L": "Shanghai",
    		"O": "mmtrix",
    		"OU": "demo"
  	}]
}' > ${__CERT_DIR__}/csr-config.json


	# start gen
	${K8S_SCRIPTS_HOME}/tools/cfssl gencert -initca ${__CERT_DIR__}/csr-config.json | ${K8S_SCRIPTS_HOME}/tools/cfssljson -bare ca
}
