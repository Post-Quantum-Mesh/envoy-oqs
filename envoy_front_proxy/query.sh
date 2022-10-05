#!/bin/bash

# Defaults
HELP=''
QUANTUM=''
SERVICE=''
FAIL=''

while getopts 'hfqs:' flag; do
    case "${flag}" in
        h) HELP=1 ;;
        f) FAIL=1 ;;
        q) QUANTUM=1 ;;
        s) SERVICE=${OPTARG} ;;
    esac
done

if [[ $HELP == 1 ]];
then
    printf "Envoy-OQS Front-Proxy Demo: \n    -h: Print help menu\n    -f: Query post-quantum server with standard curl implementation (will fail)\n    -q: Use post-quantum curl implementation\n    -s: Select which proxy service to query (1 or 2)\n"
    exit 1
fi

if [[ $SERVICE == '' ]];
then
    echo "Error, must specify service to be queried ('-s' flag with 1 or 2)"
    exit 1
fi

if [[ $QUANTUM == 1 ]];
then
    echo "Querying https server using post-quantum enabled curl..."
    echo
    sudo docker run --network host -it openquantumsafe/curl curl -v -k https://localhost:8443/service/$SERVICE -e SIG_ALG=dilithium3
else
    if [[ $FAIL == 1 ]];
    then
        echo "Querying https server using standard curl implementation..."
        echo
        curl https://localhost:8080/service/$SERVICE -k -v
    else
        echo "Querying http server using standard curl implementation..."
        echo
        curl -v http://localhost:8080/service/$SERVICE
    fi
fi