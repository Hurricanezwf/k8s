#!/bin/bash

set -e

source ${K8S_SCRIPTS_HOME}/env.sh


# 生成的kubeconfig文件路径
__kubeconfig__=${__KUBECONFIG__}

# apiserver地址
__kube_apiserver__=https://${__LOCAL_ADVERTISE_IP__}:6443

# CA
__certificate_authority__=${__CERT_DIR__}/k8s-ca.pem

# 客户端密钥
__client_key__=${__CERT_DIR__}/k8s-server-key.pem

# 客户端证书
__client_cert__=${__CERT_DIR__}/k8s-server.pem



# 初始化kubeconfig
# 在这里定制你想要的集群信息
function kubeconfig_init(){
	_init_clusters
	_init_users
	_init_contexts
	_use_default_context
	mv ${__kubeconfig__}.gen ${__kubeconfig__}
}


# 初始化集群信息
function _init_clusters(){
	kubectl config \
		--kubeconfig=${__kubeconfig__}.gen \
		set-cluster demo \
		--server=${__kube_apiserver__} \
		--certificate-authority=${__certificate_authority__}
		#--embed-certs=true
}


# 初始化用户信息
function _init_users(){
	kubectl config \
		--kubeconfig=${__kubeconfig__}.gen \
		set-credentials zwf \
		--client-key=${__client_key__} \
		--client-certificate=${__client_cert__}
		#--embed-certs=true

	kubectl config \
		--kubeconfig=${__kubeconfig__}.gen \
		set-credentials kubernetes \
		--client-key=${__client_key__} \
		--client-certificate=${__client_cert__}
		#--embed-certs=true

}


# 初始化上下文信息
function _init_contexts(){
	#kubectl config \
	#	--kubeconfig=${__kubeconfig__}.gen \
	#	set-context demo-for-zwf \
	#	--cluster=demo \
	#	--user=zwf \
	#	--namespace=ns-zwf

	kubectl config \
		--kubeconfig=${__kubeconfig__}.gen \
		set-context demo \
		--cluster=demo \
		--user=kubernetes \
		--namespace=default
}

# 初始化使用默认context
function _use_default_context(){
	kubectl config \
		--kubeconfig=${__kubeconfig__}.gen \
		use-context demo
}


kubeconfig_init
