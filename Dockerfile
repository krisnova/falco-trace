FROM debian:unstable
LABEL maintainer="Kris Nóva <kris@nivenly.com>"
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	ncat \
	make \
	cmake

COPY . /falco-trace
RUN /falco-trace/bin/build-falco
CMD ["/falco-trace/bin/pdig"]