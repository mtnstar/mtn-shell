# mtn-shell

shell in a container with tools for managing our infrastructure:

- ansible
- molecule (ansible testing)
- prettier, yamllint, ...

## Requirements

- podman

## Setup

- copy things like required ssh keys, configs and other stuff you want to use in the container to `~/.mtn`

## Usage

`source <(curl -s https://raw.githubusercontent.com/mtnstar/mtn-shell/refs/heads/main/source.sh)`

provides the `mtn` command. You might want to add it to your `.bashrc`.
