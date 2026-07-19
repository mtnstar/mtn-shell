# mtn-shell

shell in a container with tools for managing our infrastructure:

- ansible
- molecule (ansible testing)
- prettier, yamllint, ...
- kubectl, helm

## Requirements

- podman

## Setup

- copy things like required ssh keys, configs and other stuff you want to use in the container to `~/.mtn`

### WireGuard VPN

The container ships with WireGuard (`wg` / `wg-quick`, userspace backend via
`wireguard-go`, so no host kernel module is required). If a config exists at
`~/.vpn/infra.conf` it is brought up automatically on shell start:

- put the config on the host at `~/.mtn/.vpn/infra.conf` (mounted to
  `~/.vpn/infra.conf` in the container)
- it connects on the first shell; further shells are a no-op while it is up
- manage it manually with `sudo wg-quick up ~/.vpn/infra.conf` /
  `sudo wg-quick down ~/.vpn/infra.conf`

Because a rootless container cannot configure the host's network namespace, the
container runs in its own network namespace (`slirp4netns`) rather than with
host networking — this is what makes WireGuard possible. Host services are
reachable at `10.0.2.2` instead of `localhost`. The host must expose
`/dev/net/tun` (present on any host with the `tun` module loaded).

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

`source <(curl -s https://raw.githubusercontent.com/mtnsoft/mtn-shell/refs/heads/main/source.sh)`

provides the `mtn` command. You might want to add it to your `.bashrc`.

unlock bitwarden cli with `. unlock` after entering shell by `mtn`

## Tools

### Helper Commands

**go**: does `ssh` and `sudo su -` in one single command, usage: `go my-server`
