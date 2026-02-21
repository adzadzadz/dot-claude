# Claude Code Permissions: Python FastAPI + React + Docker

Stack: Python (FastAPI backend), React (frontend), Docker Compose, GitHub Actions CI/CD

---

## Git Operations

**Essential:**
```json
"Bash(git add:*)",
"Bash(git commit:*)",
"Bash(git rm:*)",
"Bash(git push:*)"
```

**Nice-to-have:**
```json
"Bash(gh run list:*)",
"Bash(gh run view:*)"
```

---

## Docker Operations

**Essential:**
```json
"Bash(docker-compose:*)",
"Bash(docker exec:*)",
"Bash(docker logs:*)",
"Bash(docker build:*)",
"Bash(docker run:*)",
"Bash(docker stop:*)",
"Bash(docker restart:*)",
"Bash(docker:*)"
```

---

## Python / FastAPI

**Essential:**
```json
"Bash(python:*)",
"Bash(python3:*)",
"Bash(pip install:*)",
"Bash(pip3 install:*)",
"Bash(source:*)"
```

`source:*` is needed for activating virtualenvs.

---

## JavaScript / React

**Essential:**
```json
"Bash(npm install:*)",
"Bash(npm run build:*)",
"Bash(npm run dev:*)",
"Bash(npm test:*)"
```

**Nice-to-have:**
```json
"Bash(npx playwright:*)"
```

---

## Custom Scripts

Generalized pattern for project scripts:
```json
"Bash(./scripts/*:*)",
"Bash(./build.sh:*)"
```

---

## Filesystem & Process

**Essential:**
```json
"Bash(mkdir:*)",
"Bash(cp:*)",
"Bash(mv:*)",
"Bash(rm:*)",
"Bash(ls:*)",
"Bash(chmod:*)",
"Bash(find:*)",
"Bash(curl:*)",
"Bash(touch:*)"
```

---

## Deny Rules (Recommended)

```json
"deny": [
  "Bash(rm -rf /:*)",
  "Bash(git push --force:*)",
  "Bash(docker system prune -a --force:*)",
  "Bash(cat .env:*)",
  "Bash(cat **/*secret*:*)",
  "Bash(pip install --break-system-packages:*)"
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
      "Bash(git rm:*)",
      "Bash(git push:*)",
      "Bash(gh run list:*)",
      "Bash(gh run view:*)",

      "Bash(docker-compose:*)",
      "Bash(docker exec:*)",
      "Bash(docker logs:*)",
      "Bash(docker build:*)",
      "Bash(docker run:*)",
      "Bash(docker stop:*)",
      "Bash(docker restart:*)",
      "Bash(docker:*)",

      "Bash(python:*)",
      "Bash(python3:*)",
      "Bash(pip install:*)",
      "Bash(pip3 install:*)",
      "Bash(source:*)",

      "Bash(npm install:*)",
      "Bash(npm run build:*)",
      "Bash(npm run dev:*)",
      "Bash(npm test:*)",
      "Bash(npx playwright:*)",

      "Bash(./scripts/*:*)",
      "Bash(./build.sh:*)",

      "Bash(mkdir:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Bash(rm:*)",
      "Bash(ls:*)",
      "Bash(chmod:*)",
      "Bash(find:*)",
      "Bash(curl:*)",
      "Bash(touch:*)"
    ],
    "deny": [
      "Bash(rm -rf /:*)",
      "Bash(git push --force:*)",
      "Bash(docker system prune -a --force:*)",
      "Bash(cat .env:*)",
      "Bash(cat **/*secret*:*)"
    ]
  }
}
```
