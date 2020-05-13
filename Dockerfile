# Build from unstable debian as it gets security updates faster than stable
FROM debian:stable AS base
LABEL maintainer="Kris Nóva <kris@nivenly.com>"
COPY . /falco-trace
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
    wget \
    cmake \
    make \
    build-essential \
    libyaml-0-2 \
    ca-certificates
RUN /falco-trace/bin/build
CMD ["/falco-trace/bin/falco"]
