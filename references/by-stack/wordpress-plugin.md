# Claude Code Permissions: WordPress Plugin + Docker

Stack: WordPress (PHP plugin development), Docker Compose, npm (asset pipeline), Playwright (E2E)

---

## Git Operations

**Essential:**
```json
"Bash(git add:*)",
"Bash(git commit:*)",
"Bash(git status:*)",
"Bash(git push:*)",
"Bash(git rm:*)"
```

---

## Docker Operations

**Essential:**
```json
"Bash(docker-compose:*)",
"Bash(docker exec:*)",
"Bash(docker logs:*)"
```

---

## PHP / WordPress

**Essential:**
```json
"Bash(php:*)",
"Bash(php -l:*)"
```

`php -l` is the PHP syntax checker. `php:*` covers running test scripts, WP-CLI, etc.

**Nice-to-have:**
```json
"Bash(php tests/*:*)"
```

---

## JavaScript / Assets

**Essential:**
```json
"Bash(npm install:*)",
"Bash(npx playwright:*)"
```

---

## Filesystem Operations

**Essential:**
```json
"Bash(mkdir:*)",
"Bash(mv:*)",
"Bash(rm:*)",
"Bash(ls:*)",
"Bash(chmod:*)",
"Bash(find:*)",
"Bash(curl:*)",
"Bash(sed:*)"
```

**Nice-to-have:**
```json
"Bash(unzip:*)",
"Bash(md5sum:*)",
"Bash(sha256sum:*)"
```

Checksums are useful for verifying plugin ZIP integrity.

---

## Build Scripts

```json
"Bash(./build.sh)"
```

---

## Deny Rules (Recommended)

WordPress-specific deny rules:
```json
"deny": [
  "Bash(rm -rf /:*)",
  "Bash(git push --force:*)",
  "Bash(cat wp-config.php:*)",
  "Bash(cat .env:*)",
  "Bash(docker exec * wp user create --role=administrator:*)"
]
```

- Prevent reading `wp-config.php` (contains DB credentials and auth salts)
- Prevent creating admin users inside Docker containers

---

## Complete Recommended Config

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "Bash(git push:*)",

      "Bash(docker-compose:*)",
      "Bash(docker exec:*)",
      "Bash(docker logs:*)",

      "Bash(php:*)",
      "Bash(php -l:*)",
      "Bash(php tests/*:*)",

      "Bash(npm install:*)",
      "Bash(npx playwright:*)",

      "Bash(mkdir:*)",
      "Bash(mv:*)",
      "Bash(rm:*)",
      "Bash(ls:*)",
      "Bash(chmod:*)",
      "Bash(find:*)",
      "Bash(curl:*)",
      "Bash(sed:*)",
      "Bash(unzip:*)",

      "Bash(./build.sh)"
    ],
    "deny": [
      "Bash(rm -rf /:*)",
      "Bash(git push --force:*)",
      "Bash(cat wp-config.php:*)",
      "Bash(cat .env:*)"
    ]
  }
}
```
