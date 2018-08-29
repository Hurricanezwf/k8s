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
      			}
    		}
	}
}'  > ${__CERT_DIR__}/ca-config.json


	# 准备kubelet专用的最高权限的根证书认证请求
	echo '{
	"CN": "admin",
	"hosts": [],
	"key": {
		"algo": "rsa",
		"size": 2048
	},
  	"names":[{
    		"C": "CN",
    		"ST": "Shanghai",
    		"L": "Shanghai",
    		"O": "system:masters",
    		"OU": "demo"
  	}]
}' > ${__CERT_DIR__}/admin-ca-csr.json

	# 准备通用根证书认证请求
	# Authorizer会取这里的CN当作user, O当作group进行授权验证
	echo '{
	"CN": "zwf",
	"hosts": [
		"127.0.0.1",
		"kubernetes",
		"kubernetes.default",
		"kubernetes.default.svc",
		"kubernetes.default.svc.cluster",
		"kubernetes.default.svc.cluster.local",
		"192.168.2.103",
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
    		"O": "system:kubelet-api-admin",
    		"OU": "demo"
  	}]
}' > ${__CERT_DIR__}/ca-csr.json

	# 准备etcd证书认证请求
	# Authorizer会取这里的CN当作user, O当作group进行授权验证
	echo '{
	"CN": "etcd",
	"hosts": [
		"127.0.0.1",
		"192.168.2.103"
	],
	"key": {
		"algo": "rsa",
		"size": 2048
	},
  	"names":[{
    		"C": "CN",
    		"ST": "Shanghai",
    		"L": "Shanghai",
    		"O": "demo",
    		"OU": "demo"
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


	# 执行生成根证书
	cd ${__CERT_DIR__}/
	cfssl gencert -initca ca-csr.json | cfssljson -bare ca

	# 生成经过根证书签名过的kubelet专用证书
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem --config=ca-config.json -profile=k8s admin-ca-csr.json | cfssljson -bare admin

	# 生成经过根证书签名过的通用证书
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem --config=ca-config.json -profile=k8s ca-csr.json  | cfssljson -bare k8s-server

	# 生成etcd专用证书
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem --config=ca-config.json -profile=k8s etcd-ca-csr.json | cfssljson -bare etcd
}

cert_init
