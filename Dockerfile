FROM debian:unstable
LABEL maintainer="Kris Nóva <kris@nivenly.com>"
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	ncat
COPY ./bin/pdig /pdig
CMD ["pdig"]