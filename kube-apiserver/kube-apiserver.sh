#!/bin/bash

set -e

source ${K8S_SCRIPTS_HOME}/env.sh



function start(){
	mkdir -p ${__KUBE_APISERVER_ROOT_DIR__}/logs/

	eval kube-apiserver \
			--allow-privileged=false \
			--anonymous-auth=false \
			--apiserver-count=1 \
			--audit-log-path=${__KUBE_APISERVER_ROOT_DIR__}/logs/kube-apiserver-audit.log \
			--authorization-mode=Node,RBAC \
			--bind-address=${__LOCAL_ADVERTISE_IP__} \
			--client-ca-file=${__CERT_DIR__}/k8s-ca.pem \
			--enable-admission-plugins="" \
			--etcd-cafile=${__CERT_DIR__}/etcd-ca.pem \
			--etcd-certfile=${__CERT_DIR__}/etcd.pem \
			--etcd-keyfile=${__CERT_DIR__}/etcd-key.pem \
			--etcd-servers=http:\/\/${__LOCAL_ADVERTISE_IP__}:2379 \
			--kubelet-client-certificate= ${__CERT_DIR__}/k8s-server.pem \
			--kubelet-client-key=${__CERT_DIR__}/k8s-server-key.pem \
			--kubelet-https=true \
			--service-cluster-ip-range=10.0.0.0/24 \
			--tls-cert-file=${__CERT_DIR__}/k8s-server.pem \
			--tls-private-key-file=${__CERT_DIR__}/k8s-server-key.pem
}





case $1 in
	start)
		start
		;;
	*)
		echo "Usage: ./kube-apiserver.sh [option]"
		echo "Options:"
		echo "  start			Start kube-apiserver"
		exit -1
		;;
esac
exit 0
