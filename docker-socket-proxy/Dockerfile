# BUILD_FROM is injected by HA Supervisor from build.yaml (required since Supervisor 2026.04.0)
ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN mkdir -p /var/lib/haproxy && touch /var/lib/haproxy/server-state

COPY docker-entrypoint.sh /usr/local/bin/
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg.template
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

EXPOSE 2375

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/sbin/haproxy", "-f", "/tmp/haproxy.cfg"]
