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



                                                  ### 这里主要存放一些各个模块需要用到的共享变量 ###


# 本地地址，非0.0.0.0
#__LOCAL_ADVERTISE_IP__=192.168.2.102
__LOCAL_ADVERTISE_IP__=192.168.3.34

# 存放证书的目录
# 不要移动该变量的位置
__CERT_DIR__=${K8S_DATA_HOME}/certs

# 存放脚本生成的配置的目录
__CONF_DIR__=${K8S_DATA_HOME}/configs

# 生成的kubeconfig文件路径
__KUBECONFIG__=${__CONF_DIR__}/kubeconfig.yaml
