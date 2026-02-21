# Claude Code Permissions: Laravel + Vue + Docker

Stack: Laravel, Vue.js, Vite, Playwright, Docker Compose

---

## Git Operations

**Essential:**
```json
"Bash(git add:*)",
"Bash(git commit:*)",
"Bash(git status:*)",
"Bash(git rm:*)"
```

**Nice-to-have:**
```json
"Bash(git branch:*)",
"Bash(git push:*)",
"Bash(git remote:*)"
```

---

## Docker Operations

**Essential:**
```json
"Bash(docker-compose:*)",
"Bash(docker exec:*)",
"Bash(docker logs:*)",
"Bash(docker:*)"
```

---

## PHP / Laravel

**Essential:**
```json
"Bash(php artisan:*)",
"Bash(composer:*)"
```

`php artisan:*` covers test, migrate, make:migration, make:job, queue:work, etc.

---

## JavaScript / Vue / Vite

**Essential:**
```json
"Bash(npm install:*)",
"Bash(npm run build:*)",
"Bash(npm run dev:*)",
"Bash(npm run lint)"
```

**Nice-to-have:**
```json
"Bash(npx playwright:*)"
```

---

## Filesystem Operations

**Essential:**
```json
"Bash(mkdir:*)",
"Bash(cp:*)",
"Bash(mv:*)",
"Bash(rm:*)",
"Bash(ls:*)",
"Bash(chmod:*)",
"Bash(find:*)",
"Bash(curl:*)"
```

---

## Deny Rules (Recommended)

```json
"deny": [
  "Bash(rm -rf /:*)",
  "Bash(git push --force:*)",
  "Bash(docker system prune -a:*)",
  "Bash(cat .env:*)",
  "Bash(php artisan migrate:fresh --force:*)"
]
```

---

## Complete Recommended Config

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "Bash(git rm:*)",
      "Bash(git branch:*)",
      "Bash(git push:*)",

      "Bash(docker-compose:*)",
      "Bash(docker exec:*)",
      "Bash(docker logs:*)",
      "Bash(docker:*)",

      "Bash(php artisan:*)",
      "Bash(composer:*)",

      "Bash(npm install:*)",
      "Bash(npm run build:*)",
      "Bash(npm run dev:*)",
      "Bash(npm run lint)",
      "Bash(npx playwright:*)",

      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Bash(rm:*)",
      "Bash(ls:*)",
      "Bash(chmod:*)",
      "Bash(find:*)",
      "Bash(curl:*)"
    ],
    "deny": [
      "Bash(rm -rf /:*)",
      "Bash(git push --force:*)",
      "Bash(docker system prune -a:*)",
      "Bash(cat .env:*)"
    ]
  }
}
```
