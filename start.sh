# certおよびprivate keyを直接組み込む場合
docker run --name proxy \
	--network newrelic-synthetics \
	-p 3128:3128 \
	-v ./squid.conf:/tmp/squid.conf \
  -e DOMAIN=.sockshop.nrkk.technology \
	-v ./client.pem:/etc/squid/ssl_cert/client.pem \
	-v ./client_private_key.pem:/etc/squid/ssl_cert/client_private_key.pem \
	squid_client_cert_proxy

# p12ファイルを利用する場合
docker run -d --name proxy \
  --network newrelic-synthetics \
  -p 3128:3128 \
  -v ./squid.conf:/tmp/squid.conf \
  -e DOMAIN=.sockshop.nrkk.technology
  -v ./client.p12:/etc/squid/ssl_cert/client.p12 \
  -e PASSPHRASE=testtest123
  squid_client_cert_proxy

# p12ファイルを利用する多段プロキシを利用する場合
docker run -d --name proxy \
  --network newrelic-synthetics \
  -p 3128:3128 \
  -v ./squid-withparent-proxy.conf:/tmp/squid.conf \
  -e DOMAIN=.sockshop.nrkk.technology
  -v ./client.p12:/etc/squid/ssl_cert/client.p12 \
  -e PASSPHRASE=testtest123
  squid_client_cert_proxy
