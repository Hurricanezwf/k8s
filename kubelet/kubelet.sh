#!/bin/sh

set -e

source ../env.sh

## 准备启动环境
function prepare(){
	swapoff -a
}

## 启动kubelet
function start(){
	prepare
	kubelet \
		#--bootstrap-kubeconfig=TODO \
		--cert-dir=$SHARED_HOME/certs \
		--cgroup-driver=systemd \
		#--cluster-domain=TODO \
		#-cluster-dns=TODO \
		--node-ip=$HOST_IP \
		--root-dir=$KUBELET_HOME
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
