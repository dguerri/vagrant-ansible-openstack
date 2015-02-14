TOP := $(dir $(lastword $(MAKEFILE_LIST)))

all: up provision

up:
	@vagrant up --no-provision

provision:
	@vagrant provision controller

demo:
	@for script in $(TOP)/scripts/?-*.sh ; do $$script; done

destroy:
	@vagrant destroy -f

rebuild: destroy all

.PHONY: all up provision demo
