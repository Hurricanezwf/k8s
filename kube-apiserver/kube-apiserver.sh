#!/bin/bash

set -e

source ${K8S_SCRIPTS_HOME}/env.sh



function start(){
			--allow-privileged=false \
			--anonymous-auth=false \
			--apiserver-count=1 \
			--audit-log-path=/root/k8s-data/kube-apiserver-root/logs/kube-apiserver-audit.log \
			--authorization-mode=Node,RBAC \
			--bind-address=${__LOCAL_ADVERTISE_IP__} \
			--client-ca-file= \
			--enable-admission-plugins= \
			--etcd-cafile= \
			--etcd-certfile= \
			--etcd-keyfile = \
			--etcd-servers=http://${__LOCAL_ADVERTISE_IP__}:2379 \
			--kubelet-certificate-authority= \
			--kubelet-client-certificate= \
			--kubelet-client-key= \
			--kubelet-https= true \
			--service-cluster-ip-range=10.0.0.0/24 \
			--tls-cert-file= \
			--tls-private-key-file= \
	
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
