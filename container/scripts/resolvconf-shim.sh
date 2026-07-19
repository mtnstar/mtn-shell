#!/usr/bin/env bash
# Minimal `resolvconf` replacement for this container.
#
# wg-quick uses `resolvconf` to apply the `DNS =` line from a WireGuard config.
# The usual implementations (openresolv / systemd-resolved) replace
# /etc/resolv.conf with rename(2), which fails here because podman bind-mounts
# /etc/resolv.conf (rename onto a mount point returns EBUSY). That failure makes
# `wg-quick up` roll the whole tunnel back, so the VPN never comes up.
#
# This shim instead writes /etc/resolv.conf *in place* (truncate + write, which
# works on a bind mount), backing up the original so `wg-quick down` restores it.
# It only ever runs when a WireGuard config sets DNS.
#
# wg-quick calls it as:
#   ... | resolvconf -a <iface> -m 0 -x   (stdin: nameserver/search lines)
#         resolvconf -d <iface> -f
set -u

resolv="/etc/resolv.conf"
backup="/run/resolvconf-wg.orig"

action=""
while [ $# -gt 0 ]; do
  case "$1" in
  -a)
    action="add"
    shift
    [ $# -gt 0 ] && shift # drop <iface>
    ;;
  -d)
    action="del"
    shift
    [ $# -gt 0 ] && shift # drop <iface>
    ;;
  *)
    shift # ignore -m/-x/-f and their values
    ;;
  esac
done

case "$action" in
add)
  [ -f "$backup" ] || cp -f "$resolv" "$backup" 2>/dev/null || true
  cat >"$resolv" 2>/dev/null || true # stdin: nameserver / search lines
  ;;
del)
  if [ -f "$backup" ]; then
    cat "$backup" >"$resolv" 2>/dev/null || true
    rm -f "$backup"
  fi
  ;;
*)
  cat >/dev/null 2>&1 || true # drain any stdin
  ;;
esac

exit 0
