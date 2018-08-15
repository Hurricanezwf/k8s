#!/bin/sh


K8S_SCRIPTS_HOME=/root/k8s-scripts

K8S_BIN_HOME=/root/k8s-bin

K8S_DATA_HOME=/root/k8s-data

KUBELET_HOME=$K8S_SCRIPTS_HOME/kubelet

# 存放证书的目录
# 不要移动该变量的位置
__CERT_DIR__=${K8S_DATA_HOME}/certs


## ======================== kubeconfig generator ========================= ##

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




## ================================ kubelet ================================= ##

# kubelet配置路径
__KUBELET_CONFIG__=${K8S_SCRIPTS_HOME}/kubelet/kubelet-config.yaml


# 当前主机一个网卡的IP
__HOST_IP__=`ifconfig|grep '192.168.'|awk '{print $2}'`

# 管理kubelet文件的目录
__KUBELET_ROOT_DIR__=${K8S_DATA_HOME}/kubelet-root


