FROM haproxy:3.3-alpine

USER root

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg.template

EXPOSE 2375

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/tmp/haproxy.cfg"]
