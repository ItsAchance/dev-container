# dev-container

Immutable dev environment for distrobox. Same image, same tools, any Linux PC.

## Prerequisites

- `podman`
- `distrobox`
- Existing dotfiles in `~/dotfiles` (stow-managed) hosts `$HOME` is
  mounted into the container, so your existing symlinks just work.

## First-time setup on a machine

```bash
podman login ghcr.io        # once per machine (use a PAT with read:packages)
make create                 # pulls image, creates distrobox "devcon"
make enter
```

## Bumping the image

Edit `Containerfile`, bump `TAG` in `Makefile` and `image=` in
`distrobox.ini`, then:

```bash
make build push   # or: push to main and let GH Actions build it
make rebuild      # tear down + recreate locally
```

## Pinning to a digest (strictest immutability)

After pushing, grab the pullable digest reference with:

```bash
make digest
# ghcr.io/itsachance/dev-container@sha256:4f8e...bc21
```

Paste that full string into `distrobox.ini` as the `image=` value:

```ini
image=ghcr.io/itsachance/dev-container@sha256:4f8e...bc21
```

Every PC then pulls byte-for-byte the same image. If `make digest`
says "push first", run `make push` and try again.

## Targets

| target     | what it does                                     |
| ---------- | ------------------------------------------------ |
| `build`    | build image locally                              |
| `push`     | push to GHCR                                     |
| `login`    | `podman login ghcr.io`                           |
| `create`   | `distrobox assemble create --file distrobox.ini` |
| `delete`   | `distrobox rm -f devcon`                         |
| `rebuild`  | delete + create                                  |
| `enter`    | `distrobox enter devcon`                         |
| `digest`   | print pinnable `image@sha256:…` reference        |
