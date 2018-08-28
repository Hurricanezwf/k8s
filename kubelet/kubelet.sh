#!/bin/sh

set -e

source ${K8S_SCRIPTS_HOME}/env.sh


# kubelet配置路径
__kubelet_config__=${K8S_SCRIPTS_HOME}/kubelet/kubelet-config.yaml

# 管理kubelet文件的目录
__kubelet_root_dir__=${K8S_DATA_HOME}/kubelet-root



# 准备启动环境
function prepare(){
	# 关闭swap分区
	swapoff -a

	# 创建目录
	mkdir -p ${__CERT_DIR__}
	mkdir -p ${__kubelet_root_dir__}
}

# 启动kubelet
function start(){
	prepare
	kubelet \
		--config=${__kubelet_config__} \
		--kubeconfig=${__KUBECONFIG__} \
		--cert-dir=${__CERT_DIR__} \
		--node-ip=${__LOCAL_ADVERTISE_IP__} \
		--root-dir=${__kubelet_root_dir__} \
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
