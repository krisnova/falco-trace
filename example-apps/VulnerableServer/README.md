# Vulnerable Server

WARNING: Do not run this in production.

```
docker run krisnova/falco-trace-vulnerablewebserver:latest
```

---

This is a docker image that is intentionally vulnerable and can be used in live demos to simulate an attacker doing something malicious in production.

### Running the server

In the first terminal

```
docker run -p 443:443 krisnova/falco-trace-vulnerableserver:latest
```

In a second terminal

```
ncat -nv 127.0.0.1 443
ls
cat /etc/shadow
touch /usr/bin/scary
exit
```

Now look at the logs in the running doctor container as the notices are being sent to standard out.