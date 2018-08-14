#!/bin/sh

set -ex

source ../env.sh


# 存放证书的目录
__CERT_DIR__=${SHARED_HOME}/certs

# 当前主机一个网卡的IP
__HOST_IP__=`ifconfig|grep '192.168.'|awk '{print $2}'`

# 管理kubelet文件的目录
__KUBELET_ROOT_DIR__=${K8S_DATA_HOME}/kubelet-root




## 准备启动环境
function prepare(){
	# 关闭swap分区
	swapoff -a

	# 创建目录
	mkdir -p ${__CERT_DIR__}
	mkdir -p ${__KUBELET_ROOT_DIR__}
}

## 启动kubelet
function start(){
	prepare
	kubelet \
		--config=./kubelet-config.yaml \
		--cert-dir=${__CERT_DIR__} \
		--node-ip=${__HOST_IP__} \
		--root-dir=${__KUBELET_ROOT_DIR__}

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
