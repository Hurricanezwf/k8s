#!/bin/bash

set -e

source ${K8S_SCRIPTS_HOME}/env.sh


function cert_init(){
	_prepare_config
	_do_gen
}



function _prepare_config(){
	# parepare ca-config.json
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

	# parepare ca-csr.json
	echo '{
	"CN": "kubernetes",
	"hosts": [
		"127.0.0.1",
		"kubernetes",
		"kubernetes.default",
		"kubernetes.default.svc",
		"kubernetes.default.svc.cluster",
		"kubernetes.default.svc.cluster.local",
		"192.168.2.102"
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
}' > ${__CERT_DIR__}/ca-csr.json

}


function _do_gen(){
	# 软连接cfssl和cfssljson
	if [ ! -f ${K8S_BIN_HOME}/cfssl ];then
		ln -s ${K8S_SCRIPTS_HOME}/tools/cfssl ${K8S_BIN_HOME}/cfssl
	fi

	if [ ! -f ${K8S_BIN_HOME}/cfssljson ];then
		ln -s ${K8S_SCRIPTS_HOME}/tools/cfssljson ${K8S_BIN_HOME}/cfssljson
	fi


	# 执行生成命令
	cd ${__CERT_DIR__}/
	cfssl gencert -initca ca-csr.json | cfssljson -bare ca
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem --config=ca-config.json -profile=kubernetes ca-csr.json | cfssljson -bare server
}
