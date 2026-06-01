# syntax=docker/dockerfile:1
# Pre-built image hosted on ghcr.io — built via GitHub Actions from source.
# See .github/workflows/build.yml for build details.

ARG BUILD_FROM=ghcr.io/mattjacobson6/obico-ml-api:latest
FROM ${BUILD_FROM}

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 3333

ENTRYPOINT ["/init"]
CMD ["/run.sh"]
