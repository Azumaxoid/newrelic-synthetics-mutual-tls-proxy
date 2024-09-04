FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV SQUID_VERSION=6.6

RUN apt-get update && \
    apt-get install -y squid-openssl
RUN openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout server_key.pem -out server_cert.pem -nodes -subj "/C=de/CN=newrelic.com"
COPY ./squid.conf /etc/squid/squid.conf
COPY ./run.sh run.sh
CMD ["./run.sh"]
