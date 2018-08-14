#!/bin/sh

set -ex

source ../env.sh


# 存放证书的目录
__CERT_DIR__=$SHARED_HOME/certs

# Cgroup Driver
__CGROUP_DRIVER__=systemd

# 当前主机一个网卡的IP
__HOST_IP__=`ifconfig|grep '192.168.'|awk '{print $2}'`




## 准备启动环境
function prepare(){
	swapoff -a
}

## 启动kubelet
function start(){
	prepare
	kubelet \
		--cert-dir=${__CERT_DIR__} \
		--cgroup-driver=${__CGROUP_DRIVER__} \
		--node-ip=${__HOST_IP__} \
		--root-dir=${KUBELET_HOME}

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
