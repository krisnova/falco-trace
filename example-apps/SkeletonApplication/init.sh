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


# ----------------------------------------------------------------------------------------------------------------------
# The Falco Logic goes here.
#
# There are a number of ways to start Falco, but in order to get the logs to STDOUT we tail the file but return back
# to stack so we can iterate forward with the script.
# ----------------------------------------------------------------------------------------------------------------------
falco -u --pidfile /var/run/falco.pid --daemon
tail -f /var/log/falco.log &



# ----------------------------------------------------------------------------------------------------------------------
# You application wrapper goes here. Any bash started from within this file will be ran with the Falco ptrace(2)
# implementation. 
#
# The runtime overhead of this is measureable, and significant in some cases. However  this is flexible and easy to
# adopt.
#
# Feel free to start a program, execute a script, load files, download files, however you normally run your application.
# ----------------------------------------------------------------------------------------------------------------------
echo "Running app..."
while :
do
    sleep 1
done
