#!/bin/sh

set -ex

source ../env.sh


# 准备启动环境
function prepare(){
	# 关闭swap分区
	swapoff -a

	# 创建目录
	mkdir -p ${__CERT_DIR__}
	mkdir -p ${__KUBELET_ROOT_DIR__}
}

# 启动kubelet
function start(){
	prepare
	kubelet \
		--config=${__KUBELET_CONFIG__} \
		--kubeconfig=${__KUBECONFIG__} \
		--cert-dir=${__CERT_DIR__} \
		--node-ip=${__HOST_IP__} \
		--root-dir=${__KUBELET_ROOT_DIR__} \
		-v 3

	#--bootstrap-kubeconfig=TODO
	#--cluster-domain=TODO
	#-cluster-dns=TODO
}




case $1 in
	start)
		start
		;;
	*)
		echo "Usage: ./kubelet.sh [option]"
		echo "Options:"
		echo "  start			Start kubelet"
		exit -1
		;;
esac
exit 0
