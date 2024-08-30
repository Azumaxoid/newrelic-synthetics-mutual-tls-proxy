# New Relic Synthetics向け 相互TLS用Proxy
New Relic Syntheticsで、相互TLS/クライアント証明書が必要なサイトへのアクセスが必要な場合に利用できるProxyの実装例です。
2024/08当時の検証として準備したもののため、実装の参考としてご利用ください。

# 前提
セキュリティを考慮し、ユーザーのプライベート環境に準備する[Synthetics Job Manager](https://docs.newrelic.com/jp/docs/synthetics/synthetic-monitoring/private-locations/install-job-manager/)を利用することを前提とします。  
また、サンプルとしてDocker版を利用しています。

# 使い方例
```
# イメージをビルド
docker build . -t squid_client_cert_proxy
# 実行
docker run --name proxy \
	--network newrelic-synthetics \
	-p 3128:3128 \
	-e DOMAIN=.sockshop.nrkk.technology \
        -v ./fullchain.pem:/etc/squid/ssl_cert/server_cert.pem \
	-v ./privkey.pem:/etc/squid/ssl_cert/server_private_key.pem \
	-v ./client.pem:/etc/squid/ssl_cert/client.pem \
	-v ./client_private_key.pem:/etc/squid/ssl_cert/client_private_key.pem \
	squid_client_cert_proxy
```
* --network newrelic-synthetics
  * Job Managerと同じネットワークで実行します
* -p 3128:3128
  * 準備したポートを公開します。squidのデフォルト値を利用しています。
* -e DOMAIN=.sockshop.nrkk.technology
  * クライアント証明書を使ってアクセスするドメイン。例では*.sockshop.nrkk.technologyを全て許容してみている。
* -v ./fullchain.pem:/etc/squid/ssl_cert/server_cert.pem
  * ./fullchain.pem 接続したいドメインをCNとしたSSL 証明書
  * /etc/squid/ssl_cert/server_cert.pem Squidが利用する証明書のパス
* -v ./privkey.pem:/etc/squid/ssl_cert/server_private_key.pem
  * ./privkey.pem 接続したいドメインのSSL証明書と対となるprivate キー
  * /etc/squid/ssl_cert/server_private_key.pem Squidが利用するSSL証明書のPrivate キーのパス
* -v ./client.pem:/etc/squid/ssl_cert/client.pem
  * ./client.pem クライアント証明書
  * /etc/squid/ssl_cert/client.pem Squidが利用するクライアント証明書のパス
* -v ./client_private_key.pem:/etc/squid/ssl_cert/client_private_key.pem
  * ./client_private_key.pem クライアント証明書とツイになるprivateキー
  * /etc/squid/ssl_cert/client_private_key.pem Squidが利用するクライアント証明書のPrivate キーのパス


# 仕組み
SSLの通信内容を一度Proxyが解決し改めてサーバーにリクエストを送るSSL Bumpという機能を利用します。
https://www.squid-cache.org/Doc/config/ssl_bump/

クライアント -> Proxy　-> サーバー  
SSLで通信　　　SSLに加え  
　　　　　　　　クライアント証明書追加



また、この例ではセキュアな状態で通信を完結させるため、アクセスしたいドメインに対するサーバー証明書も組み込んでいます。

# Synthetics Scripted Browserのスクリプト例
```
$network.setProxy('http://proxy:3128') // ssl bumpを利用できるプロキシを設定
.then(()=>{
  // 通常通りサイトにアクセス
  return $browser.get('https://clientcerttest.sockshop.nrkk.technology')
})
```