#!/usr/bin/env bash
# Zen 4x4 Breathing Exercise — simple countup, no ANSI tricks.
# Works in Claude Code's Bash tool (buffered stdout, no cursor movement).

ROUNDS=4
SECONDS_PER_PHASE=4

countup() {
  local label="$1"
  printf "  %-8s " "$label"
  for ((i = 1; i <= SECONDS_PER_PHASE; i++)); do
    sleep 1
    printf "%d " "$i"
  done
  echo ""
}

echo ""
echo "  ┌──────────────────────────────┐"
echo "  │  z e n  ·  box breathing 4×4 │"
echo "  └──────────────────────────────┘"
echo ""

for ((r = 1; r <= ROUNDS; r++)); do
  echo "  · round $r of $ROUNDS ·"
  countup "INHALE"
  countup "HOLD"
  countup "EXHALE"
  countup "HOLD"
  echo ""
done

echo "  ✦ complete · you are here now"
echo ""
