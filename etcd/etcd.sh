#!/bin/bash


function start(){
	etcd --config-file=$K8S_SCRIPTS_HOME/etcd/etcd-config.yaml
}



case $1 in
	start)
		start
		;;
	*)
		echo "Usage: ./etcd.sh [option]"
		echo "Options:"
		echo "  start			Start etcd"
		exit -1
		;;
esac
exit 0
		
