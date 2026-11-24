#!/usr/bin/env bash

set -euo pipefail

directory=$PWD
session_base=$(basename -- "$directory")
session_base=${session_base//:/-}

session_number=1
while :; do
  session="$session_base-$session_number"

  if tmux new-session -d -s "$session" -c "$directory" -n shell 2>/dev/null; then
    break
  fi

  if ! tmux has-session -t "=$session" 2>/dev/null; then
    echo "tdev: failed to create tmux session '$session'" >&2
    exit 1
  fi

  ((session_number += 1))
done
readme=$(find "$directory" -maxdepth 1 -type f -iname 'readme*' -print -quit)

if [[ -n $readme ]]; then
  tmux new-window -d -t "$session:" -c "$directory" -n workspace nvim "$readme"
else
  tmux new-window -d -t "$session:" -c "$directory" -n workspace nvim .
fi
tmux new-window -d -t "$session:" -c "$directory" -n lazygit lazygit

if [[ -n ${TMUX:-} ]]; then
  tmux switch-client -t "$session"
else
  tmux attach-session -t "$session"
fi
