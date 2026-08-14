# mtn-shell

shell in a container with tools for managing our infrastructure:

- ansible
- molecule (ansible testing)
- prettier, yamllint, ...
- kubectl, helm

## Requirements

- podman

## Setup

### Install

Clone the repository and source `source.sh` from the local checkout:

```
git clone https://github.com/mtnsoft/mtn-shell.git ~/git/mtn/mtn-shell
source ~/git/mtn/mtn-shell/source.sh
```

Add the `source` line to your `.bashrc` to have the `mtn` command available in every shell.

Do **not** source the script straight from GitHub (`source <(curl ...)`): that runs whatever
is served at that moment without any chance to review it. A checkout can be inspected,
diffed and updated deliberately.

Update the checkout later with `mtn --update` (runs `git pull --ff-only` and re-sources the script).

- copy things like required ssh keys, configs and other stuff you want to use in the container to `~/.mtn`

### Bitwarden Cli

create ~./mtn-env with the following content:
```
BW_SSH_KEY_ID="vaultwarden-id-to-your-ssh-key"
BW_ANSIBLE_VAULT_PASSWORD_ID='vaultwarden-id-to-your-ansible-password'
```

```
bw config server https://my-vaultwarden-server.example.com
bw login
```

## Usage

`mtn` starts the container shell (see [Install](#install) for how to get the command).

| Command        | Description                                            |
| -------------- | ------------------------------------------------------ |
| `mtn`          | start the shell                                        |
| `mtn --pull`   | pull the latest container image before starting        |
| `mtn --update` | update the mtn-shell checkout and re-source the script |

Everything after `--` is passed to `podman run`.

unlock bitwarden cli with `. unlock` after entering shell by `mtn`

## Tools

### Helper Commands

**go**: does `ssh` and `sudo su -` in one single command, usage: `go my-server`
