#!/bin/bash

set -e

source ${K8S_SCRIPTS_HOME}/env.sh


function cert_init(){
	_prepare_config
	_do_gen
}



function _prepare_config(){
	mkdir -p ${__CERT_DIR__}

	# parepare ca-config.json
	echo '{
	"signing": {
		"default": {
			"expiry": "8760h"
 		},
    		"profiles": {
      			"k8s": {
        			"usages": [
          				"signing",
          				"key encipherment",
          				"server auth",
          				"client auth"
        			],
        			"expiry": "8760h"
      			},
			"etcd": {
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

	# parepare k8s-ca-csr.json for k8s
	echo '{
	"CN": "kubernetes",
	"hosts": [
		"127.0.0.1",
		"kubernetes",
		"kubernetes.default",
		"kubernetes.default.svc",
		"kubernetes.default.svc.cluster",
		"kubernetes.default.svc.cluster.local",
		"192.168.2.102",
		"192.168.3.34",
		"192.168.3.35",
		"192.168.3.36",
		"192.168.3.37"
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
}' > ${__CERT_DIR__}/k8s-ca-csr.json

	# parepare etcd-ca-csr.json for etcd only
	echo '{
	"CN": "etcd",
	"hosts": [
		"127.0.0.1",
		"192.168.2.102",
		"192.168.3.34",
		"192.168.3.35",
		"192.168.3.36",
		"192.168.3.37"
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
    		"OU": "etcd"
  	}]
}' > ${__CERT_DIR__}/etcd-ca-csr.json

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
	cfssl gencert -initca k8s-ca-csr.json | cfssljson -bare k8s-ca
	cfssl gencert -ca=k8s-ca.pem -ca-key=k8s-ca-key.pem --config=ca-config.json -profile=k8s k8s-ca-csr.json  | cfssljson -bare k8s-server

	cfssl gencert -initca etcd-ca-csr.json | cfssljson -bare etcd-ca
	cfssl gencert -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem --config=ca-config.json -profile=etcd etcd-ca-csr.json | cfssljson -bare etcd
}

cert_init
