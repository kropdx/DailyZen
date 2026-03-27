#!/usr/bin/env bash
# Zen 4x4 Breathing Exercise
# Writes directly to /dev/tty so cursor animation renders in the real terminal.

exec > /dev/tty 2>&1

CYAN='\033[0;36m'
BLUE='\033[0;34m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
MAGENTA='\033[0;35m'

TOTAL_ROUNDS=4
PHASE_SECONDS=4
FRAME_HEIGHT=9   # lines per frame
TOTAL_FRAMES=6   # 0..5

# Hide cursor; restore on exit
printf '\033[?25l'
trap 'printf "\033[?25h"' EXIT

# ─── Pre-designed circle frames ──────────────────────────────────────────────
# Each frame is FRAME_HEIGHT lines.
# Canvas: 37 chars wide, center col 18 (0-indexed).
# Chars are ~2× taller than wide, so visual circles need to be ~2× wider than tall.
# Radius in visual units r → row-span ≈ r/2, col-span ≈ r.

# Frame index → array of lines (stored flat: frame f, line l → IDX = f*9 + l)
declare -a F

# F0: just a dot
F[0]="                                     "
F[1]="                                     "
F[2]="                                     "
F[3]="                                     "
F[4]="                  ●                  "
F[5]="                                     "
F[6]="                                     "
F[7]="                                     "
F[8]="                                     "

# F1: tiny ring (r≈2)
F[9]="                                     "
F[10]="                                     "
F[11]="                                     "
F[12]="               · ○ ·                 "
F[13]="              ○  ●  ○                "
F[14]="               · ○ ·                 "
F[15]="                                     "
F[16]="                                     "
F[17]="                                     "

# F2: small ring (r≈4)
F[18]="                                     "
F[19]="                                     "
F[20]="             ·  ○○○  ·               "
F[21]="            ○         ○              "
F[22]="           ·○    ●    ○·             "
F[23]="            ○         ○              "
F[24]="             ·  ○○○  ·               "
F[25]="                                     "
F[26]="                                     "

# F3: medium ring (r≈6)
F[27]="                                     "
F[28]="           ·  ○○○○○  ·               "
F[29]="          ○           ○              "
F[30]="         ○      ●      ○             "
F[31]="         ○             ○             "
F[32]="          ○           ○              "
F[33]="           ·  ○○○○○  ·               "
F[34]="                                     "
F[35]="                                     "

# F4: large ring (r≈8)
F[36]="         ·  ○○○○○○○  ·               "
F[37]="        ○               ○            "
F[38]="       ○                 ○           "
F[39]="       ○        ●        ○           "
F[40]="       ○                 ○           "
F[41]="        ○               ○            "
F[42]="         ·  ○○○○○○○  ·               "
F[43]="                                     "
F[44]="                                     "

# F5: full ring (r≈10)
F[45]="       ·  ○○○○○○○○○○  ·              "
F[46]="      ○                  ○           "
F[47]="     ○                    ○          "
F[48]="     ○         ●          ○          "
F[49]="     ○                    ○          "
F[50]="      ○                  ○           "
F[51]="       ·  ○○○○○○○○○○  ·              "
F[52]="                                     "
F[53]="                                     "

# ─── Draw helpers ─────────────────────────────────────────────────────────────

draw_frame() {
  local frame=$1
  local color=$2
  local base=$(( frame * FRAME_HEIGHT ))
  for ((l = 0; l < FRAME_HEIGHT; l++)); do
    printf "  ${color}%s${RESET}\n" "${F[$((base + l))]}"
  done
}

erase_frame() {
  # Move cursor up FRAME_HEIGHT lines and clear each
  printf "\033[%dA" "$FRAME_HEIGHT"
  for ((l = 0; l < FRAME_HEIGHT; l++)); do
    printf '\r\033[K\n'
  done
  printf "\033[%dA" "$FRAME_HEIGHT"
}

