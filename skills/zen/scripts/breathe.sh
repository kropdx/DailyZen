#!/usr/bin/env bash
# Zen 4x4 breathing — minimal output for Claude Code's narrow Bash panel.

ROUNDS=4
SECS=4

phase() {
  local label="$1"
  printf "%-7s " "$label"
  for ((i = 1; i <= SECS; i++)); do
    sleep 1
    printf "%d " "$i"
  done
  echo ""
}

echo ""
echo "zen · 4x4 breathing"
echo ""

for ((r = 1; r <= ROUNDS; r++)); do
  echo "ROUND $r/$ROUNDS"
  phase "INHALE"
  phase "HOLD"
  phase "EXHALE"
  phase "HOLD"
  echo ""
done

echo "done."
echo ""
