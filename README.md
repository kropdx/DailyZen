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

To show a quote every time Claude Code starts, add a `SessionStart` hook to `~/.claude/settings.json`.

> **Note:** Hooks run shell commands, not skills — `/dailyzen` won't work here. Use the `node` command below to read directly from the installed quotes file.

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "node -e \"const q=require(process.env.HOME+'/.claude/plugins/marketplaces/dailyzen/skills/zen/quotes.json');const r=q[Math.floor(Math.random()*q.length)];console.log('\\\"'+r.quote+'\\\"\\n  — '+r.author);\""
          }
        ]
      }
    ]
  }
}
```

## License

MIT
