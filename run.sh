#!/bin/bash
mkdir -p /etc/squid/ssl_cert/;
cd /;
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout server_key.pem -out server_cert.pem -nodes -subj "/C=de/CN=newrelic.com"

# p12ファイルを使う場合はcertとkeyをあらかじめ展開する
if [ -f /etc/squid/ssl_cert/client.p12 ]; then
	cd /etc/squid/ssl_cert
	openssl pkcs12 -in client.p12 -out client.pem -clcerts -nokeys -passin pass:${PASSPHRASE} -passout pass:
	openssl pkcs12 -in client.p12 -out client_private_key.pem -nocerts -nodes -passin pass:${PASSPHRASE} -passout pass:
fi

sed -e "s/YOUR_DOMAIN/${DOMAIN}/" /tmp/squid.conf > /etc/squid/squid.conf && \
ls -la /etc/squid/ssl_cert/ && \
squid -k parse && \
squid -f /etc/squid/squid.conf -NYC