#!/bin/bash

set -e


source ${K8S_SCRIPTS_HOME}/env.sh



function start(){
	kube-controller-manager \
			--cluster-name=demo \
			--cluster-signing-cert-file=${__CERT_DIR__}/k8s-server.pem \
			--cluster-signing-key-file=${__CERT_DIR__}/k8s-server-key.pem \
			--root-ca-file=	${__CERT_DIR__}/ca.pem \
			--tls-cert-file=${__CERT_DIR__}/k8s-server.pem \
			--tls-private-key-file=${__CERT_DIR__}/k8s-server-key.pem \
			--kubeconfig=${__CONF_DIR__}/kubeconfig.yaml \
			--profiling=true
			--v=4
}





case $1 in
	start)
		start
		;;
	*)
		echo "Usage: ./kube-controller-manager.sh [options]"
		echo "Option:"
		echo "  start			start kube-controller-manager"
		exit -1
		;;
esac
exit 0
