# Example Apps

Here you will find sample applications that will help you get started with running an arbitrary workload with Falco.

## Creating an App

Copy the skeleton app to a new folder

```
cp -rv _SkeletonApplication MyNewApp
```

#### README.md

Please add any notes about your new application in this file. At the minimum it should have an example `docker run` command.

```
docker run myregistry/falco-trace-lowercaseappname:latest
```

#### Dockerfile

This is operating system logic.

Feel free to make changes here if needed, but I ([Kris Nóva](https://github.com/kris-nova/)) tend to opt to only define dependencies for the operarting system here, and have all the app logic in `.init.sh`.

Feel free to do whatever, just document it please.

#### init.sh

This is application level logic.

Given your approach and goals of your app, you might run falco in various ways here but most likely your Falco call will end up looking something like this.

```
falco -u --pidfile /var/run/falco.pid --daemon
tail -f /var/log/falco.log & 
```

Note that tailing the logs is required for the Falco logs to go to CloudWatch or Kubernetes logs.

In order for Falco to understand anything about your application we have to monitor the original PID.

We use a tool called `pdig` to do this. The executable is baked into the image and exists in $PATH.

Depending on your goals of your app, you might find yourself doing things like this to run your app.

```
sh myapp/init.sh
pdig -a "./myapp --flag=true" &
pdig -a "./my-sidecar-feature --flag=false" &
pdig -a "tail -f /var/log/myapp.log" &
pdig -a "tail -f /var/log/syslog" &
```

As long as your application is running with `pdig` Falco will automatically start monitoring it for security violations.

