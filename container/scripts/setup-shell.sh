#!/usr/bin/env bash
set -euo pipefail

# Append PS1 and helper to global bashrc in a way safe for Docker build layering

# Helper to print current git branch if in a git repository
cat >> /etc/bash.bashrc <<'BASH'
__mtn_git_branch() {
  # Only attempt if git is available
  command -v git >/dev/null 2>&1 || return
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    printf " \[\e[0;35m\](%s)\[\e[0m\]" "$branch"
  fi
}
BASH

# PS1: M and N yellow, T blue; git branch on separate line above user@host:path
cat >> /etc/bash.bashrc <<'BASH'
export PS1='\[\e[0;33m\]M\[\e[0;34m\]T\[\e[0;33m\]N\[\e[0m\]\n$(__mtn_git_branch) \[\e[0;36m\]\u:\[\e[0;33m\]\w\[\e[0m\]\$ '
BASH

echo "alias docker='sudo docker'" >> /etc/bash.bashrc
