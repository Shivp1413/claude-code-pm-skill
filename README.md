<p align="center">
  <img src="assets/logo.png" alt="Claude Code PM Octopus Mascot" width="220" style="border-radius: 20px;" />
</p>

<h1 align="center">⚡ Claude Code Project Manager (PM) Skill</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://code.claude.com"><img src="https://img.shields.io/badge/Claude%20Code-Skill%20%26%20Agents-7c3aed.svg" alt="Claude Code"></a>
  <a href="https://github.com/Shivp1413"><img src="https://img.shields.io/badge/Author-Shivp1413-black.svg" alt="Author"></a>
</p>

<p align="center">
  <strong>Transform Claude Code into an executive Project Manager.</strong><br />
  Keep your main session context lean, eliminate token bloat, delegate heavy coding and deep analysis to subagents, and get concise, high-signal updates without chat flooding.
</p>

---

## 🎯 The Idea

In standard Claude Code sessions, reading files, searching large codebases, and editing code directly inside the main chat quickly burns 30,000+ tokens and fills the screen with walls of text, leading to early context compaction.

**This skill flips the architecture:**
- The main agent acts strictly as a **Project Manager (PM)**.
- **PM never writes code directly** and **never performs token-heavy deep analysis** in the main session.
- PM spawns isolated **subagents** (`analyst`, `coder`, `tester`, `reviewer`) via Claude Code's `Task` tool.
- Subagents execute in their own isolated context windows and return concise summaries.
- The PM communicates with you in **short, concise micro-updates (3–6 lines max)** without repetitive boilerplate.

---

## 📦 Repository Structure

```
.
├── .claude/
│   ├── agents/
│   │   ├── analyst.md      # Research & exploration subagent (Read-only, zero main tokens)
│   │   ├── coder.md        # Code implementation & editing subagent
│   │   ├── reviewer.md     # Code review & security audit subagent
│   │   └── tester.md       # QA, test runner & validation subagent
│   └── skills/
│       └── pm/
│           └── SKILL.md    # Master PM skill prompt for Claude Code
├── assets/
│   └── logo.png            # Official repository mascot logo
├── install.sh              # 1-click installer (Global ~/.claude/ or Local ./.claude/)
├── LICENSE                 # MIT License
└── README.md               # Documentation
```

---

## ⚡ Quick Start

### 1. Installation

Clone this repo and run `install.sh`:

```bash
git clone https://github.com/Shivp1413/claude-code-pm-skill.git
cd claude-code-pm-skill
./install.sh --global
```

- `--global` (Recommended): Installs to `~/.claude/` — available in **any** directory and every new Claude Code session.
- `--local`: Installs to `./.claude/` in the current project only.

### 2. Using the Skill in Claude Code

Start a session:
```bash
claude
```

Call the skill in chat:
```text
/pm
```

Or pass a task directly:
```text
/pm "Add JWT authentication to the /api/v1/auth routes and write unit tests"
```

---

## 🤖 Subagent Roster

| Subagent | Role | Tools Allowed | Responsibility |
| :--- | :--- | :--- | :--- |
| **`analyst`** | Technical Researcher | `Read`, `Grep`, `Glob`, `Bash` | Deep exploration, search, and root-cause tracing without burning main chat tokens. |
| **`coder`** | Software Engineer | `Read`, `Edit`, `Write`, `Grep`, `Glob`, `Bash` | Scoped code edits, refactoring, and bug fixes. |
| **`tester`** | QA Automation Engineer | `Bash`, `Read`, `Grep`, `Glob` | Running test suites (`npm test`, `pytest`, etc.) and reporting pass/fail metrics. |
| **`reviewer`** | Security & Quality Auditor | `Read`, `Grep`, `Glob`, `Bash` | Inspecting git diffs and catching regressions before completion. |

---

## 💬 Communication Rules (Concise & Clean)

The PM agent adheres to strict brevity:
- **3–6 lines per update** maximum.
- **No conversational filler** or polite boilerplate.
- **No repeating previous status text** or repeating back user requests.
- Structured format:
  ```text
  🎯 Goal: <Brief objective>
  📋 Plan: [Analyst] -> [Coder] -> [Tester]
  ⚡ Action: Spawning Analyst subagent...
  ```
  ```text
  ✅ Completed: <Brief result in 1-2 lines>
  📁 Affected: <List of files>
  ⏭️ Next: Spawning Coder subagent...
  ```

---

## 📤 Push to GitHub

To push this repository to your GitHub account:

```bash
git remote add origin https://github.com/Shivp1413/claude-code-pm-skill.git
git push -u origin main
```

---

## 👤 Author

- **Shivp1413** — GitHub: [@Shivp1413](https://github.com/Shivp1413)
- License: [MIT](LICENSE) © 2026 Shivp1413
