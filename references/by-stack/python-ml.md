# Claude Code Permissions: Python ML + Freqtrade

Stack: Python 3, Freqtrade (algorithmic trading), ML/data science, Ruff (linter), mypy (type checker)

---

## Git Operations

**Essential:**
```json
"Bash(git add:*)",
"Bash(git commit:*)",
"Bash(git status:*)"
```

**Use with care:**
```json
"Bash(git reset:*)"
```

`git reset` is common in ML workflows for unstaging or rewinding during strategy iteration.

---

## Python Runtime

**Essential:**
```json
"Bash(python:*)",
"Bash(python3:*)",
"Bash(pip3 install:*)",
"Bash(source:*)"
```

`source:*` is needed for activating virtualenvs.

---

## Freqtrade

**Essential:**
```json
"Bash(freqtrade:*)"
```

Covers all subcommands: `trade`, `backtesting`, `download-data`, `hyperopt`, `plot-dataframe`.

**Ask-tier (prompts for confirmation):**
```json
"ask": ["Bash(freqtrade trade:*)"]
```

This ensures live/paper trading always gets manual confirmation.

---

## Linting & Type Checking

**Essential:**
```json
"Bash(ruff:*)",
"Bash(ruff check:*)",
"Bash(mypy:*)"
```

Avoid path-specific patterns like `~/.local/bin/ruff`. Use standard invocations or `python -m`:
```json
"Bash(python -m ruff:*)",
"Bash(python -m mypy:*)"
```

---

## Filesystem Operations

**Essential:**
```json
"Bash(mkdir:*)",
"Bash(cp:*)",
"Bash(mv:*)",
"Bash(rm:*)",
"Bash(find:*)",
"Bash(touch:*)",
"Bash(tree:*)"
```

---

## Deny Rules (Recommended)

Freqtrade-specific deny rules:
```json
"deny": [
  "Bash(rm -rf /:*)",
  "Bash(git push --force:*)",
  "Bash(cat .env:*)",
  "Bash(cat **/*secret*:*)",
  "Bash(cat **/*key*:*)",
  "Bash(cat **/config*.json:*)",
  "Bash(freqtrade trade --config *live*:*)",
  "Bash(pip3 install --break-system-packages:*)"
]
```

- Prevent reading config files that contain exchange API keys
- Prevent accidental live trading (only dry-run from Claude)

---

## Notes

- ML workflows often need long-running processes. Use `timeout` wrappers for backtesting and hyperopt to prevent runaway processes.
- The `ask` tier is a third permission level: commands matching `ask` patterns prompt for confirmation each time. Ideal for trading commands.

---

## Complete Recommended Config

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "Bash(git reset:*)",

      "Bash(python:*)",
      "Bash(python3:*)",
      "Bash(pip3 install:*)",
      "Bash(source:*)",

      "Bash(freqtrade:*)",

      "Bash(ruff:*)",
      "Bash(ruff check:*)",
      "Bash(mypy:*)",

      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Bash(rm:*)",
      "Bash(find:*)",
      "Bash(touch:*)",
      "Bash(tree:*)",
      "Bash(curl:*)"
    ],
    "deny": [
      "Bash(rm -rf /:*)",
      "Bash(git push --force:*)",
      "Bash(cat .env:*)",
      "Bash(cat **/*secret*:*)",
      "Bash(cat **/*key*:*)",
      "Bash(cat **/config*.json:*)",
      "Bash(freqtrade trade --config *live*:*)"
    ],
    "ask": [
      "Bash(freqtrade trade:*)"
    ]
  }
}
```
