FROM debian:unstable
LABEL maintainer="Kris Nóva <kris@nivenly.com>"
COPY . /falco-trace
RUN /falco-trace/bin/build-falco
# TODO From Scratch this shit
CMD ["/falco-trace/bin/pdig"]