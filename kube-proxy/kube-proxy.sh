#!/bin/bash


source ${K8S_SCRIPTS_HOME}/env.sh


__tpl__=${K8S_SCRIPTS_HOME}/kube-proxy/config.yaml.tpl

__config__=${__CONF_DIR__}/kube-proxy-config.yaml


function init() {
	# 生成配置
	if [ ! -f ${__tpl__} ];then
		echo "${__tpl__} not found"
		exit -1
	fi

	cp ${__tpl__} ${__config__}
	sed -i "s#{__KUBECONFIG__}#${__KUBECONFIG__}#g" ${__config__}

	# 安装ipset命令
	hash ipset 2>/dev/null
	if [ "$?"x == "1"x ];then
		sudo yum -y install ipset
	fi
}


function start() {
	if [ ! -f ${__config__} ];then
		init
	fi

	sudo kube-proxy --config=${__config__}
}







case $1 in
	init)
		init
		;;
	start)
		start
		;;
	*)
		echo "Usage: ./kube-proxy.sh [options]"
		echo "Option:"
		echo "  start			start kube-proxy"
		exit -1
		;;
esac
exit 0
