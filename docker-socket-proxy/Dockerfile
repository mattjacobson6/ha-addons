# BUILD_FROM is injected by HA Supervisor from build.yaml (required since Supervisor 2026.04.0)
ARG BUILD_FROM
FROM ${BUILD_FROM}

# jq is used by run.sh to parse /data/options.json
RUN apk add --no-cache bash jq

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
