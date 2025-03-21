FROM uselagoon/commons as commons
FROM amazeeio/envplate:v1.0.3 AS envplate
FROM dependencytrack/apiserver


# copy useful entrypoints and other components from the upstream uselagoon/commons image
# these are useful for leveraging the environment variable loading capabilities from other sources
# as well as enabling cronjobs to run within this container if required
COPY --from=commons /lagoon /lagoon
COPY --from=commons /bin/fix-permissions /bin/ep /bin/docker-sleep /bin/wait-for /bin/
COPY --from=commons /home /home

# sets up some basic shell settings
ENV TMPDIR=/tmp \
    TMP=/tmp \
    HOME=/home \
    ENV=/home/.bashrc \
    BASH_ENV=/home/.bashrc

USER root

COPY ./.env /opt/owasp/dependency-track/

# lagoon images usually use tini, commons provides this but it can't be used because it is from alpine
# this installs the right version
RUN apt-get -y update \
    && apt-get -y install curl \
    && rm -rf /var/lib/apt/lists/*
RUN architecture=$(case $(uname -m) in x86_64 | amd64) echo "amd64" ;; aarch64 | arm64 | armv8) echo "arm64" ;; *) echo "amd64" ;; esac) \
    && curl -sL https://github.com/krallin/tini/releases/download/v0.19.0/tini-${architecture} -o /sbin/tini && chmod a+x /sbin/tini

# fix permissions on mattermost directory to work with rootless workloads in lagoon
RUN fix-permissions /opt/owasp/dependency-track

USER dtrack

ENTRYPOINT ["/bin/bash", "--", "/lagoon/entrypoints.sh"]
CMD ["/bin/sh", "-c", "exec java ${JAVA_OPTIONS} ${EXTRA_JAVA_OPTIONS} --add-opens java.base/java.util.concurrent=ALL-UNNAMED -Dlogback.configurationFile=${LOGGING_CONFIG_PATH} -DdependencyTrack.logging.level=${LOGGING_LEVEL} -jar ${WAR_FILENAME} -context ${CONTEXT}"]
