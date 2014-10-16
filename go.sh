#!/bin/bash

set -e

export BOX_NAME=${BOX_NAME:-trusty64}   

# Parallel spawning of virtual machines won't work for Parallels
# See https://github.com/Parallels/vagrant-parallels/issues/148
vagrant up --no-provision --no-parallel
vagrant provision controller
