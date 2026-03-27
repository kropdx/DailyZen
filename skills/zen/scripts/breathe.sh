#!/usr/bin/env bash
# Zen 4x4 Breathing Exercise
#
# When run from Claude Code (no real TTY), this script opens a dedicated
# terminal window for the animation, waits for it to finish, then returns.
# When run with --direct, it renders the animation inline.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/breathe.sh"

# ─── Direct mode: real terminal, render animation ────────────────────────────
if [[ "$1" == "--direct" ]]; then

  CYAN='\033[0;36m'
  DIM='\033[2m'
  BOLD='\033[1m'
  RESET='\033[0m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  MAGENTA='\033[0;35m'

  TOTAL_ROUNDS=4
  PHASE_SECONDS=4
  FPS=12

  printf '\033[?25l'          # hide cursor
  trap 'printf "\033[?25h"' EXIT

  # ── Circle frames (9 lines each) ─────────────────────────────────────────
  declare -a FRAME
  LINES_PER_FRAME=9

  read -r -d '' FRAME_0 << 'ART'




                  ●




ART

  read -r -d '' FRAME_1 << 'ART'



               · ○ ·
              ○  ●  ○
               · ○ ·



ART

  read -r -d '' FRAME_2 << 'ART'


            ·  ○ ○ ○  ·
           ○           ○
           ○     ●     ○
           ○           ○
            ·  ○ ○ ○  ·


ART

  read -r -d '' FRAME_3 << 'ART'

          ·  ○ ○ ○ ○ ○  ·
         ○               ○
        ○                 ○
        ○        ●        ○
        ○                 ○
         ○               ○
          ·  ○ ○ ○ ○ ○  ·

ART

  read -r -d '' FRAME_4 << 'ART'
        ·  ○ ○ ○ ○ ○ ○ ○  ·
       ○                   ○
      ○                     ○
     ○                       ○
     ○           ●           ○
     ○                       ○
      ○                     ○
       ○                   ○
        ·  ○ ○ ○ ○ ○ ○ ○  ·
ART

  read -r -d '' FRAME_5 << 'ART'
     ·  ○ ○ ○ ○ ○ ○ ○ ○ ○  ·
    ○                       ○
   ○                         ○
  ○                           ○
  ○             ●             ○
  ○                           ○
   ○                         ○
    ○                       ○
     ·  ○ ○ ○ ○ ○ ○ ○ ○ ○  ·
ART

  FRAMES=("$FRAME_0" "$FRAME_1" "$FRAME_2" "$FRAME_3" "$FRAME_4" "$FRAME_5")
  NUM_FRAMES=${#FRAMES[@]}

  draw_frame() {
    local idx=$1 color=$2
    local IFS=$'\n'
    local lines
    read -r -d '' -a lines <<< "${FRAMES[$idx]}" || true
    for line in "${lines[@]}"; do
      printf "  ${color}%s${RESET}\n" "$line"
    done
  }

  erase_block() {
    local n=$1
    printf "\033[%dA" "$n"
    for ((i = 0; i < n; i++)); do
      printf '\r\033[K\n'
    done
    printf "\033[%dA" "$n"
  }

  draw_bar() {
    local label=$1 color=$2 pct=$3
    local w=30 filled=$(( pct * 30 / 100 ))
    local bar=""
    for ((i=0; i<filled; i++));  do bar+="▓"; done
    for ((i=filled; i<w; i++)); do bar+="░"; done
    printf "\r\033[K  ${color}${BOLD}%-8s${RESET} ${DIM}▕${RESET}${color}%s${RESET}${DIM}▏${RESET}" "$label" "$bar"
  }

  animate_phase() {
    local label=$1 color=$2 direction=$3   # direction: "grow" or "shrink"
    local total=$(( PHASE_SECONDS * FPS ))
    local delay
    delay=$(awk "BEGIN {printf \"%.4f\", 1.0/$FPS}")
    local prev_fi=-1

    for ((s=0; s<=total; s++)); do
      local pct=$(( s * 100 / total ))
      local fi
      if [[ "$direction" == "shrink" ]]; then
        fi=$(( (NUM_FRAMES-1) - pct*(NUM_FRAMES-1)/100 ))
      else
        fi=$(( pct*(NUM_FRAMES-1)/100 ))
      fi

      if (( fi != prev_fi )); then
        (( prev_fi >= 0 )) && erase_block $((LINES_PER_FRAME + 1))
        draw_frame "$fi" "$color"
        printf "\n"  # bar line placeholder
        prev_fi=$fi
      fi

      # update bar (cursor is after the bar line)
      printf "\033[1A"
      draw_bar "$label" "$color" "$pct"
      printf "\n"
      sleep "$delay"
    done
    erase_block $((LINES_PER_FRAME + 1))
  }

  hold_phase() {
    local label=$1 color=$2 frame_idx=$3
    local total=$(( PHASE_SECONDS * FPS ))
    local delay
    delay=$(awk "BEGIN {printf \"%.4f\", 1.0/$FPS}")

    draw_frame "$frame_idx" "$color"
    printf "\n"

    for ((s=0; s<=total; s++)); do
      local pct=$(( s * 100 / total ))
      printf "\033[1A"
      draw_bar "$label" "$color" "$pct"
      printf "\n"
      sleep "$delay"
    done
    erase_block $((LINES_PER_FRAME + 1))
  }

  # ── Main animation ───────────────────────────────────────────────────────
  clear
  printf "\n"
  printf "  ${DIM}┌──────────────────────────────────┐${RESET}\n"
  printf "  ${DIM}│${RESET}   ${BOLD}${CYAN}z e n${RESET}   ${DIM}·  box breathing 4×4  │${RESET}\n"
  printf "  ${DIM}└──────────────────────────────────┘${RESET}\n"
  printf "\n"
  sleep 0.8

  for ((r=1; r<=TOTAL_ROUNDS; r++)); do
    printf "  ${DIM}· round %d of %d ·${RESET}\n\n" "$r" "$TOTAL_ROUNDS"

    animate_phase "INHALE"  "$CYAN"    "grow"
    hold_phase    "HOLD"    "$GREEN"   "$((NUM_FRAMES-1))"
    animate_phase "EXHALE"  "$MAGENTA" "shrink"
    hold_phase    "HOLD"    "$YELLOW"  "0"

    # clear round header
    printf "\033[2A"
    printf '\r\033[K\n\r\033[K\n'
    printf "\033[2A"
  done

  printf "\n"
  printf "  ${GREEN}${BOLD}✦  complete${RESET}  ${DIM}·  you are here now${RESET}\n"
  printf "\n"
  sleep 3
  exit 0
fi

# ─── Launcher mode: open a real terminal window ──────────────────────────────

DONE_FILE=$(mktemp /tmp/zen-breathe.XXXXX)
rm -f "$DONE_FILE"

# Detect which terminal app to use
launch_in_terminal() {
  if pgrep -qx "iTerm2" 2>/dev/null; then
    osascript <<EOF
tell application "iTerm2"
  activate
  set newWindow to (create window with default profile)
  tell current session of newWindow
    write text "bash '${SCRIPT_PATH}' --direct; touch '${DONE_FILE}'; exit"
  end tell
end tell
EOF
  elif pgrep -qx "WarpTerminal" 2>/dev/null; then
    osascript <<EOF
tell application "Warp"
  activate
  tell application "System Events"
    tell process "Warp"
      keystroke "t" using command down
      delay 0.3
      keystroke "bash '${SCRIPT_PATH}' --direct; touch '${DONE_FILE}'; exit"
      key code 36
    end tell
  end tell
end tell
EOF
  else
    osascript <<EOF
tell application "Terminal"
  activate
  do script "bash '${SCRIPT_PATH}' --direct; touch '${DONE_FILE}'; exit"
end tell
EOF
  fi
}

launch_in_terminal

# Wait for animation to finish
while [ ! -f "$DONE_FILE" ]; do
  sleep 1
done
rm -f "$DONE_FILE"

echo "Breathing exercise complete."
