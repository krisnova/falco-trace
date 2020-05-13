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


# Run Stress test control

STRESS_TEST_TIME_HUMAN="30s"


function stresstest() {
  echo ""
  echo ""
  echo "---------------------------------------------"
  echo " [ $1 ] "
  echo ""
  stress-ng --metrics-brief --cpu 2 -t ${STRESS_TEST_TIME_HUMAN}
}

echo ""
echo ""
echo " *** STARTING BENCHMARKS ***"
stresstest "CONTROL"
sleep 100 &
stresstest "SLEEP"
pkill -f sleep
nginx &
stresstest "NGINX"
pkill -f nginx

echo ""
echo ""
echo " *** STARTING FALCO *** "
echo ""
echo ""
falco -u --pidfile /var/run/falco.pid --daemon
stresstest "FALCO + CONTROL"
pdig -a sleep 100 &
stresstest "FALCO + SLEEP"
pkill -f sleep
pdig -a nginx &
stresstest "FALCO + NGINX"
pkill -f nginx

echo ""
echo ""
echo " *** COMPLETE ***"
echo ""
echo ""