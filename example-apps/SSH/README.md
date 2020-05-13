# SSH

```
docker run -p 1313:22 krisnova/falco-test-ssh:latest
```

```
ssh root@127.0.0.1 -p 1313
password: falco
```

Use this to start run a container with SSH backend access.

Note that Falco (by design) is a little noisy about SSH connections in a container


```
[nova@nova SSH]$ docker run -p 1313:22 krisnova/falco-trace-ssh
Wed May 13 02:19:49 2020: Falco initialized with configuration file /etc/falco/falco.yaml
Wed May 13 02:19:49 2020: Loading rules from file /etc/falco/falco_rules.yaml:
Wed May 13 02:19:49 2020: Loading rules from file /etc/falco/falco_rules.local.yaml:
Wed May 13 02:19:49 2020: Loading rules from file /etc/falco/k8s_audit_rules.yaml:
Running ssh server...
02:19:50.053506307: Error File below / or /root opened for writing (user=root command=sshd -D parent=init.sh file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:19:50.057526802: Error File below / or /root opened for writing (user=root command=sshd -D parent=init.sh file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:19:50.058740193: Error File below / or /root opened for writing (user=root command=sshd -D parent=init.sh file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:19:54.573850361: Error File below / or /root opened for writing (user=root command=sshd -D parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:19:54.574377494: Warning Redirect stdout/stdin to network connection (user=root <NA> (id=a9d4cc76b708) process=sshd parent=sshd cmdline=sshd -D terminal=0 container_id=a9d4cc76b708 image=<NA> fd.name=172.17.0.1:60806->172.17.0.8:22 fd.num=0 fd.type=ipv4 fd.sip=172.17.0.8)
02:19:54.585760127: Error File below / or /root opened for writing (user=root command=sshd -D -R parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:19:54.591627525: Warning Redirect stdout/stdin to network connection (user=root <NA> (id=a9d4cc76b708) process=sshd parent=sshd cmdline=sshd -D -R terminal=0 container_id=a9d4cc76b708 image=<NA> fd.name=172.17.0.1:60806->172.17.0.8:22 fd.num=0 fd.type=ipv4 fd.sip=172.17.0.8)
02:19:54.591727591: Error File below / or /root opened for writing (user=root command=sshd -D -R parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:19:54.594877478: Notice Unexpected setuid call by non-sudo, non-root program (user=sshd cur_uid=105 parent=<NA> command=<NA> uid=root container_id=host image=<NA>)
02:20:00.198689047: Error File below / or /root opened for writing (user=root command=sshd -D -R parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:02.309165806: Error File below / or /root opened for writing (user=root command=sshd -D -R parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:02.312884458: Error File below / or /root opened for writing (user=root command=sh -c /usr/bin/env -i PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin run-parts --lsbsysinit /etc/update-motd.d > /run/motd.dynamic.new parent=sshd file=/ program=sh container_id=a9d4cc76b708 image=<NA>)
02:20:02.378599076: Error File below / or /root opened for writing (user=root command=sshd -D -R parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:02.380561920: Error File below / or /root opened for writing (user=root command=sshd     parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:02.380669387: Error File below / or /root opened for writing (user=root command=sshd     parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:02.382007746: Error File below / or /root opened for writing (user=root command=sshd     parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:02.382661836: Error File below / or /root opened for writing (user=root command=sshd     parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:02.385761364: Error File below / or /root opened for writing (user=root command=sshd     parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:02.392162703: Error File below / or /root opened for writing (user=root command=bash parent=sshd file=/ program=bash container_id=a9d4cc76b708 image=<NA>)
02:20:12.575972682: Error File below / or /root opened for writing (user=root command=bash parent=sshd file=/ program=bash container_id=a9d4cc76b708 image=<NA>)
02:20:12.576072431: Error File below / or /root opened for writing (user=root command=bash parent=sshd file=/ program=bash container_id=a9d4cc76b708 image=<NA>)
02:20:12.577675061: Error File below / or /root opened for writing (user=root command=sshd -D -R parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
02:20:12.578084329: Error File below / or /root opened for writing (user=root command=sshd -D -R parent=sshd file=/ program=sshd container_id=a9d4cc76b708 image=<NA>)
```