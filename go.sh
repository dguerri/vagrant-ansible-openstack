#!/bin/bash

set -e

# Parallel spawning of virtual machines won't work for Parallels
# See https://github.com/Parallels/vagrant-parallels/issues/148
vagrant up --no-provision --no-parallel
vagrant provision controller

