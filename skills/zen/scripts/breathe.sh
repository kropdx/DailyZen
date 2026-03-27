#!/usr/bin/env bash
# Zen 4x4 Breathing Exercise
# 4 seconds inhale, 4 seconds hold, 4 seconds exhale, 4 seconds hold
# Repeated 4 times = ~64 seconds total

set -e

# Colors
CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
MAGENTA='\033[0;35m'

BAR_WIDTH=24
TOTAL_ROUNDS=4
PHASE_SECONDS=4
STEPS_PER_SECOND=5

clear_line() {
  printf '\r\033[K'
}

draw_bar() {
  local filled=$1
  local total=$2
  local bar=""
  for ((i = 0; i < filled; i++)); do
    bar="${bar}#"
  done
  for ((i = filled; i < total; i++)); do
    bar="${bar}-"
  done
  echo "$bar"
}

animate_phase() {
  local label="$1"
  local color="$2"
  local total_steps=$((PHASE_SECONDS * STEPS_PER_SECOND))
  local sleep_interval
  sleep_interval=$(awk "BEGIN {printf \"%.3f\", 1.0 / $STEPS_PER_SECOND}")

  for ((step = 0; step <= total_steps; step++)); do
    local bar_filled=$(( (step * BAR_WIDTH) / total_steps ))
    local bar
    bar=$(draw_bar "$bar_filled" "$BAR_WIDTH")
    clear_line
    printf "  ${color}${BOLD}%-8s${RESET} ${DIM}[${RESET}${color}%s${RESET}${DIM}]${RESET}" "$label" "$bar"
    sleep "$sleep_interval"
  done
  clear_line
  local full_bar
  full_bar=$(draw_bar "$BAR_WIDTH" "$BAR_WIDTH")
  printf "  ${color}${BOLD}%-8s${RESET} ${DIM}[${RESET}${color}%s${RESET}${DIM}]${RESET}" "$label" "$full_bar"
  echo ""
}

echo ""
echo -e "  ${DIM}Starting 4x4 breathing exercise...${RESET}"
echo -e "  ${DIM}4 rounds x 4 phases x 4 seconds${RESET}"
echo ""
sleep 1

for ((round = 1; round <= TOTAL_ROUNDS; round++)); do
  echo -e "  ${DIM}--- Round ${round}/${TOTAL_ROUNDS} ---${RESET}"
  animate_phase "INHALE"  "$CYAN"
  animate_phase "HOLD"    "$GREEN"
  animate_phase "EXHALE"  "$MAGENTA"
  animate_phase "HOLD"    "$YELLOW"
  echo ""
done

echo -e "  ${GREEN}${BOLD}Breathing complete.${RESET} ${DIM}You are here now.${RESET}"
echo ""
