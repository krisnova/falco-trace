FROM rastasheep/ubuntu-sshd:latest

LABEL maintainer="Kris Nóva <kris@nivenly.com>"

COPY . /falco-trace

RUN echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
    emacs \
    wget \
    cmake \
    make \
    build-essential \
    libyaml-0-2 \
    netcat

RUN /falco-trace/bin/build

CMD ["/falco-trace/bin/falco"]