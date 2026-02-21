# Claude Code Permissions: WordPress Plugin/Theme

Stack: WordPress (PHP plugin/theme development), npm (asset pipeline), Playwright (E2E)

> **Note:** This covers both Docker-based and Local by Flywheel environments. Pick the section that matches your setup.

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

## Docker Operations (if using Docker)

**Essential:**
```json
"Bash(docker-compose:*)",
"Bash(docker exec:*)",
"Bash(docker logs:*)"
```

---

## Local by Flywheel (if using Local)

Many Local by Flywheel setups require a wrapper script (`./wp`) that sets the correct PHP binary, MySQL socket, and WP path. If your project uses one:

**Essential:**
```json
"Bash(./wp post list:*)",
"Bash(./wp post get:*)",
"Bash(./wp post create:*)",
"Bash(./wp post meta:*)",
"Bash(./wp term list:*)",
"Bash(./wp option get:*)",
"Bash(./wp option list:*)",
"Bash(./wp option update:*)",
"Bash(./wp eval:*)",
"Bash(./wp media import:*)",
"Bash(./wp media list:*)",
"Bash(./wp user list:*)"
```

Document the wrapper in CLAUDE.md so Claude always uses `./wp` instead of bare `wp`.

---

## PHP / WordPress

**Essential:**
```json
"Bash(php -l:*)",
"Bash(php -r:*)"
```

`php -l` is the PHP syntax checker. `php -r` runs inline PHP for quick checks.

**Code Quality (if using PHPStan/PHPUnit):**
```json
"Bash(vendor/bin/phpstan analyse:*)",
"Bash(vendor/bin/phpunit:*)",
"Bash(php -d memory_limit=2G vendor/bin/phpstan:*)",
"Bash(composer install:*)"
```

PHPStan with WordPress stubs often needs 2G memory limit.

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

## Figma MCP Tools (if using Figma for design)

```json
"mcp__figma__whoami",
"mcp__figma__get_screenshot",
"mcp__figma__get_design_context",
"mcp__figma__get_variable_defs",
"mcp__figma__get_metadata"
```

---

## Build Scripts

```json
"Bash(npm run build:*)",
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

## Complete Recommended Config (Docker)

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

      "Bash(php -l:*)",
      "Bash(php -r:*)",
      "Bash(vendor/bin/phpstan analyse:*)",
      "Bash(vendor/bin/phpunit:*)",
      "Bash(composer install:*)",

      "Bash(npm install:*)",
      "Bash(npm run build:*)",
      "Bash(npx playwright:*)",

      "Bash(ls:*)",
      "Bash(chmod:*)",
      "Bash(curl:*)",

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

## Complete Recommended Config (Local by Flywheel)

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "Bash(git push:*)",

      "Bash(php -l:*)",
      "Bash(php -r:*)",
      "Bash(vendor/bin/phpstan analyse:*)",
      "Bash(vendor/bin/phpunit:*)",
      "Bash(php -d memory_limit=2G vendor/bin/phpstan:*)",
      "Bash(composer install:*)",

      "Bash(./wp post list:*)",
      "Bash(./wp post get:*)",
      "Bash(./wp post create:*)",
      "Bash(./wp post meta:*)",
      "Bash(./wp term list:*)",
      "Bash(./wp option get:*)",
      "Bash(./wp option list:*)",
      "Bash(./wp option update:*)",
      "Bash(./wp eval:*)",
      "Bash(./wp media import:*)",
      "Bash(./wp media list:*)",
      "Bash(./wp user list:*)",

      "Bash(npm install:*)",
      "Bash(npm run build:*)",
      "Bash(npx playwright test:*)",

      "Bash(ls:*)",
      "Bash(chmod:*)",
      "Bash(curl:*)",

      "mcp__figma__whoami",
      "mcp__figma__get_screenshot",
      "mcp__figma__get_design_context",
      "mcp__figma__get_variable_defs",
      "mcp__figma__get_metadata"
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
