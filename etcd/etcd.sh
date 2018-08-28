#!/bin/bash

set -ex

source ${K8S_SCRIPTS_HOME}/env.sh


__etcd_name__="etcd-0"
__etcd_root__=${K8S_DATA_HOME}/${__etcd_name__}


function start(){
	mkdir -p ${__etcd_root__}

	etcd \
		--debug=true \
		--enable-pprof=true \
		--name=${__etcd_name__} \
		--data-dir=${__etcd_root__}/data/ \
		--wal-dir=${__etcd_root__}/wal/ \
		--listen-peer-urls=https:\/\/${__LOCAL_ADVERTISE_IP__}:2380 \
		--listen-client-urls=https:\/\/${__LOCAL_ADVERTISE_IP__}:2379 \
		--initial-advertise-peer-urls=https:\/\/${__LOCAL_ADVERTISE_IP__}:2380 \
		--advertise-client-urls=https:\/\/${__LOCAL_ADVERTISE_IP__}:2379 \
		--cert-file=${__CERT_DIR__}/etcd.pem \
		--key-file=${__CERT_DIR__}/etcd-key.pem \
		--client-cert-auth=true \
		--trusted-ca-file=${__CERT_DIR__}/etcd-ca.pem \
		--peer-cert-file=${__CERT_DIR__}/etcd.pem \
		--peer-key-file=${__CERT_DIR__}/etcd-key.pem \
		--peer-client-cert-auth=true \
		--peer-trusted-ca-file=${__CERT_DIR__}/etcd-ca.pem
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
		
