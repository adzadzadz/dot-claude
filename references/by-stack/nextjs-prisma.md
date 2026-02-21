# Claude Code Permissions: Next.js + Prisma + Supabase

Stack: Next.js (App Router), TypeScript, Tailwind CSS, Prisma ORM, Supabase Auth, Vitest

---

## Git Operations

**Essential:**
```json
"Bash(git add:*)",
"Bash(git commit:*)",
"Bash(git status:*)",
"Bash(git stash:*)",
"Bash(git push:*)"
```

---

## Prisma / Database

**Essential:**
```json
"Bash(npx prisma generate:*)",
"Bash(npx prisma migrate dev:*)",
"Bash(npx prisma migrate deploy:*)",
"Bash(npx prisma db seed:*)"
```

**Nice-to-have:**
```json
"Bash(npx prisma migrate diff:*)"
```

---

## Next.js / Node.js

**Essential:**
```json
"Bash(npm install:*)",
"Bash(npm run build:*)",
"Bash(npm run dev:*)",
"Bash(npx next build:*)",
"Bash(npx next dev:*)"
```

**Nice-to-have:**
```json
"Bash(npx tsx:*)",
"Bash(node -e:*)"
```

---

## Testing

**Essential:**
```json
"Bash(npm test:*)",
"Bash(npx vitest run:*)",
"Bash(npm run seed:*)"
```

---

## Filesystem & Shell

**Essential:**
```json
"Bash(ls:*)",
"Bash(find:*)",
"Bash(curl:*)",
"Bash(mkdir:*)"
```

---

## Deny Rules (Recommended)

```json
"deny": [
  "Bash(rm -rf /:*)",
  "Bash(git push --force:*)",
  "Bash(npx prisma migrate reset --force:*)",
  "Bash(npx prisma db push --force-reset:*)",
  "Bash(cat .env:*)",
  "Bash(cat .env.local:*)"
]
```

---

## Notes

- Avoid committing one-off git commit messages to `settings.json` (the shared config). Keep those in `settings.local.json`.
- Avoid NVM-path-specific commands (e.g., `/Users/you/.nvm/versions/...`). Use standard `npm`/`npx` invocations.

---

## Complete Recommended Config

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "Bash(git stash:*)",
      "Bash(git push:*)",

      "Bash(npx prisma generate:*)",
      "Bash(npx prisma migrate dev:*)",
      "Bash(npx prisma migrate deploy:*)",
      "Bash(npx prisma migrate diff:*)",
      "Bash(npx prisma db seed:*)",

      "Bash(npm install:*)",
      "Bash(npm run build:*)",
      "Bash(npm run dev:*)",
      "Bash(npx next build:*)",
      "Bash(npx next dev:*)",
      "Bash(npx tsx:*)",
      "Bash(node -e:*)",

      "Bash(npm test:*)",
      "Bash(npx vitest run:*)",
      "Bash(npm run seed:*)",

      "Bash(ls:*)",
      "Bash(find:*)",
      "Bash(curl:*)",
      "Bash(mkdir:*)"
    ],
    "deny": [
      "Bash(rm -rf /:*)",
      "Bash(git push --force:*)",
      "Bash(npx prisma migrate reset --force:*)",
      "Bash(cat .env:*)",
      "Bash(cat .env.local:*)"
    ]
  }
}
```
