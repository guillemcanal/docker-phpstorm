TAG ?= latest
VENDOR ?= $(shell whoami)
NAME = phpstorm

.PHONY: build

build:
	docker build -t $(VENDOR)/phpstorm:$(TAG) .
