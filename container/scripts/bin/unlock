#!/bin/bash

source ~/.mtn-env

bw get item "$BW_SSH_KEY_ID" | jq -r '.sshKey.privateKey' | ssh-add -t 3600 -
