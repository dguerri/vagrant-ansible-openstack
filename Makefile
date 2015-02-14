BOX_NAME?=trusty64
export BOX_NAME

all: up provision

up:
	@vagrant up --no-provision

provision:
	@vagrant provision controller

.PHONY: all up provision
