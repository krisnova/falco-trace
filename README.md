# Falco Trace
Falco Running with ptrace(2) for Kernel Events container image

This repository is designed to bootstrap running Falco with `pdig`.

Given the way this project uses Falco, we are able to run falco in
the following way.

 - NO Linux Kernel headers required
 - NO Compiling / Downloading a kernel module
 - NO BPF probe
 - Falco running as a daemon with logs going to `STDOUT`
 - Falco running against a process

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

## Kubernetes

You can run Falco in Kubernetes without needing to privilege escalate or manage a kernel module.

```
kubectl run falco --image krisnova/falco-trace:latest
kubectl logs falco -f
kubectl delete po falco
```

You can run a vulnerable server in Kubernetes and show Falco working

```
kubectl run vs --image krisnova/falco-trace-vulnerableserver:latest --expose --port 443
sudo kubectl port-forward svc vs 443:443
nc -nv 127.0.0.1 443
cat /etc/shadow
exit
kubectl logs falco -f
```

## SSH

You can run [the SSH image](https://github.com/kris-nova/falco-trace/tree/master/example-apps/SSH) for easy backend access to a container via SSH.

```
docker run -p 1313:22 krisnova/falco-trace-ssh:latest
```

Then from another shell

```
ssh root@127.0.0.1 -p 1313
password: falco
```

In fargate just use the following container image.

```
registry.hub.docker.com/krisnova/falco-trace-ssh:latest
```

## Vulnerable Server Application

You can run the [vulnerable server image](https://github.com/kris-nova/falco-trace/tree/master/example-apps/VulnerableServer) to run a vulnerable web server that can give you a remote shell and simulate a hacker. 

```
docker run -p 443:443 krisnova/falco-trace-vulnerableserver:latest 
```

In another shell you can "hack" into the server using the following command

```
ncat -nv 127.0.0.1 443
```

In fargate just use the following container image, and use the public IP

```
registry.hub.docker.com/krisnova/falco-trace-vulnerableserver:latest
```


## Building the container image

```
docker build -t yourorg/falco-trace:latest .
docker push yourorg/falco-trace:latest
```


## Example Application


There is a `example-apps/SkeletonApplication` example that has more documentation and you can clone
that directory to get started with Falco and `pdig`

```
FROM krisnova/falco-trace:latest
CMD ["pdig", "-a", "./init.sh"]
```

---

## AWS ECS/Fargate

This has been tested and is working in AWS Fargate. Set up a Fargate cluster, this part was easy and [the docs](https://docs.aws.amazon.com/AmazonECS/latest/userguide/ECS_AWSCLI_Fargate.html#ECS_AWSCLI_Fargate_create_cluster) were helpful for me.

Below is a tutorial on running the `falco-trace-vulnerableserver` image in AWS ECS/Fargate and exploiting the image to have Falco alert you in CloudWatch.

#### Create a Task Definition

I used what I thought were sane defaults and if given a choice I always went as small as possible on resources.

#### Create Container

You need to create a container associated with your task. This is like how a Kubernetes `Pod` relates to a `Deployment`.

Here we define the workload at the container level.

Container name: `falco-trace-vulnerableserver`

Image:          `registry.hub.docker.com/krisnova/falco-trace-vulnerableserver:latest`

Port Mappings:  `443 tcp`

Command:        ` ` # You can override the falco-trace containers if needed, but for this example leave this blank

Logs: 		`check Auto-configure CloudWatch logs if you want Falco logs plumed to CloudWatch` # Note: You can setup splunk or other logging backends if you want.

Leave everything else blank and save and exit back to the Task Definition screen

#### Configure JSON

Note: This is required for Falco to work! 

Scroll down and find the button below `Volumes` labelled `Configure via JSON`

Paste the following `linuxParameters` block into your JSON

```json
            "linuxParameters": {
                "capabilities": {
                    "add": [
                        "SYS_PTRACE"
                    ],
                    "drop": null
                },
```

The full output of mine looks like this

<details>
{
    "ipcMode": null,
    "executionRoleArn": "arn:aws:iam::059797578166:role/ecsTaskExecutionRole",
    "containerDefinitions": [
        {
            "dnsSearchDomains": null,
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/nova-hacks",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "entryPoint": null,
            "portMappings": [
                {
                    "hostPort": 443,
                    "protocol": "tcp",
                    "containerPort": 443
                }
            ],
            "command": null,
            "linuxParameters": {
                "capabilities": {
                    "add": [
                        "SYS_PTRACE"
                    ],
                    "drop": null
                },
                "sharedMemorySize": null,
                "tmpfs": null,
                "devices": null,
                "maxSwap": null,
                "swappiness": null,
                "initProcessEnabled": null
            },
            "cpu": 0,
            "environment": null,
            "resourceRequirements": null,
            "ulimits": null,
            "dnsServers": null,
            "mountPoints": null,
            "workingDirectory": null,
            "secrets": null,
            "dockerSecurityOptions": null,
            "memory": null,
            "memoryReservation": null,
            "volumesFrom": null,
            "stopTimeout": null,
            "image": "registry.hub.docker.com/krisnova/falco-trace-vulnerableserver:latest",
            "startTimeout": null,
            "firelensConfiguration": null,
            "dependsOn": null,
            "disableNetworking": null,
            "interactive": null,
            "healthCheck": null,
            "essential": true,
            "links": null,
            "hostname": null,
            "extraHosts": null,
            "pseudoTerminal": null,
            "user": null,
            "readonlyRootFilesystem": null,
            "dockerLabels": null,
            "systemControls": null,
            "privileged": null,
            "name": "falco-trace-vulnerableserver",
            "repositoryCredentials": {
                "credentialsParameter": ""
            }
        }
    ],
    "memory": "4096",
    "taskRoleArn": "arn:aws:iam::059797578166:role/ecsTaskExecutionRole",
    "family": "falco-trace-vulnerablewebserver",
    "pidMode": null,
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "networkMode": "awsvpc",
    "cpu": "1024",
    "inferenceAccelerators": [],
    "proxyConfiguration": null,
    "volumes": [],
    "tags": []
}
</details>

click create.

#### Create Service

Click the `Actions` drop-down and `Create Service`.

Note: This is important to get right or Falco will not work!

First select your cluster (third field) otherwise the UI will reset if you try to do this later. 

Launch Type:     `Fargate`

Platform:        `1.4.0` or greater

Service Name:    `falco-trace-vulnerableserver`

Number of tasks: `1`

Leave everything else alone and click `Next Step`

SCROLL UP! You have to scroll up to the top of the page now.

Cluster VPC:    `Just pick one you would like to use`

Subnets:        `Whatever you want, we will be poking a hole in the Security Group later`

Security Group: `Please practice good administrative discipline here. Open TCP 443 on CIDR X.X.X.X/32 for your public IP. curl ifconfig.me`

LoadBalancer:   `None`

Leave everything else blank and click `Next Step`

I do not use autoscaling. `Next step`

`Create Service`


#### Hacking into Fargate

Now you can simulate a hack by connecting to your known vulnerable web server.

Click on your running task to find it's public IP address.

You can now "hack" into your application using the following command

```
ncat -nv <PUBLIC_IP> <443>
```

You should now have a remote shell in ECS and from here you can get up to plenty of mischief.

Here are some handy commands that will trigger Falco alerts and warnings you can issue to make sure everything is working.

```
# Touching files in known executable directories
touch /usr/bin/1
touch /usr/bin/2
touch /usr/bin/3

# Execute a READ on /etc/shadow
cat /etc/shadow > /dev/null 2>&1

# Creating files in /etc/
touch /etc/1
touch /etc/2
touch /etc/3
```

Feel free to play around and see what Falco has to say about it.

#### Falco logs in Cloud Watch

On the same page where you found the public IP of your task, you can view the logs.

If you have logging enabled (like CloudWatch) you can continue to explore more there.

