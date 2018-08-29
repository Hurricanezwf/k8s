#!/bin/bash

set -e

source ${K8S_SCRIPTS_HOME}/env.sh


__tpl__=${K8S_SCRIPTS_HOME}/kube-proxy/config.yaml.tpl

__config__=${__CONF_DIR__}/kube-proxy-config.yaml


function init() {
	if [ ! -f ${__tpl__} ];then
		echo "${__tpl__} not found"
		exit -1
	fi

	cp ${__tpl__} ${__config__}
	sed -i "s#{__KUBECONFIG__}#${__KUBECONFIG__}#g" ${__config__}
}


function start() {
	kube-proxy --config=${__config__}
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
