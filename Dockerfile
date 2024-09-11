FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV SQUID_VERSION=6.6

RUN apt-get update && \
    apt-get install -y squid-openssl
COPY ./run.sh run.sh
CMD ["./run.sh"]