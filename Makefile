
all: up provision

up:
	@vagrant up --no-provision

provision:
	@vagrant provision controller

.PHONY: all up provision
