FROM golang:1.15-alpine AS buildenv

ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev
ENV VERSION v4.1.1

# Set up dependencies
RUN apk add --update --no-cache $PACKAGES

# Set working directory for the build
WORKDIR /go/src/github.com/cosmos/

# Add source files
RUN git clone --recursive https://www.github.com/cosmos/gaia
WORKDIR /go/src/github.com/cosmos/gaia

RUN git checkout $VERSION

# Install minimum necessary dependencies, build Cosmos SDK, remove packages
RUN make install

# ------------------------------------------------------------------ #

FROM alpine:edge

ENV GAIAD_HOME=/.gaiad

# Install ca-certificates
RUN apk add --no-cache --update ca-certificates py3-setuptools supervisor wget lz4 gzip

# Temp directory for copying binaries
RUN mkdir -p /tmp/bin
WORKDIR /tmp/bin

COPY --from=buildenv /go/bin/gaiad /tmp/bin
RUN install -m 0755 -o root -g root -t /usr/local/bin gaiad

# Remove temp files
RUN rm -r /tmp/bin

# Add supervisor configuration files
RUN mkdir -p /etc/supervisor/conf.d/
COPY /supervisor/supervisord.conf /etc/supervisor/supervisord.conf 
COPY /supervisor/conf.d/* /etc/supervisor/conf.d/


WORKDIR $GAIAD_HOME

# Expose ports
EXPOSE 26656 26657 26658
EXPOSE 1317

# Add entrypoint script
COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

STOPSIGNAL SIGINT
