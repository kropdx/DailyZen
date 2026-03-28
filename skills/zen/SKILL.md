---
name: zen
description: Take a mindfulness break. Displays a random zen quote and guides you through a calming 4x4 breathing exercise right in your terminal. Use when you need to pause, reset, or decompress during a coding session.
disable-model-invocation: true
allowed-tools: Read
effort: high
---

# Zen - A Mindfulness Break

When invoked, do the following in order. Output each section one at a time. Do not output everything at once.

## Step 1: Quote

Read the quotes file at `${CLAUDE_SKILL_DIR}/quotes.json`. Pick one quote at random.

Output only this:

"<quote text>"
— Author Name

## Step 2: Countdown

Output this text exactly, one line at a time, pausing between each:

Mini Zen Retreat
Guided 4x4 box breathing starting in...
10
9
8
7
6
5
4
3
2
1

## Step 3: Breathing Rounds

Repeat the following 4 times (rounds 1 through 4).

Output one line at a time, pausing between each line:

ROUND [n]/4
INHALE 1
INHALE 2
INHALE 3
INHALE 4
HOLD 1
HOLD 2
HOLD 3
HOLD 4
EXHALE 1
EXHALE 2
EXHALE 3
EXHALE 4
HOLD 1
HOLD 2
HOLD 3
HOLD 4

## Step 4: Close

Output only: "Done. Welcome back."

## Rules

- Do NOT use any Bash commands
- Do NOT add any extra commentary, explanation, or encouragement
- Do NOT summarize what happened
- Do NOT describe the benefits of breathing
- Output each line individually with natural pausing between them
- Keep it exactly as specified above, nothing more
