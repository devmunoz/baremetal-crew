# Repository Guidelines

## Project Overview
This repository contains the source code, CLI utilities, core knowledge base, and primary skill definitions for the **Baremetal-Crew (BMC) framework**. The purpose of this repository is to develop, test, and maintain the framework itself—including the installer (`install.sh`), CLI binaries (`bin/bmc-log`, `bin/bmc-config`, `bin/bmc-index-skills`), primary crew role skills (`crew/`), and governance standards (`knowledge/`).

---

## Architecture & Data Flow
The framework codebase consists of four major functional components:
1. **Installer Engine (`install.sh`)**: Deploys the framework sandbox (`.bmc-stuff/`) and skill directories (`.agents/skills/`) to target project repositories. Supports flags (`-i`, `-y`, `-h`, `--runtime`, `--worktrees`, `--max-ping-pong`, `--communication`), environment overrides (`BMC_INDEX_SKILLS`, `BMC_RUNTIME`), standalone tarball retrieval, configuration initialization (`.bmc-stuff/config.json`), and automated AGENTS.md merging.
2. **Centralized Database CLI Helper (`bin/bmc-log`)**: A lightweight Python 3 script that manages `.bmc-stuff/crew.db` (tables: `transitions`, `tasks`, `events`). Acts as the single authorized database interface.
3. **Framework Configuration CLI Helper (`bin/bmc-config`)**: A Python 3 script that manages `.bmc-stuff/config.json` (subcommands: `get`, `set`, `show`, `init`). Provides typed access to runtime, worktree, and communication settings.
4. **Skills Indexer & Local Synchronizer (`bin/bmc-index-skills`)**: A Python 3 script that reads `knowledge/skills-catalog.json`, clones pre-approved external repositories into `.bmc-stuff/skills-cache/`, builds `skills-index.json`, and synchronizes matching skills into `.agents/skills/`.
5. **Knowledge Base & Primary Crew Skills (`knowledge/`, `crew/`)**: Centralized specifications (`MANIFESTO.md`, `guardrails.md`, `principles.md`, `tech.md`, `templates/`) and primary role skills (`product-owner`, `software-architect`, `fullstack-developer`, `qa-engineer`, `tech-guru`).

---

## Key Directories
- `bin/`: Executable CLI tools (`bmc-log`, `bmc-config`, `bmc-index-skills`).
- `crew/`: Primary crew role skill definitions (`product-owner`, `software-architect`, `fullstack-developer`, `qa-engineer`, `tech-guru`).
- `knowledge/`: Core framework knowledge base, system guardrails, principles, technology standards, pre-approved skills catalog (`skills-catalog.json`), and reference templates (`templates/`).
- `.agents/skills/`: Local skill definitions installed in this workspace.
- `.github/workflows/`: GitHub Actions workflows (`release-package.yml` for automated release tarball packaging).

---

## Development & Testing Commands

### Testing Framework Changes
When testing changes to `install.sh`, `bmc-log`, `bmc-config`, or `bmc-index-skills`, agents **MUST** execute test runs inside a temporary directory (e.g. `/tmp/bmc-test-env`) to prevent dirtying the repository root:

```bash
# 1. Create a clean temporary directory and run the installer
mkdir -p /tmp/bmc-test-env && ./install.sh /tmp/bmc-test-env -y

# 2. Test CLI commands inside the temporary sandbox
cd /tmp/bmc-test-env
./.bmc-stuff/bin/bmc-log cbo-sign S01
./.bmc-stuff/bin/bmc-log show-slice S01
./.bmc-stuff/bin/bmc-log active
./.bmc-stuff/bin/bmc-config show

# 3. Clean up the temporary directory after verification
rm -rf /tmp/bmc-test-env
```

### Skills Indexing & Local Synchronization
```bash
# Index catalog and update matching skills in .agents/skills/
./bin/bmc-index-skills --update-local

# Check for available skill updates without modifying disk
./bin/bmc-index-skills --check
```

