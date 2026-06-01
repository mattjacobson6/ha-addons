# BUILD_FROM is injected by HA Supervisor from build.yaml
# Uses The Spaghetti Detective's official ml_api_base image (pre-built, production-tested)
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Copy HA addon startup script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# The base image already exposes port 3333 and has ML models included
EXPOSE 3333

# Run the startup script directly (the base image doesn't have /init)
CMD ["/run.sh"]
