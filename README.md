# DailyZen

A random inspirational quote in your terminal. A moment of clarity between commits.

## Install

```
/plugin marketplace add kropdx/DailyZen
/plugin install dailyzen
```

## Usage

```
/dailyzen
```

## Auto-zen on session start

Show a quote every time Claude Code starts by adding a hook to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "/dailyzen"
          }
        ]
      }
    ]
  }
}
```

## License

MIT
