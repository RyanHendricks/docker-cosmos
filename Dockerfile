FROM golang:alpine AS build-env

# Modified from original cosmos-sdk Dockerfile

ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev
ENV VERSION=v0.34.0

# Set up dependencies
RUN apk add --no-cache $PACKAGES

# Set working directory for the build
WORKDIR /go/src/github.com/cosmos/

# Add source files
RUN git clone --recursive https://www.github.com/cosmos/cosmos-sdk
WORKDIR /go/src/github.com/cosmos/cosmos-sdk
RUN git checkout $VERSION

# Install minimum necessary dependencies, build Cosmos SDK, remove packages
RUN make tools && \
    make install

# Final image
FROM alpine:edge

ENV GAIAD_HOME=/.gaiad

# Install ca-certificates
RUN apk add --update ca-certificates

WORKDIR /tmp

# Copy over binaries from the build-env
COPY --from=build-env /go/bin/gaiad /tmp
COPY --from=build-env /go/bin/gaiacli /tmp
RUN install -m 0755 -o root -g root -t /usr/local/bin `find . -maxdepth 1 -executable -type f`

WORKDIR $GAIAD_HOME

EXPOSE 26656 26657 26658
EXPOSE 1317

ADD ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

STOPSIGNAL SIGINT