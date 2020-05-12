FROM debian:unstable

LABEL maintainer="Kris Nóva <kris@nivenly.com>"

COPY . /falco-trace

RUN apt --fix-broken install -y \
    && apt-get update \
    && apt-get install -y \
    emacs \
    wget \
    cmake \
    make \
    build-essential \
    libyaml-0-2 \
    ncat

RUN /falco-trace/bin/build

CMD ["/falco-trace/bin/pdig"]