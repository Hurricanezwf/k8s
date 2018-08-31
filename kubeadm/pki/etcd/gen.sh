#!/bin/bash

set -e


function clean(){
	rm -f *.csr
	rm -f *.pem
}

function gen(){
	clean

	# 生成根证书
	cfssl gencert -initca ./src/ca-csr.json | cfssljson -bare ca -

	# 生成客户端证书, 用于给服务端验证客户端的身份
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=./src/ca-config.json -profile=client ./src/client.json | cfssljson -bare client

	# 生成服务端证书，用于给客户端验证服务端的身份
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=./src/ca-config.json -profile=server ./src/config.json | cfssljson -bare server

	# 生成集群内部通信证书
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=./src/ca-config.json -profile=peer   ./src/config.json | cfssljson -bare peer
}




case $1 in
	clean)
		clean
		;;
	gen)
		gen
		;;
	*)
		echo "Usage: ./gen.sh [options]"
		echo "Option:"
		echo "  clean			clean all .pem .csr"
		echo "  gen			gen cert files"
		exit -1
		;;
esac
exit 0
