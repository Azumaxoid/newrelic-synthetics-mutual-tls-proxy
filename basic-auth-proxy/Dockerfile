FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV SQUID_VERSION=6.6

RUN apt-get update && \
    apt-get install -y squid-openssl apache2-utils
COPY ./squid.conf /etc/squid/squid.conf
CMD ["squid", "-f", "/etc/squid/squid.conf", "-NYC"]

