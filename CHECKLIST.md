# Claude Code Setup Checklist

<!-- Last Reviewed: YYYY-MM-DD | Checklist Version: 1.0 -->

Work through each section in order. For each item, determine if it is:
- [x] **Done** — already satisfied
- [~] **Partial** — exists but incomplete or outdated
- [ ] **Missing** — needs to be created
- [!] **Issue** — exists but has a problem

---

## 1. Project Understanding — CLAUDE.md

The CLAUDE.md file is Claude's first read on every session. If it's incomplete, Claude wastes tokens re-discovering things. If it's bloated, Claude's context window fills with stale info. Aim for 50-200 lines.

### 1.1 Identity & Architecture
- [ ] **Project name and one-line purpose**
  _Why: Claude needs to know what it's building. Prevents confusion in multi-project sessions._
- [ ] **Tech stack summary** — language, framework, database, cache, messaging
  _Why: Determines which patterns and APIs Claude reaches for._
- [ ] **Architecture style** — monolith, microservices, monorepo, plugin-based, etc.
  _Why: Affects how Claude reasons about file organization and dependencies._
- [ ] **Key external integrations** — APIs, payment providers, auth services, cloud providers
  _Why: Claude needs to know what's external vs internal to avoid breaking integrations._

### 1.2 Directory Structure
- [ ] **Top-level directory map** — 1-2 levels deep, annotated
  _Why: Saves Claude from running `find` or `ls` on every session start._
- [ ] **Key files called out explicitly** — entry points, config files, env files, specs
  _Why: Claude can jump directly to the right file instead of searching._

### 1.3 Development Workflow
- [ ] **Setup/install commands** — how to get the project running from scratch
  _Why: Claude can help you or a new contributor set up the project._
- [ ] **Run/start commands** — how to start the dev server, workers, etc.
  _Why: Most common operation. Claude needs this for every session._
- [ ] **Test commands** — how to run the test suite, specific test files, coverage
  _Why: Claude should always be able to verify its changes._
- [ ] **Build commands** — how to build for production
  _Why: Claude can catch build-breaking changes before they reach CI._
- [ ] **Deploy commands** — how to deploy, or note "manual deployment" if applicable
  _Why: Even if Claude doesn't deploy, understanding the deployment target affects decisions._
- [ ] **Docker/container notes** if applicable — which services run in containers, how to exec into them
  _Why: Docker changes the command prefix for everything. Claude needs to know this upfront._

### 1.4 Conventions & Patterns
- [ ] **Naming conventions** — file naming, variable naming, database table prefixes
  _Why: Consistency. Claude will follow what you document here._
- [ ] **Code style rules** — linter config, formatter, import ordering
  _Why: Prevents Claude from writing code that fails lint or looks foreign._
- [ ] **Git conventions** — branch naming, commit message format, AI attribution rules
  _Why: Prevents embarrassing commits._
- [ ] **Architecture patterns** — service layer, repository pattern, module system, etc.
  _Why: Claude will match existing patterns rather than inventing new ones._

### 1.5 Constraints & Gotchas
- [ ] **Known limitations** — things that don't work, workarounds in place
  _Why: Prevents Claude from "fixing" intentional workarounds._
- [ ] **Security-sensitive areas** — where credentials live, what NOT to log, what NOT to commit
  _Why: Prevents credential exposure._
- [ ] **Performance considerations** — known bottlenecks, large tables, expensive operations
  _Why: Claude can avoid making performance worse when modifying hot paths._
- [ ] **Project principles** — hard rules like "never use mock data" or "never bypass pre-commit hooks"
  _Why: These are the rules Claude violates most often when they aren't explicit._

### 1.6 Task Management (if applicable)
- [ ] **Task tracking system** — TASKS.md, docs/plan/, GitHub issues, etc.
  _Why: Claude needs to know where to read and update progress._
- [ ] **Session startup protocol** — what Claude should read first on each session
  _Why: Prevents Claude from re-implementing completed work._

---

## 2. Rules & Configuration — .claude/settings

Settings control what Claude is allowed to do without asking. Poorly maintained settings accumulate one-off commands that grant overly broad access. Intentionally designed settings are safer and reduce permission fatigue.

### 2.1 Shared Settings (.claude/settings.json)
- [ ] **Create .claude/settings.json** if the project has team members or you want reproducible permissions
  _Why: settings.local.json is machine-specific and not committed. Shared settings ensure consistency._
