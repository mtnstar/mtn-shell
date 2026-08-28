if [ -n "${BASH_SOURCE[0]:-}" ]; then
  MTN_SHELL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

mtn() {
  local pull_flag=""
  local update_flag=""
  local podman_args=()

  while [ $# -gt 0 ]; do
    case "$1" in
    --pull | --pull=*)
      pull_flag="--pull=always"
      shift
      ;;
    --update)
      update_flag="1"
      shift
      ;;
    --)
      shift
      while [ $# -gt 0 ]; do
        podman_args+=("$1")
        shift
      done
      break
      ;;
    *)
      podman_args+=("$1")
      shift
      ;;
    esac
  done

  if [ -n "$update_flag" ]; then
    if [ -d "${MTN_SHELL_DIR:-}/.git" ]; then
      git -C "$MTN_SHELL_DIR" pull --ff-only || return 1
      # shellcheck source=/dev/null
      . "$MTN_SHELL_DIR/source.sh"
      echo "mtn-shell updated, run 'mtn' to start the container"
      return 0
    fi
    echo "mtn: cannot update, '${MTN_SHELL_DIR:-unknown}' is not a git checkout" >&2
    return 1
  fi

  mkdir -p ~/.mtn
  systemctl --user start podman.socket

  podman run --rm -it ${pull_flag} \
    -v /var/run/user/$(id -u)/podman/podman.sock:/var/run/user/1000/podman/podman.sock \
    -v ~/.mtn:/home/mtn-admin \
    -v /dev/bus/usb:/dev/bus/usb \
    -v ~/.config/nvim:/home/mtn-admin/.config/nvim \
    -v ~/git:/home/mtn-admin/git \
    --cap-add=NET_RAW \
    --network=host \
    --tmpfs /tmp \
    --userns=keep-id:uid=$(id -u),gid=$(id -g) \
    ghcr.io/mtnsoft/mtn-shell:latest bash --login
}
