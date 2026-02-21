# Security Audit Guide

How to find and fix credential leaks in your Claude Code configuration.

---

## Why This Matters

Claude Code settings files accumulate permissions organically. When you click "Allow" on a command that contains credentials (like an FTP command with a password or a database connection string), those credentials get stored in plaintext in your settings files. If those files are committed to git, the credentials are exposed.

---

## Quick Scan

Run these from your project root:

### 1. Search settings files for credentials

```bash
grep -riE "password|secret|key|token|apikey|api_key|credential|auth" .claude/ 2>/dev/null
```

### 2. Search for embedded connection strings

```bash
grep -riE "(mysql|postgres|mongodb|redis|ftp|ssh|smtp)://|@.*:.*@" .claude/ 2>/dev/null
```

### 3. Search for base64-encoded strings (possible encoded secrets)

```bash
grep -oE '[A-Za-z0-9+/]{40,}={0,2}' .claude/settings*.json 2>/dev/null
```

### 4. Check if settings files are committed

```bash
git log --oneline -- .claude/settings.local.json .claude/notes.txt 2>/dev/null
```

If `settings.local.json` or `notes.txt` appear in the git history, those credentials may already be exposed.

---

## Common Leak Patterns

### FTP/SFTP credentials in allowed commands

```json
"Bash(lftp -u username,password ftp://server.com:*)"
```

**Fix**: Remove the command from settings. Use environment variables or a `.netrc` file instead.

### Database passwords in allowed commands

```json
"Bash(docker exec db mysql -u root -pMyPassword:*)"
```

**Fix**: Remove the command. Configure the database container to use password-less local auth or read from env.

### API keys in allowed commands

```json
"Bash(curl -H 'Authorization: Bearer sk-abc123':*)"
```

**Fix**: Remove the command. Use environment variables: `curl -H "Authorization: Bearer $API_KEY"`.

### Credentials in notes files

```json
// .claude/notes.txt
DB_PASSWORD=mysecretpassword
```

**Fix**: Delete the file. Store credentials in `.env` (which should be gitignored).

---

## Remediation Steps

### 1. Remove credentials from settings files

Edit `.claude/settings.local.json` and `.claude/settings.json`:
- Remove any allow rules that contain credentials
- Replace with credential-free versions (use env vars)

### 2. Delete credential-containing files

```bash
rm .claude/notes.txt  # if it contains credentials
```

### 3. Rotate compromised credentials

If credentials were committed to git, they are compromised even if you delete them now. You must:
- Change the password/key/token at the source (database, API provider, FTP server)
- Update your `.env` file with the new credentials
- Never store the new credentials in `.claude/` files

### 4. Remove from git history (if committed)

If the file with credentials was committed:

```bash
# Check if it's in history
git log --oneline -- .claude/notes.txt

# If yes, remove from history (requires force push — coordinate with team)
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch .claude/notes.txt' \
  --prune-empty --tag-name-filter cat -- --all
```

### 5. Prevent future leaks

Add to `.gitignore`:
```
.claude/settings.local.json
.claude/notes.txt
```

Add deny rules to `.claude/settings.json`:
```json
"deny": [
  "Read(./.env)",
  "Read(./.env.*)",
  "Read(./secrets/**)",
  "Read(./.claude/notes.txt)"
]
```

Add a PreToolUse hook (see `hooks/block-secrets.sh`).

---

## Prevention Checklist

- [ ] `.claude/settings.local.json` is in `.gitignore`
- [ ] No credentials in `.claude/settings.json` (the committed file)
- [ ] No `.claude/notes.txt` with passwords
- [ ] Deny rules block reading `.env` and credential files
- [ ] Credentials stored in `.env` (gitignored) not in Claude settings
- [ ] Block-secrets hook installed (optional but recommended)
