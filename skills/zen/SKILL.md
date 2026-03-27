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

Display it like this (use the exact formatting, including the author on a new line):

```
  ------------------------------------------------

    "{quote text here}"

                              — Author Name

  ------------------------------------------------
```

Pause briefly after showing the quote. Then say:

```
  Take a breath. Let's do a 4x4 breathing exercise.
  4 rounds. 4 seconds each phase. ~60 seconds total.
```

## Step 2: Run the Breathing Exercise

Execute the breathing script:

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/breathe.sh"
```

This runs an animated terminal breathing exercise:
- INHALE (4 seconds, animated progress bar)
- HOLD (4 seconds)
- EXHALE (4 seconds)
- HOLD (4 seconds)
- Repeated 4 times

## Step 3: Close

After the script completes, say one brief, calm closing line. Keep it simple and warm. Do not be verbose. Examples:
- "Welcome back."
- "Ready when you are."
- "Back to it."

Do NOT summarize what just happened. Do NOT explain the benefits of breathing. Just a brief, grounded closing.