- [ ] **Define base permission allowlist** — common, safe commands for this project's stack
  _Why: Reduces "allow?" prompts during normal work. See references/by-stack/ for your stack._
- [ ] **Use wildcard patterns intentionally** — prefer `Bash(npm run *)` over `Bash(npm:*)`
  _Why: `Bash(npm:*)` allows `npm publish` which you probably don't want._
- [ ] **Add deny rules for sensitive paths** — `.env`, `secrets/`, credential files
  _Why: Prevents Claude from reading credentials even if you accidentally ask it to._

### 2.2 Local Settings (.claude/settings.local.json)
- [ ] **Review current permissions** — remove one-off commands that accumulated from clicking "Allow"
  _Why: Over time, these accumulate into a bloated, overly-permissive list._
- [ ] **Move stable permissions to settings.json** — anything you always need should be shared
  _Why: Keeps local settings small and intentional._
- [ ] **Audit for embedded credentials** — search for passwords, API keys, tokens in allow rules
  _Why: Credentials embedded in permission strings are a real security risk._

### 2.3 Stack-Specific Permissions
- [ ] **Match permissions to your stack** — reference `references/by-stack/` for patterns
  _Why: Pre-built patterns prevent both over-permissioning and under-permissioning._

---

## 3. Hooks — Automated Workflow Guards

Hooks run shell commands or LLM prompts at specific points in Claude's workflow. They solve recurring problems like forgetting to lint, accidentally reading secrets, or Claude stopping before tests pass.

Start with zero or one hook. Add more only when you hit a repeated problem.

### 3.1 Assess Hook Needs
- [ ] **Does Claude frequently write code that fails lint?** → PostToolUse hook on Write|Edit
  _Why: Auto-lint catches style issues before you notice them._
- [ ] **Has Claude ever read or exposed credentials?** → PreToolUse hook on Read|Bash
  _Why: Blocks credential access at the tool level._
- [ ] **Does Claude stop before the work is actually done?** → Stop hook
  _Why: A prompt-based Stop hook can verify test passage before Claude considers itself finished._
- [ ] **Do you need environment setup on each session?** → SessionStart hook
  _Why: Inject git branch, recent changes, or environment state automatically._

### 3.2 Implement Hooks (if needed)
- [ ] **Store hook scripts in `.claude/hooks/`**
  _Why: Project-specific. Reference with `"$CLAUDE_PROJECT_DIR"/.claude/hooks/script.sh`._
- [ ] **Define hooks in `.claude/settings.json`** (shared) or `.claude/settings.local.json` (personal)
  _Why: Hooks follow the same settings hierarchy as permissions._
- [ ] **Make hook scripts executable** — `chmod +x .claude/hooks/*.sh`
  _Why: Non-executable scripts fail silently._
- [ ] **Test hooks** — verify they fire and produce expected output
  _Why: Hooks are loaded at session start. Changes require a restart._

### 3.3 Recommended Starter Hooks

**Post-write linting** (most universally useful):
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/lint.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**Credential guard** (recommended for projects with .env files):
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read|Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/block-secrets.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

**Stop verification** (recommended for TDD projects):
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Review the conversation. Did Claude run the test suite and did all tests pass? If not, respond with a reason to continue working.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

---

## 4. Skills — Reusable Workflows

Skills are Markdown files that teach Claude reusable workflows. They appear as slash commands (/skill-name) or Claude can invoke them automatically when relevant.

### 4.1 Assess Skill Needs
- [ ] **Do you have a specific commit message format?** → commit skill
  _Why: Ensures consistent commit messages without repeating instructions._
- [ ] **Do you deploy from Claude?** → deploy skill
  _Why: Formalizes the deployment process. Set `disable-model-invocation: true` for safety._
- [ ] **Do you have a code review checklist?** → review skill
  _Why: Claude follows the same review process every time._
- [ ] **Do you run tests in a specific way?** → test skill
  _Why: Encapsulates the right test commands, flags, and post-test actions._

### 4.2 Create Skills (if needed)
- [ ] **Project skills go in `.claude/skills/<name>/SKILL.md`**
  _Why: Committed and shared with the team._
- [ ] **Personal cross-project skills go in `~/.claude/skills/<name>/SKILL.md`**
  _Why: Apply everywhere (like your commit format)._
