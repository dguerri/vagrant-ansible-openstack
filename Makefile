TOP := $(dir $(lastword $(MAKEFILE_LIST)))

all: up provision

up:
	@vagrant up --no-provision

provision:
	@vagrant provision controller

demo:
	@ansible-playbook -i demo/inventory demo/playbook.yml

destroy:
	@vagrant destroy -f

rebuild: destroy all

.PHONY: all up provision demo
