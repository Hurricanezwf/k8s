#!/bin/bash

set -e

source ${K8S_SCRIPTS_HOME}/env.sh

# 初始化kubeconfig
# 在这里定制你想要的集群信息
function kubeconfig_init(){
	_init_clusters
	_init_users
	_init_contexts
	_use_default_context
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

# 初始化使用默认context
function _use_default_context(){
	kubectl config \
		--kubeconfig=${__KUBECONFIG__}.gen \
		use-context demo-for-zwf
}


kubeconfig_init
