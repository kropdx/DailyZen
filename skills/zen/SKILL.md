---
name: zen
description: Take a mindfulness break. Displays a random zen quote and guides you through a calming 4x4 breathing exercise right in your terminal. Use when you need to pause, reset, or decompress during a coding session.
disable-model-invocation: true
allowed-tools: Bash, Read
---

# Zen - A Mindfulness Break

When invoked, do the following in order:

## Step 1: Display a Random Zen Quote

Read the quotes file at `${CLAUDE_SKILL_DIR}/quotes.json`. Pick one quote at random.

Display it like this:

```
"<quote text here>"

  — Author Name
```

## Step 2: Breathing Exercise

Run the entire breathing exercise using Bash `sleep` commands to control timing. Output each line one at a time using separate Bash calls or a single script with echo + sleep.

First, display a countdown. Run this exact bash command:

```bash
for i in 10 9 8 7 6 5 4 3 2 1; do echo "$i"; sleep 1; done
```

Then for each round (4 rounds total), run this exact bash command:

```bash
echo "ROUND 1/4"; for phase in INHALE HOLD EXHALE HOLD; do for i in 1 2 3 4; do sleep 1; echo "$phase $i"; done; done
```

Repeat for rounds 2, 3, and 4 (updating the round number each time).

After all 4 rounds, say only: "Done. Welcome back."

## Important

- Do NOT add any extra text before, between, or after the breathing rounds
- Do NOT summarize or explain what happened
- Do NOT describe the benefits of breathing
- Keep it minimal
