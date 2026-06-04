# skills.md

Skills available when working on Potoos. Skills are reusable agent
capabilities; project skills live in `.agents/skills/` (this repo) and global
skills live in `~/.claude/skills` (all projects on this machine).

> Note: `.agents/skills/`, `.claude/`, `skills-lock.json`, and
> `awesome-codex-skills/` are local tooling and are intentionally **not**
> committed as app work.

## Project Skills (`.agents/skills/`)

Installed for this repo (UI/design and brand oriented). Several were flagged by
install-time scanners (Gen AI rated `impeccable` Medium and `ui-ux-pro-max`
High) but Socket/Snyk were clean; skills run with full agent permissions, so
review before heavy use.

| Skill | Purpose |
| --- | --- |
| `emil-design-eng` | Emil Kowalski's UI polish, component design, animation philosophy |
| `impeccable` | Frontend UI/UX design, redesign, critique, accessibility, motion |
| `ui-ux-pro-max` | Comprehensive UI/UX design skill |
| `ckm-banner-design` | Banner/creative asset design |
| `ckm-brand` | Brand voice, visual identity, messaging |
| `ckm-design` | General design |
| `ckm-design-system` | Design system/tokens |
| `ckm-slides` | HTML presentations with Chart.js |
| `ckm-ui-styling` | UI styling |

> Reminder: the UI source of truth is
> `docs/ui-reference/potoos_mobile_ui.html`. Do not redesign the UI unless
> explicitly asked — use design skills for analysis/critique, not unrequested
> redesigns.

## Global Skills (`~/.claude/skills`)

Available in every project on this machine.

**Superpowers (engineering workflow):**
`superpowers-brainstorming`, `superpowers-writing-plans`,
`superpowers-writing-skills`, `superpowers-executing-plans`,
`superpowers-subagent-driven-development`,
`superpowers-dispatching-parallel-agents`,
`superpowers-test-driven-development`, `superpowers-systematic-debugging`,
`superpowers-requesting-code-review`, `superpowers-receiving-code-review`,
`superpowers-verification-before-completion`,
`superpowers-using-git-worktrees`, `superpowers-finishing-a-development-branch`,
`superpowers-using-superpowers`.

**Ralph (PRD workflow):** `ralph-prd`, `ralph-ralph`.

**Design:** `ui-ux-pro-max` (also installed globally).

## Installing More

Skills are installed with the `skills` CLI, e.g.:

```powershell
npx skills add <owner>/<repo>
```

Project installs land in `.agents/skills/` and are symlinked for Claude Code.
Review any new skill's contents before use — they run with full permissions.
