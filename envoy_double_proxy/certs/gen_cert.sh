#!/bin/sh

# create CA key/cert
sudo /usr/local/openssl/apps/openssl req -x509 -new -newkey dilithium3 -keyout CA_key.pem -out CA_cert.pem -nodes -subj "/CN=localhost" -days 365 -config /usr/local/openssl/apps/openssl.cnf

# generate domain key
sudo /usr/local/openssl/apps/openssl req -x509 -new -newkey dilithium3 -keyout localhostkey.pem -nodes -subj "/CN=localhost" -days 365 -config /usr/local/openssl/apps/openssl.cnf

# generate proxy csr from domain key
sudo /usr/local/openssl/apps/openssl req -new -key localhostkey.pem -out localhost-frontend.csr -nodes -subj "/CN=localhost-frontend" -config /usr/local/openssl/apps/openssl.cnf
sudo /usr/local/openssl/apps/openssl req -new -key localhostkey.pem -out localhost-backend.csr -nodes -subj "/CN=localhost-backend" -config /usr/local/openssl/apps/openssl.cnf

# sign proxy certss
sudo /usr/local/openssl/apps/openssl x509 -req -in localhost-frontend.csr -out localhost-frontend.pem -CA CA_cert.pem -CAkey CA_key.pem -CAcreateserial -days 365
sudo /usr/local/openssl/apps/openssl x509 -req -in localhost-backend.csr -out localhost-backend.pem -CA CA_cert.pem -CAkey CA_key.pem -CAcreateserial -days 365

sudo chown -R dan *
