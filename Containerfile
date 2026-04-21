FROM quay.io/archlinux/archlinux:base-devel

LABEL org.opencontainers.image.title="dev-container"
LABEL org.opencontainers.image.description="Dev environment for use with distrobox"
LABEL org.opencontainers.image.source="https://github.com/itsachance/dev-container"
LABEL org.opencontainers.image.licenses="MIT"

# One RUN to minimize layers. Packages split into groups for readability:
#   - distrobox integration + auth: sudo, util-linux, procps-ng, less, which,
#     man-db, bash-completion, pinentry, gnupg, pass, pass-otp, openssh
#     (distrobox would install missing ones on first enter; pre-baking keeps
#     the runtime immutable and startup fast)
#   - editor + shell: neovim, tmux, starship, stow, fzf, ripgrep
#   - general tooling: git, curl, wget, rsync, rclone, jq, go-yq, ncdu, nmap
#   - language toolchains: go, gopls, npm
#   - ops: k9s, kubectl, opentofu
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
        sudo util-linux procps-ng less which man-db bash-completion \
        pinentry gnupg pass pass-otp openssh \
        neovim tmux starship stow fzf ripgrep \
        git curl wget rsync rclone jq go-yq ncdu nmap \
        go gopls npm \
        k9s kubectl opentofu && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

# Installs jsonnet from source
ARG JSONNET_VERSION="0.20.0"
RUN curl -fsSL "https://github.com/google/go-jsonnet/releases/download/v${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz" | \
    tar xz -C /usr/local/bin/ jsonnet jsonnetfmt

# No USER directive — distrobox creates a user at enter time matching the
# host UID/GID. Creating one here would conflict.
#
# No dotfile logic — host $HOME is bind-mounted by distrobox, so existing
# stow symlinks (~/.bashrc, ~/.tmux.conf, etc.) resolve naturally.