### Framework Release Packaging
Releases are automated via GitHub Actions (`.github/workflows/release-package.yml`). Pushing a git tag matching `v*` (e.g. `v0.1.0`) triggers a workflow that packages `bin/`, `knowledge/`, `crew/`, and `install.sh` into `baremetal-crew.tar.gz` and publishes a GitHub Release.

---

## Mandatory Skills for Working on This Repository
When pair-programming or executing tasks in **this repository**, AI agents MUST load and adhere to the following default skills:

1. **`git-guardrails` (`.agents/skills/git-guardrails/SKILL.md`)** - **MANDATORY**:
   - Absolute prohibition of destructive git commands (`git push`, `reset --hard`, `clean -fd`, `branch -D`, `checkout .`, `restore .`, `rebase`, `stash drop/clear/pop`).
   - When a destructive action is required, HALT immediately, display the exact CLI command, delegate execution to the human user, and wait for confirmation.

2. **`asd-ste100-skill` (`.agents/skills/asd-ste100-skill/SKILL.md`)** - **MANDATORY**:
   - All responses, commit messages, documentation edits, instructions, and PR summaries MUST strictly follow ASD-STE100 (Simplified Technical English): active voice, simple tenses, short sentences (≤20 words for instructions, ≤25 for descriptions), and explicit terms.

3. **`grilling` / `grill-me` (`.agents/skills/grilling/SKILL.md`)** - **MANDATORY**:
   - Required questioning methodology whenever there are design choices, scope ambiguities, or architectural decisions to resolve in this repository.
   - Construct a design tree, ask unblocked frontier questions directly with structured recommendations, and eliminate uncertainty before changing code.

4. **`caveman` (`.agents/skills/caveman/SKILL.md`)** - **OPTIONAL**:
   - Indexed optional skill suggestion. Available if the user explicitly requests ultra-compressed communication, but inactive by default.

---

## Code Conventions & Common Patterns

### Commit Formatting
Commits must follow Conventional Commits: `<type>[optional scope]: <description>`
*Examples*: `feat(cli): add transition history to show-slice`, `fix(docs): enforce strict Completed status`

### Artifact Token Optimization Standard
- When creating or modifying files in this repo, agents MUST NEVER print or duplicate full file contents in the chat.
- Output ONLY: (1) exact file path, (2) 1–3 sentence ASD-STE100 summary, and (3) direct next actions or instructions.

### Framework Binary Protection
- Helper scripts under `bin/` or `.bmc-stuff/bin/` (`bmc-log`, `bmc-config`, `bmc-index-skills`) are immutable framework executables.
- Agents must never modify binary scripts to bypass governance or fake behavior.

### Centralized DB Access Only
- All database operations on `.bmc-stuff/crew.db` must run strictly through `bmc-log`. Direct shell `sqlite3` execution is strictly prohibited.

### Single Source of Truth
- Primary crew skill definitions reside in `crew/`. Core guidelines reside in `knowledge/`.
- Never edit `.agents/skills/` directly for crew skills; update `crew/` and run `./bin/bmc-index-skills --update-local` to synchronize.

---

## Important Files
- `install.sh`: Framework installation and deployment script.
- `bin/bmc-log`: SQLite database helper CLI executable.
- `bin/bmc-config`: Framework configuration manager CLI executable.
- `bin/bmc-index-skills`: Skills catalog indexer and local synchronizer CLI executable.
- `knowledge/MANIFESTO.md`: Core framework manifesto and specifications.
- `knowledge/guardrails.md`: System execution limits, security rules, and dangerous commands catalog.
- `knowledge/principles.md`: Framework process principles and operational minimalism.
- `knowledge/tech.md`: Technical standards and living documentation rules.
- `knowledge/skills-catalog.json`: Pre-approved skill repositories index catalog.

---

## Runtime & Tooling Preferences
- **Runtime Stack**: POSIX Bash shell + Python 3 standard library (lightweight, zero external npm/pip package dependencies required for framework execution).
- **Git Staging**: Explicit file staging (`git add <file>`). Wildcard staging (`git add .`) is strictly prohibited.
