# Claude Code Setup Kit

A living setup kit for configuring Claude Code in any project. Clone it into a project, run Claude, and it sets everything up. The kit stays around so it can learn from the project — you push improvements back and delete it manually when done.

---

## Instructions for Claude

When the user says something like "setup claude, check dot-claude" or "review claude setup, check dot-claude", follow this 4-phase process:

### Phase 1 — Discovery (read-only, no changes)

1. Read `dot-claude/CHECKLIST.md` to understand the full setup criteria
2. Scan for existing configuration:
   - `.claude/` directory (settings.json, settings.local.json, hooks/, skills/, agents/)
   - `CLAUDE.md` at project root
   - `.claude/CHECKLIST.md` (if present, this is a re-run — compare against previous results)
3. Explore the project:
   - Identify the tech stack (language, framework, database, infrastructure)
   - Map the directory structure (top 2 levels)
   - Find key files (entry points, configs, env files, test configs, CI/CD)
   - Read package.json, composer.json, pyproject.toml, Cargo.toml, or equivalent
   - Check for Docker (docker-compose.yml, Dockerfile)
   - Check for existing linter/formatter configs (.eslintrc, .prettierrc, ruff.toml, etc.)
4. **Do NOT make any changes yet.**

### Phase 2 — Gap Analysis (report, no changes)

5. Compare every checklist item against what already exists
6. Categorize each item:
   - **Done** — already satisfied, no action needed
   - **Partial** — exists but incomplete or outdated
   - **Missing** — not present at all
   - **Issue** — exists but has a problem (credential leak, bloated permissions, stale info)
7. Present the report to the user:
   - Summary: "X items done, Y need work, Z issues found"
   - List each section with status
   - Highlight any issues that need immediate attention (especially security)
8. **Do NOT make any changes yet. Wait for the user to acknowledge the report.**

### Phase 3 — Interactive Setup (only work on gaps)

9. Work through each section that needs attention, in order:
   - **Section 1 (CLAUDE.md)**: If missing, use `dot-claude/templates/CLAUDE.md.template` as a starter and fill it in based on what you discovered. If partial, propose additions. Ask the user to confirm before writing.
   - **Section 2 (Settings)**: Reference `dot-claude/references/by-stack/` for the matching stack. Propose a permission set. If existing settings have issues (credential leaks, bloat), flag them and propose fixes. Ask before changing.
   - **Section 3 (Hooks)**: Ask the user the assessment questions from the checklist. Only create hooks they actually want. Reference `dot-claude/references/hooks/` for examples.
   - **Section 4 (Skills)**: Ask the user the assessment questions. Only create skills they actually want. Reference `dot-claude/references/skills-examples.md`.
   - **Section 5 (Agents)**: Ask the user the assessment questions. Most projects won't need custom agents — say so. Reference `dot-claude/references/agents-examples.md`.
   - **Section 6 (Maintenance)**: Add the "Last Reviewed" header to CLAUDE.md. Explain the review triggers.
10. For each change: explain what you're doing and why, then ask for approval before writing.
11. Write all configuration to:
    - `CLAUDE.md` at the project root
    - `.claude/settings.json` (shared permissions)
    - `.claude/settings.local.json` (machine-specific, if needed)
    - `.claude/hooks/` (hook scripts, if any)
    - `.claude/skills/<name>/SKILL.md` (skills, if any)
    - `.claude/agents/<name>.md` (agents, if any)

### Phase 4 — Finalize & Improve

12. Create `.claude/CHECKLIST.md` — copy the checklist with all items marked with their status and today's date at the top
13. Review what you learned from this project and suggest improvements to `dot-claude/`:
    - New stack patterns worth adding to `references/by-stack/`?
    - Better permission patterns discovered?
    - Useful hook or skill patterns that could benefit other projects?
    - Gaps in the checklist that should be added?
14. If improvements are identified, ask the user if you should update the `dot-claude/` files
15. Confirm: "Setup complete. Your configuration is in `.claude/` and `CLAUDE.md`. The dot-claude kit is still here — push any improvements and delete it when you're ready."

**Note**: Do NOT delete `dot-claude/`. The user will manually:
1. `cd dot-claude && git add . && git commit -m "improvements from <project>" && git push`
2. `cd .. && rm -rf dot-claude`

---

## Important Rules for Claude

- **Never assume — always ask.** Especially for hooks, skills, and agents. The user might not want any.
- **Audit before adding.** Don't pile new config on top of broken old config. Fix issues first.
- **Keep CLAUDE.md between 50-200 lines.** Enough context to be useful, not so much it wastes tokens.
- **Permission design over permission accumulation.** Intentional allowlists, not "click Allow on everything."
- **Security first.** If you find credentials in settings files, flag them immediately. Don't wait for Phase 3.
- **Reference the right stack.** Check `references/by-stack/` for the matching technology and use those patterns.
- **Contribute back.** If the project teaches you something new (better patterns, new stack, improved hooks), propose updates to `dot-claude/` files. This kit gets better with every project it touches.
- **Never delete dot-claude/.** The user handles cleanup manually after pushing improvements.
- **ALWAYS omit AI attribution from commit messages.** Never include "Co-Authored-By", "Generated by", or any mention of Claude/AI in commit messages. This rule applies to this repo AND all projects where this kit is used. When setting up a project, add this as a git convention in CLAUDE.md.