- [ ] **Write a clear `description` field** — Claude uses this to decide when to invoke
  _Why: Vague descriptions cause wrong invocations or none at all._
- [ ] **Set `disable-model-invocation: true`** for skills with side effects (deploy, publish)
  _Why: Prevents Claude from deploying without your explicit command._

Skill format:
```markdown
---
name: skill-name
description: This skill should be used when the user asks to "do specific thing".
version: 1.0.0
---

Instructions for Claude when this skill is invoked...
```

---

## 4.3 Design Integration Skills (if using Figma)

For projects where Figma designs drive implementation, consider these specialized skills:

- [ ] **Design verification skill** — Compare implementation against Figma, report discrepancies
  _Why: Catches visual drift before it accumulates. Creates Playwright tests for CI._
- [ ] **Design-to-code skill** — Build page templates from Figma designs with component inventory
  _Why: Formalizes the Figma-to-code workflow. Prevents duplicate component creation._
- [ ] **Component decomposition skill** — Break Figma pages into individual components, implement each
  _Why: Avoids monolithic implementation. Ensures component reuse._

**Key pattern — Duplicate Detection:**
Before implementing any component from Figma, the skill should:
1. Search existing components for matches (by name, structure, purpose)
2. If found: verify it's truly the same component (not a variant or look-alike)
3. Report: exact match / needs updates / different variant / new component
4. Wait for user confirmation before proceeding

This prevents the most common Figma-to-code problem: recreating components that already exist.

---

## 5. Agents — Specialized Subagents

Agents are specialized Claude instances with their own tools and system prompts. Most projects don't need custom agents — the built-in Explore, Plan, and general-purpose agents handle common needs.

### 5.1 Assess Agent Needs
- [ ] **Do you need a read-only code reviewer?** → code-reviewer agent with Read/Grep/Glob only
  _Why: Isolates review from the main context and prevents accidental edits._
- [ ] **Do you need specialized database queries?** → db-reader agent
  _Why: Enforces read-only access through restricted tools._
- [ ] **Do you need to explore large codebases without polluting context?** → built-in Explore is sufficient
  _Why: Don't recreate what already exists._

### 5.2 Create Agents (if needed)
- [ ] **Project agents go in `.claude/agents/<name>.md`**
  _Why: Committed and shared._
- [ ] **Personal agents go in `~/.claude/agents/<name>.md`**
  _Why: Apply across all projects._
- [ ] **Restrict tools explicitly** — grant only what the agent needs
  _Why: An agent with all tools is just another Claude session. Restrictions make agents useful._
- [ ] **Choose the right model** — `haiku` for fast read-only tasks, `inherit` for complex work
  _Why: Haiku is faster and cheaper for exploration._

Agent format:
```markdown
---
name: agent-name
description: Use this agent when... Examples: <example>user request</example>
model: inherit
tools: ["Read", "Grep", "Glob"]
---

System prompt for the agent...
```

---

## 6. Maintenance — Keeping Config Current

Configuration that isn't maintained becomes misleading. Outdated CLAUDE.md is worse than no CLAUDE.md because Claude acts on stale information with confidence.

### 6.1 Tracking
- [ ] **Add "Last Reviewed" date to CLAUDE.md header**
  _Why: Makes staleness visible._
  ```markdown
  <!-- Last reviewed: 2026-02-21 | Checklist version: 1.0 -->
  ```
- [ ] **Record checklist version** from this file
  _Why: When the checklist evolves, you can see which version a project was set up with._

### 6.2 Review Triggers
Review your Claude Code config when any of these happen:
- [ ] **Major dependency upgrade** — framework version bump, language version change
- [ ] **New team member joins** — or you return to a project after a break
- [ ] **Architectural change** — new service, database migration, deployment target change
- [ ] **Permission creep** — settings.local.json grows beyond ~30 entries
- [ ] **After a security incident** — credential leak, unauthorized access
- [ ] **Quarterly review** — even without triggers, review every 3 months

### 6.3 Review Process
- [ ] **CLAUDE.md accuracy** — do the commands still work? Is the architecture section current?
- [ ] **Permission hygiene** — remove unused one-off commands from settings.local.json
- [ ] **Credential scan** — search settings files for passwords, keys, tokens
- [ ] **Hook health** — do hook scripts still exist and work?
- [ ] **Skill relevance** — are skills still accurate? Remove obsolete ones
- [ ] **Agent utility** — are custom agents still used? Remove unused ones
