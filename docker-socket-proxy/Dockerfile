FROM haproxy:3.3-alpine

# Create required directories
RUN mkdir -p /var/lib/haproxy && \
    touch /var/lib/haproxy/server-state

COPY docker-entrypoint.sh /usr/local/bin/
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg.template
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

EXPOSE 2375

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/tmp/haproxy.cfg"]
