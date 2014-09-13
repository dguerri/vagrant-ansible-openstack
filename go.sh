#!/bin/bash

set -e 

vagrant up --no-provision
vagrant provision controller

