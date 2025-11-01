# To use: source mtn.sh in your shell, then run: mtn

mtn() {
  mkdir -p ~/.mtn

  podman run --rm -it \
    --pull always \
    --privileged \
    -v ~/.mtn:/home/mtn-admin \
    --tmpfs /run --tmpfs /tmp \
    --userns=keep-id:uid=$(id -u),gid=$(id -g) \
    ghcr.io/mtnstar/mtn-shell:latest bash
}
