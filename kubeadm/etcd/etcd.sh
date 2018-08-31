#!/bin/bash

set -e

__host_ip__=`ifconfig|grep '192.168'|awk '{print $2}'`

__etcd_name__="etcd0"

__etcd_cert_dir__="/etc/kubernetes/pki/etcd"

__etcd_data_dir__="/root/data/etcd"


function start(){
    docker run -d --name=${__etcd_name__} -v ${__etcd_cert_dir__}:${__etcd_cert_dir__} -v ${__etcd_data_dir__}:${__etcd_data_dir__} -p 4001:4001 -p 2379:2379 -p 2380:2380 etcd:v3.1.12 etcd \
        --debug=true \
        --enable-pprof=true \
        --name=${__etcd_name__} \
        --data-dir=${__etcd_data_dir__}/data/ \
        --wal-dir=${__etcd_data_dir__}/wal/ \
        --listen-peer-urls=https:\/\/0.0.0.0:2380 \
        --listen-client-urls=https:\/\/0.0.0.0:2379,https:\/\/0.0.0.0:4001 \
        --initial-advertise-peer-urls=https:\/\/${__host_ip__}:2380 \
        --advertise-client-urls=https:\/\/${__host_ip__}:2379 \
        --cert-file=${__etcd_cert_dir__}/server.pem \
        --key-file=${__etcd_cert_dir__}/server-key.pem \
        --client-cert-auth=true \
        --trusted-ca-file=${__etcd_cert_dir__}/ca.pem \
        --peer-cert-file=${__etcd_cert_dir__}/peer.pem \
        --peer-key-file=${__etcd_cert_dir__}/peer-key.pem \
        --peer-client-cert-auth=true \
        --peer-trusted-ca-file=${__etcd_cert_dir__}/ca.pem \
	--initial-cluster-token=etcd-cluster \
	--initial-cluster etcd0=https://192.168.2.105:2380,etcd1=https://192.168.2.106:2380,etcd2=https://192.168.2.107:2380
}


function stop() {
	docker stop ${__etcd_name__}
}

function remove(){
	docker rm -v ${__etcd_name__}
}



case $1 in
    start)
        start
        ;;
    stop)
	stop
	;;
    rm)
	remove
	;;
    *)  
        echo "Usage: ./etcd.sh [option]"
        echo "Options:"
        echo "  start           Start etcd"
	echo "  stop		Stop container"
	echo "  rm		Remove container"
        exit -1
        ;;
esac
exit 0

