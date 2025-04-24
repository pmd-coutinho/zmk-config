# FROM docker.io/library/archlinux:latest
FROM docker.io/nixos/nix:latest
RUN nix-channel --update

# Enable needed features
RUN mkdir -p ~/.config/nix/
RUN echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

# Install direnv (and optionally but recommended nix-direnv4)
RUN nix profile install nixpkgs#direnv nixpkgs#nix-direnv

# Install just
RUN nix profile install nixpkgs#just

# Install fish?
RUN nix profile install nixpkgs#fish nixpkgs#util-linux

# Install the shell-hook
RUN echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
RUN mkdir -p ~/.config/fish
RUN echo 'direnv hook fish | source' >> ~/.config/fish/config.fish

# Enable nix-direnv (if installed in the previous step)
RUN mkdir -p ~/.config/direnv
RUN echo 'source $HOME/.nix-profile/share/nix-direnv/direnvrc' >> ~/.config/direnv/direnvrc

# Optional: make direnv less verbose
RUN printf '[global]\nwarn_timeout = "2m"\nhide_env_diff = true' >> ~/.config/direnv/direnv.toml

# Source the bashrc to activate the hook (or start a new shell)
RUN source ~/.bashrc

RUN mkdir /root/zmk-workspace
# The first time you enter the workspace, you will be prompted to allow direnv
WORKDIR /root/zmk-workspace

ENV TERM=xterm-256color
CMD fish
# CMD bash

# Allow direnv for the workspace, which will set up the environment (this takes a while)
# direnv allow

# Initialize the Zephyr workspace and pull in the ZMK dependencies
# (same as `west init -l config && west update && west zephyr-export`)
# just init
# just build all
