BOX_NAME?=trusty64
export BOX_NAME

all: up provision

# Parallel spawning of virtual machines won't work for Parallels
# See https://github.com/Parallels/vagrant-parallels/issues/148
up:
	@vagrant up --no-provision

provision:
	@vagrant provision

.PHONY: all up provision
