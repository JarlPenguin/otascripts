#!/bin/bash
# Copyright (C) 2019 baalajimaestro
#
# Licensed under the Raphielscape Public License, Version 1.b (the "License");
# you may not use this file except in compliance with the License.
#

echo $GITHUB_TOKEN >/tmp/gh_token

sudo echo "ci ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
useradd -m -d /home/ci ci
useradd -g ci wheel
sudo -Hu ci bash -c "source setup.sh "$1""