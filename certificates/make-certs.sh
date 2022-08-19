#! /bin/bash

# keys
/usr/local/opt/openssl/bin/openssl genrsa -out root.key
/usr/local/opt/openssl/bin/openssl genrsa -out edge1.key
/usr/local/opt/openssl/bin/openssl genrsa -out edge2.key
/usr/local/opt/openssl/bin/openssl genrsa -out server.key

# root cert / certifying authority
/usr/local/opt/openssl/bin/openssl req -x509 -new -nodes -key root.key -subj "/C=US/ST=KY/O=Org/CN=root" -sha256 -days 100000 -out root.crt

# csrs - certificate signing requests
/usr/local/opt/openssl/bin/openssl req -new -sha256 -key edge1.key -subj "/C=US/ST=KY/O=Org/CN=edge1" -out edge1.csr
/usr/local/opt/openssl/bin/openssl req -new -sha256 -key edge2.key -subj "/C=US/ST=KY/O=Org/CN=edge2" -out edge2.csr
/usr/local/opt/openssl/bin/openssl req -new -sha256 -key server.key -subj "/C=US/ST=KY/O=Org/CN=$1" -addext "subjectAltName=DNS:$1" -out server.csr

# certificates
/usr/local/opt/openssl/bin/openssl x509 -req -in edge1.csr -CA root.crt -CAkey root.key -CAcreateserial -out edge1.crt -days 100000 -sha256
/usr/local/opt/openssl/bin/openssl x509 -req -in edge2.csr -CA root.crt -CAkey root.key -CAcreateserial -out edge2.crt -days 100000 -sha256
/usr/local/opt/openssl/bin/openssl x509 -req -in server.csr -CA root.crt -CAkey root.key -CAcreateserial -out server.crt -days 100000 -sha256 -extfile <(printf "subjectAltName=DNS:$1")