#########################################
# Build stage
#########################################
FROM golang:1.8 AS builder
MAINTAINER Nicolas Carlier <n.carlier@nunux.org>

# Repository location
ARG REPOSITORY=github.com/nunux-keeper

# Artifact name
ARG ARTIFACT=keeper-cli

# Copy sources into the container
ADD . /go/src/$REPOSITORY/$ARTIFACT

# Set working directory
WORKDIR /go/src/$REPOSITORY/$ARTIFACT

# Build the binary
RUN make

#########################################
# Distribution stage
#########################################
FROM alpine
MAINTAINER Nicolas Carlier <n.carlier@nunux.org>

# Repository location
ARG REPOSITORY=github.com/nunux-keeper

# Artifact name
ARG ARTIFACT=keeper-cli

# App name
ARG APPNAME=keepctl

# Fix lib dep
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Install binary
COPY --from=builder /go/src/$REPOSITORY/$ARTIFACT/$APPNAME /usr/local/bin/
