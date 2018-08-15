#!/bin/bash

set -ex

source ./env.sh

# 生成的kubeconfig文件路径
__KUBECONFIG__=$K8S_SCRIPTS_HOME/kubeconfig.yaml

# apiserver地址
__KUBEAPISERVER__=https://192.168.2.102

# apiserver证书路径
__KUBEAPISERVER_CERT__=${__CERT_DIR__}/fake-ca-file

# 客户端密钥
__CLIENT_KEY__=${__CERT_DIR__}/fake-client-key

# 客户端证书
__CLIENT_CERT__=${__CERT_DIR__}/fake-client-cert



# 初始化kubeconfig
# 在这里定制你想要的集群信息
function kubeconfig_init(){
	_init_clusters
	_init_users
	_init_contexts
	mv ${__KUBECONFIG__}.gen ${__KUBECONFIG__}
}


# 初始化集群信息
function _init_clusters(){
	kubectl config \
		--kubeconfig=${__KUBECONFIG__}.gen \
		set-cluster demo \
		--server=${__KUBEAPISERVER__} \
		--certificate-authority=${__KUBEAPISERVER_CERT__}
		#--embed-certs=true
}


# 初始化用户信息
function _init_users(){
	kubectl config \
		--kubeconfig=${__KUBECONFIG__}.gen \
		set-credentials zwf \
		--client-key=${__CLIENT_KEY__} \
		--client-certificate=${__CLIENT_CERT__}
		#--embed-certs=true
}


# 初始化上下文信息
function _init_contexts(){
	kubectl config \
		--kubeconfig=${__KUBECONFIG__}.gen \
		set-context demo-for-zwf \
		--cluster=demo \
		--user=zwf \
		--namespace=ns-zwf
}
