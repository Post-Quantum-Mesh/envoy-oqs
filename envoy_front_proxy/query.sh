#!/bin/bash

# Defaults
QUANTUM=0
SERVICE=0
FAIL=0

while getopts :f:q:s: flag
do
    case "${flag}" in
        f) FAIL=1;;
        q) QUANTUM=1;;
        s) SERVICE=${OPTARG};;
    esac
done

if [ $SERVICE == 0 ];
then
    echo "Error, must specify service to be queried ('-s' flag with 1 or 2)"
    exit 1
fi

if [ $QUANTUM == 1 ];
then
    echo "Querying https server using oqs enabled curl..."
    echo
    sudo docker run --network host -it openquantumsafe/curl curl -v -k https://localhost:8443/service/$SERVICE -e SIG_ALG=dilithium3
else
    echo "Querying http server using curl..."
    echo
    if [ $FAIL == 1 ];
    then
        curl https://localhost:8080/service/$SERVICE -k -v
    else
        curl -v http://localhost:8080/service/$SERVICE
    fi
fi