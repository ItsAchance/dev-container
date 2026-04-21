IMAGE ?= ghcr.io/itsachance/dev-container
TAG   ?= v0
NAME  ?= devcon

MAKEFLAGS += --no-print-directory

.PHONY: build push create delete rebuild enter login digest

build:
	podman build --pull -t $(IMAGE):$(TAG) -t $(IMAGE):latest .

push:
	podman push $(IMAGE):$(TAG)
	podman push $(IMAGE):latest

login:
	podman login ghcr.io

create:
	distrobox assemble create --file distrobox.ini

delete:
	distrobox rm -f $(NAME)

rebuild: delete create

enter:
	@distrobox enter $(NAME)

digest:
	@podman image inspect --format '{{if .RepoDigests}}{{index .RepoDigests 0}}{{else}}no digest — push first with `make push`{{end}}' $(IMAGE):$(TAG)
