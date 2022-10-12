#!/bin/sh

# create CA key/cert
sudo /usr/local/openssl/apps/openssl req -x509 -new -newkey dilithium3 -keyout CA_key.pem -out CA_cert.pem -nodes -days 365 -config /usr/local/openssl/apps/openssl.cnf

# generate domain key
sudo /usr/local/openssl/apps/openssl req -x509 -new -newkey dilithium3 -keyout example.com.pem -nodes -days 365 -config /usr/local/openssl/apps/openssl.cnf

# generate proxy csr from domain key
sudo /usr/local/openssl/apps/openssl req -new -key example.com.pem -out proxy-postgres-frontend.example.com.csr -nodes -subj "/C=US/ST=CA/O=MyExample, Inc./CN=proxy-postgres-frontend.example.com" -config /usr/local/openssl/apps/openssl.cnf

sudo /usr/local/openssl/apps/openssl req -new -key example.com.pem -out proxy-postgres-backend.example.com.csr -nodes -subj "/C=US/ST=CA/O=MyExample, Inc./CN=proxy-postgres-backend.example.com" -config /usr/local/openssl/apps/openssl.cnf

# sign proxy certs
sudo su -c '/usr/local/openssl/apps/openssl x509 -req -in proxy-postgres-frontend.example.com.csr -CA CA_cert.pem -CAkey CA_key.pem -CAcreateserial -extfile <(printf "subjectAltName=DNS:proxy-postgres-frontend.example.com") -out postgres-frontend.example.com.pem -days 365'

sudo su -c '/usr/local/openssl/apps/openssl x509 -req -in proxy-postgres-backend.example.com.csr -CA CA_cert.pem -CAkey CA_key.pem -CAcreateserial -extfile <(printf "subjectAltName=DNS:proxy-postgres-backend.example.com") -out postgres-backend.example.com.pem -days 365'

sudo chown -R $USER *
