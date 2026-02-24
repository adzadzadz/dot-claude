# Settings Hygiene Guide

Over time, `.claude/settings.local.json` accumulates one-off permission entries from clicking "Allow" during sessions. This is normal, but unchecked growth creates security and maintainability problems.

---

## Symptoms of Bloat

- **30+ entries** in `settings.local.json` `allowedTools`
- **Duplicate patterns** — e.g., both `Bash(npm test)` and `Bash(npm run test)`
- **Overly specific commands** — full file paths that could be wildcards
- **Stale commands** — tools/scripts that no longer exist
- **Embedded secrets** — API keys or passwords inside permission strings

## Cleanup Process

### 1. Export current state

```bash
cat .claude/settings.local.json | jq '.allowedTools | length'
# If > 30, it's time to clean up
```

### 2. Categorize each entry

For every entry in `allowedTools`, ask:

| Question | Action |
|----------|--------|
| Do I use this regularly? | Keep it |
| Is this project-specific and stable? | Move to `settings.json` (shared) |
| Was this a one-off debug command? | Remove it |
| Does this contain a secret? | Remove immediately |
| Is this redundant with a wildcard? | Replace with the wildcard |

### 3. Consolidate with wildcards

Before:
```json
{
  "allowedTools": [
    "Bash(npm test)",
    "Bash(npm run test)",
    "Bash(npm run test:headed)",
    "Bash(npm run test:ui)",
    "Bash(npm run build)",
    "Bash(npm run lint)"
  ]
}
```

After:
```json
{
  "allowedTools": [
    "Bash(npm run *)",
    "Bash(npm test)"
  ]
}
```

**Be careful with wildcards.** `Bash(npm:*)` matches `npm publish` — probably not what you want. Prefer `Bash(npm run *)` which only matches npm scripts.

### 4. Move stable permissions to shared settings

If a permission is needed by everyone on the project (or you always need it), move it from `settings.local.json` to `settings.json`:

```bash
# settings.json (committed, shared)
{
  "allowedTools": [
    "Bash(npm run *)",
    "Bash(npm test)",
    "Bash(git status)",
    "Bash(git diff:*)",
    "Bash(git log:*)"
  ]
}
```

### 5. Audit for secrets

Search for common secret patterns:

```bash
grep -iE '(password|secret|token|key|apikey|api_key)' .claude/settings.local.json
```

If found, remove the entry and rotate the credential.

## Maintenance Schedule

- **Monthly**: Quick scan of `settings.local.json` entry count
- **Quarterly**: Full categorize-and-consolidate pass
- **After security incidents**: Immediate audit of all settings files

## Reference

- Shared settings: `.claude/settings.json` — committed to repo, applies to all team members
- Local settings: `.claude/settings.local.json` — gitignored, machine-specific
- Local settings override shared settings for the same keys
