#!/bin/bash
#
# Copyright (C) 2019 The Falco Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#
# There is a small server that can be used for
# demos to "hack" into the running instance.
#
# Set the port and uncomment this if you want
# to use the server.
#
# You can connect with nc -nv <ip> <port>
# and run commands like ls, cat, rm but in
# a synthetic remote shell.
#


# ----------------------------------------------------------------------------------------------------------------------
# The Falco Logic goes here.
#
# There are a number of ways to start Falco, but in order to get the logs to STDOUT we tail the file but return back
# to stack so we can iterate forward with the script.
# ----------------------------------------------------------------------------------------------------------------------
falco -u --pidfile /var/run/falco.pid --daemon
tail -f /var/log/falco.log &



# #The port that we can "hack" into our server with
#
# Use nc -nv <ip> <port> to access a remote shell
#
PORT=${PORT:-443}


#
# [ WARNING ]
# DO NOT RUN THIS IN PRODUCTION
# [ WARNING ]
#
while :
do
   ncat -nvlp ${PORT} -e /bin/bash
   if [ $? -ne 0 ]; then
      printf "Error with ncat. Sleeping...\n"
      sleep 3
   fi
done
