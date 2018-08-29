#!/bin/bash

set -ex


source ${K8S_SCRIPTS_HOME}/env.sh


etcdctl --endpoints=https://${__LOCAL_ADVERTISE_IP__}:2379 --cert-file=${__CERT_DIR__}/etcd.pem --key-file=${__CERT_DIR__}/etcd-key.pem --ca-file=${__CERT_DIR__}/ca.pem  $@
