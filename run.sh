#!/bin/bash
sed -ie "s/YOUR_DOMAIN/${DOMAIN}/" /etc/squid/squid.conf && \
ls -la /etc/squid/ssl_cert/ && \
squid -k parse && \
squid -f /etc/squid/squid.conf -NYC