draw_bar() {
  local label="$1"
  local color="$2"
  local pct="$3"
  local width=28
  local filled=$(( pct * width / 100 ))
  local bar=""
  for ((i = 0; i < filled; i++));        do bar="${bar}▓"; done
  for ((i = filled; i < width; i++));    do bar="${bar}░"; done
  printf "\r\033[K  ${color}${BOLD}%-7s${RESET}  ${DIM}▕${RESET}${color}%s${RESET}${DIM}▏${RESET}\n" "$label" "$bar"
}

# ─── Phase animation ──────────────────────────────────────────────────────────

animate_phase() {
  local label="$1"
  local color="$2"
  local reverse="$3"   # 1 = shrink (exhale/hold-after-exhale)

  local total_steps=$(( PHASE_SECONDS * 12 ))  # 12 fps
  local sleep_ms="0.083"

  local prev_frame=-1

  for ((step = 0; step <= total_steps; step++)); do
    local pct=$(( step * 100 / total_steps ))

    # Map pct → frame index
    local frame_idx
    if [[ "$reverse" == "1" ]]; then
      frame_idx=$(( TOTAL_FRAMES - 1 - (pct * (TOTAL_FRAMES - 1) / 100) ))
    else
      frame_idx=$(( pct * (TOTAL_FRAMES - 1) / 100 ))
    fi

    # Only redraw if frame changed
    if [[ $frame_idx != $prev_frame ]]; then
      if [[ $step -gt 0 ]]; then
        erase_frame
      fi
      draw_frame "$frame_idx" "$color"
      prev_frame=$frame_idx
    else
      # Just move up past frame, update bar, move back down
      printf "\033[%dA" "$FRAME_HEIGHT"
      printf "\033[%dB" "$FRAME_HEIGHT"
    fi

    # Update bar (always overwrite)
    printf "\r\033[1A"         # go up 1 (bar line)
    draw_bar "$label" "$color" "$pct"

    sleep "$sleep_ms"
  done
}

hold_phase() {
  local label="$1"
  local color="$2"
  local frame="$3"   # which frame to hold (0 or TOTAL_FRAMES-1)

  draw_frame "$frame" "$color"

  local total_steps=$(( PHASE_SECONDS * 12 ))
  local sleep_ms="0.083"

  for ((step = 0; step <= total_steps; step++)); do
    local pct=$(( step * 100 / total_steps ))
    printf "\r\033[1A"
    draw_bar "$label" "$color" "$pct"
    sleep "$sleep_ms"
  done

  erase_frame
}

# ─── Main ─────────────────────────────────────────────────────────────────────

clear
printf "\n"
printf "  ${DIM}┌────────────────────────────────┐${RESET}\n"
printf "  ${DIM}│${RESET}  ${BOLD}${CYAN}z e n${RESET}  ${DIM}·  box breathing  4×4  │${RESET}\n"
printf "  ${DIM}└────────────────────────────────┘${RESET}\n"
printf "\n"
sleep 0.8

for ((round = 1; round <= TOTAL_ROUNDS; round++)); do
  printf "  ${DIM}· round %d of %d ·${RESET}\n\n" "$round" "$TOTAL_ROUNDS"

  # Blank bar line (animate_phase will overwrite)
  printf "\n"

  animate_phase "INHALE"  "$CYAN"    "0"
  erase_frame
  hold_phase    "HOLD"    "$GREEN"   "$((TOTAL_FRAMES - 1))"
  printf "\n"
  animate_phase "EXHALE"  "$MAGENTA" "1"
  erase_frame
  hold_phase    "HOLD"    "$YELLOW"  "0"
  printf "\n"

  # Clear round label + blank + bar line
  printf "\033[4A"
  for ((i=0; i<4; i++)); do printf '\r\033[K\n'; done
  printf "\033[4A"
done

printf "\n  ${GREEN}${BOLD}✦  complete${RESET}  ${DIM}·  you are here now${RESET}\n\n"
