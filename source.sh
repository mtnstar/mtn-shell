# To use: source mtn.sh in your shell, then run: mtn

mtn() {
  mkdir -p ~/.mtn
  systemctl --user start podman.socket

  podman run --rm -it \
    --pull always \
    -v /var/run/user/$(id -u)/podman/podman.sock:/var/run/user/1000/podman/podman.sock \
    -v ~/.mtn:/home/mtn-admin \
    --tmpfs /tmp \
    --userns=keep-id:uid=$(id -u),gid=$(id -g) \
    ghcr.io/mtnstar/mtn-shell:latest bash
}
