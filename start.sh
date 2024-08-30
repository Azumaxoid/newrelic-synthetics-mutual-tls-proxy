docker run --name proxy \
	--network newrelic-synthetics \
	-p 3128:3128 \
	-e DOMAIN=.sockshop.nrkk.technology \
        -v ./fullchain.pem:/etc/squid/ssl_cert/server_cert.pem \
	-v ./privkey.pem:/etc/squid/ssl_cert/server_private_key.pem \
	-v ./client.pem:/etc/squid/ssl_cert/client.pem \
	-v ./client_private_key.pem:/etc/squid/ssl_cert/client_private_key.pem \
	squid_client_cert_proxy
