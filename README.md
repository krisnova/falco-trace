# Falco Trace
Falco Running with ptrace(2) for Kernel Events container image

## Running bash with Falco and pdig in a container

```
docker run -it -p 443:443 krisnova/falco-trace:latest /bin/bash
falco -u --pidfile /var/run/falco.pid --daemon
pdig -a /bin/bash
  # Do nasty things here
  cat /etc/shadow
  touch /usr/bin/scary
  exit
cat /var/log/falco.log
```

## Running a vulnerable server with Falco and pdig

In one terminal run the following to start the `bin/server` process with `pdig`. This will send events from the process to Falco as an input source. 

```
docker run -it -p 443:443 krisnova/falco-trace:latest /bin/bash
PORT=443 pdig -a "/falco-trace/bin/server"
falco -u -c /etc/falco/falco.yaml --pidfile /var/run/falco
```

In another shell you can "hack" into the server using the following command

```
ncat -nv 127.0.0.1 443
```

## Building the container image

```
docker built -t yourorg/falco-trace:latest .
docker push yourorg/falco-trace:latest
```
