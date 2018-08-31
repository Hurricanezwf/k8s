#!/bin/bash

set -e


source ${K8S_SCRIPTS_HOME}/env.sh




function start(){
	kube-scheduler \
		--v=5 \
		--kubeconfig=${__CONF_DIR__}/kubeconfig.yaml
}







case $1 in
	start)
		start
		;;
	*)
		echo "Usage: ./kube-scheduler.sh [options]"
		echo "Option:"
		echo "  start			start kube-scheduler"
		exit -1
		;;
esac
exit 0
