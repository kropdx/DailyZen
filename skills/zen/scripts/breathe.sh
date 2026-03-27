#!/usr/bin/env bash
# Zen 4x4 Breathing Exercise — simple countdown, no ANSI tricks.
# Works in Claude Code's Bash tool (buffered stdout, no cursor movement).

ROUNDS=4
SECONDS_PER_PHASE=4

countdown() {
  local label="$1"
  printf "  %-8s " "$label"
  for ((i = SECONDS_PER_PHASE; i >= 1; i--)); do
    printf "%d " "$i"
    sleep 1
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
  countdown "INHALE"
  countdown "HOLD"
  countdown "EXHALE"
  countdown "HOLD"
  echo ""
done

echo "  ✦ complete · you are here now"
echo ""
