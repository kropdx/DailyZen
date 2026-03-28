#!/usr/bin/env bash
# Zen 4x4 breathing — one line per second for Claude Code's buffered output.

ROUNDS=4
SECS=4

echo "Mini Zen Retreat"
echo "Guided 4x4 box breathing starting in..."
for ((c = 10; c >= 1; c--)); do
  sleep 1
  echo "$c"
done
echo ""

for ((r = 1; r <= ROUNDS; r++)); do
  echo "ROUND $r/$ROUNDS"
  for phase in INHALE HOLD EXHALE HOLD; do
    for ((i = 1; i <= SECS; i++)); do
      sleep 1
      echo "$phase $i"
    done
  done
  echo ""
done

echo "DONE"
