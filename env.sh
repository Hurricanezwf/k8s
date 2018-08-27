#!/bin/sh


if [ -z ${K8S_SCRIPTS_HOME} ];then
	echo "ENV 'K8S_SCRIPTS_HOME' should be set"
	exit -1
fi

if [ -z ${K8S_BIN_HOME} ];then
	echo "ENV 'K8S_BIN_HOME' should be set"
	exit -1
fi

if [ -z ${K8S_DATA_HOME} ];then
	echo "ENV 'K8S_DATA_HOME' should be set"
fi




__LOCAL_ADVERTISE_IP__=192.168.3.34


KUBELET_HOME=$K8S_SCRIPTS_HOME/kubelet

# 存放证书的目录
# 不要移动该变量的位置
__CERT_DIR__=${K8S_DATA_HOME}/certs

__CONF_DIR__=${K8S_DATA_HOME}/configs


## ======================== kubeconfig generator ========================= ##

# 生成的kubeconfig文件路径
__KUBECONFIG__=${__CONF_DIR__}/kubeconfig.yaml

# apiserver地址
__KUBEAPISERVER__=https://192.168.2.102

# apiserver证书路径
__KUBEAPISERVER_CERT__=${__CERT_DIR__}/server.pem

# 客户端密钥
__CLIENT_KEY__=${__CERT_DIR__}/ca-key.pem

# 客户端证书
__CLIENT_CERT__=${__CERT_DIR__}/ca.pem




## ================================ kubelet ================================= ##

# kubelet配置路径
__KUBELET_CONFIG__=${K8S_SCRIPTS_HOME}/kubelet/kubelet-config.yaml


# 当前主机一个网卡的IP
__HOST_IP__=`ifconfig|grep '192.168.'|awk '{print $2}'`

# 管理kubelet文件的目录
__KUBELET_ROOT_DIR__=${K8S_DATA_HOME}/kubelet-root







## =============================== kube-apiserver ============================= ##

# kube-apiserver数据根目录
__KUBE_APISERVER_ROOT_DIR__=${K8S_DATA_HOME}/kube-apiserver-root
