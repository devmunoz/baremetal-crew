# SYSTEM GUARDRAILS

This document defines the strict guardrails and execution limits for the Baremetal-Crew. These rules are inviolable.

---

## 1. Human (CBO) Guardrails
*   **No Code Modifications:** The CBO (Human) is strictly forbidden from directly editing code during the cycle. All code changes must go through the DEV/QA cycle for full traceability.
*   **Irrevocable Scope:** Once Phase 1 is locked and `.bmc-stuff/SCOPE.md` is signed, the CBO cannot request new features or changes. If requested, the cycle must be aborted.

## 2. PO & SA Guardrails (Don't Execute)
*   **No Business Code:** The Product Owner (PO) and Software Architect (SA) must never write business logic or application code.
*   **No UI/CSS Hacks:** The PO/SA cannot make UI modifications or styling edits.
*   **No Code Modifications on Completed Slices:** Under no circumstances may the SA perform direct code adjustments or implement fixes (even if requested by the CBO on an already completed slice). Any change or adjustment to a completed slice must follow the formal sequence: PO drafts scope (Phase 1) -> SA breaks down backlog (Phase 2) -> Dev/QA executes (Phase 3).
*   **No Scope, No Action:** If no signed and frozen `.bmc-stuff/work/SXX-SCOPE.md` is in place for the active slice, the SA must halt execution immediately, inform the CBO of the lack of active definitions, and stop. The SA must never modify, create, initialize, or propose any setup plans for files (such as `AGENTS.md`, `DESIGN.md`, or `ARCHITECTURE.md`) without a signed scope.

## 3. Engineering Squad Guardrails
*   **Stop-the-Line on Ambiguity:** Developers and QAs must immediately halt execution on any task containing functional or technical ambiguity. They must set the task to `Blocked` and report it to the SA.
*   **No Code Without Tests:** No code changes may be marked completed without matching unit/integration tests (Dev) and E2E tests (QA).
*   **No placeholders or TODOs:** The SA must reject any code containing "TODO" comments, placeholder functions, mock files, or incomplete sections.

## 4. Ping-Pong Limit (Max 3 Retries)
*   A task can bounce between Dev and QA a maximum of 3 times to correct bugs. On the 3rd rejection by QA, the task is locked as `Blocked` and escalated to the SA.

## 5. Advisory Gurus
*   External Guru agents can only generate technical reports in Markdown. They must never write code or directly modify the repository.

## 6. Centralized Database Guardrail
*   All crew agents must write to and read (query) from the local SQLite database (`.bmc-stuff/crew.db`) strictly using the CLI database script helper (`.bmc-stuff/bin/bmc-log`). Direct/raw SQL connections, queries, or inserts in agent prompts/actions are strictly forbidden.

## 7. Security, Secret Management & Git Staging Guardrails
*   **No Leaks:** Never commit credentials, local system paths, API keys, certificates, or SQLite databases to git. Use environment files (`.env`) for local runtime secrets and create `.env.example` templates if modifications are made.
*   **Git Staging & Ignored Files Protection:** Under no circumstances attempt to stage or commit gitignored files (such as SQLite databases like `.bmc-stuff/crew.db`, local environment files, cache directories, or build artifacts). Agents must verify `.gitignore` or use `git check-ignore <path>` before staging. Always use explicit file staging (`git add <file>`) rather than wildcard staging (`git add .`).

## 8. Development Guardrails (Minimalism & Scope)
### Simplicity First
*   **Minimum Code:** Write only the code required to fulfill the active task criteria. Avoid speculative features, early optimizations, or abstractions for single-use code.
*   **Complexity Check:** Keep implementations minimal and clean. If a solution can be written in a significantly shorter/simpler manner, it must be rewritten.

### Surgical Changes
*   **Scope Limit:** Touch only the files and lines necessary for the task. Refactoring or reformatting unrelated adjacent code is strictly prohibited.
*   **Clean Orphans:** Remove unused imports, variables, or functions created by your changes. Do not clean up pre-existing dead code in unrelated modules unless explicitly requested in the task.

## 9. Host System Protection & Infrastructure Verification
*   **Absolute Host Installation Ban:** Under no circumstances may any crew agent execute commands that download or install system-level packages, libraries, or binaries directly onto the host machine. All external system dependencies must either be containerized (Docker) or flagged to the CBO (Human) for manual host installation. Rigid slice planning is designed to prevent technical omissions, eliminating any need to run local system installations mid-execution.
*   **Network Download Restraints:** Running `curl`, `wget`, or any web fetching utility to download and install OS packages, external installers, raw binaries, or to execute piping scripts (e.g., `curl ... | bash` or `wget -O- ... | sh`) is strictly forbidden.
    *   *Permitted Exception:* Agents are allowed to use `curl` or `wget` targeting loopback addresses (e.g., `localhost`, `127.0.0.1`, `[::1]`) for testing local server APIs or checking service health.
*   **Infrastructure Check Gate:** The SA must check for the presence and active status of all required infrastructure (e.g., verifying if Docker is installed and running via `docker info` or similar commands) before finalizing the blueprint. If required infrastructure or external host-level commands (e.g., `ffmpeg`) are missing, the SA must halt execution and coordinate with the CBO to resolve it.
*   **Dangerous & Restricted Commands Catalog:** The following commands must never be executed directly on the host shell by crew agents:
    1.  **OS Package Installers:** `brew install`, `apt`, `apt-get`, `yum`, `dnf`, `apk`, `pkg`, `pacman`.
    2.  **Script Piping Execution:** `curl ... | bash`, `wget -O- ... | sh`, `curl ... | sh`, `wget ... -O - | bash`.
    3.  **Global Dependency Pollution:** `npm install -g`, `npm i -g`, `pip install --global`, `gem install` (any global package manager commands).
    4.  **Privilege Escalation:** `sudo`, `su`, or executing commands inside root-only system paths.
    5.  **System Service Manipulation:** `systemctl`, `service`, `initctl` (use docker-compose for service orchestration instead).
    6.  **Host Permission Modifications:** `chown` or `chmod` targeting paths outside the local project workspace.

## 10. Communication Headers & Validation Gates
*   **Standardized Agent Headers:** Every response generated by any crew agent (PO, SA, Dev, QA, Tech Guru) must start with a standardized Markdown block:
    ```markdown
    **[ROLE: <Role Name>]**
    **[SLICE: <Slice ID> / None] | [PHASE: <Phase Name> / Idle]**
    ```
    This identifies the executing role and slice state at first glance for the CBO.
*   **Validation Bug Approval Gate:** If validation fails (`Validation Failed / Bug Found`), the SA must draft the required `[BUG-VALIDATION]` tasks in the blueprint. The SA must never hand these tasks to the developers until the CBO has reviewed the proposed fixes/tasks and explicitly approved them.
*   **Single Target Slice per Session:** Multiple slices may be active or incomplete in the project database/workspace (provided they have no unresolved dependencies between them). However, a single conversation thread, session, or crew iteration must *never* process, reference, plan, or execute more than one slice ID. The target slice ID for the session must be resolved at the start, and all other slices must be completely ignored during that session to prevent context mixing and parallel file updates.
*   **Root Documentation Isolation & Slice-Agnostic Code/Docs:** The repository root documentation files (`DESIGN.md`, `ARCHITECTURE.md`, `README.md`) must only reflect the *current, validated codebase*. They must never be updated with speculative or future designs of unreleased slices. Furthermore, root documentation and production source code MUST be strictly slice-agnostic. Slicing is purely a management framework mechanism. Never include slice IDs (e.g. `S01`, `S02`, `SXX`) or slice management references in root documentation files, source code, or inline comments. The SA must document all slice-specific proposals inside `.bmc-stuff/work/SXX-BLUEPRINT.md`.

## 11. Environment & Demo Validation Guardrails
*   **Strict Execution Consistency:** Never mix local host execution commands with containerized Docker commands in `SXX-DEMO.md`. If Docker is used for the project/slice, ALL commands in `SXX-DEMO.md` must execute strictly inside or via Docker (`docker compose ...`).
*   **Mandatory Fresh Container Build:** All containerized `SXX-DEMO.md` instructions must explicitly include fresh build steps (`docker compose build --no-cache` or `docker compose up --build`) to guarantee newly compiled binaries, TUI components, or updated dependencies are built into the image layer before validation.
*   **Container Path & Mount Precision:** Container volume paths (e.g. `/music` vs `music`), slashes, and working directory targets must be explicitly verified and matched against `docker-compose.yml` mounts before outputting DEMO instructions.
*   **QA Environment Build Verification:** QA Engineer and SA must verify that the codebase builds cleanly in the target container environment (`docker compose build`) and that containerized entry points execute without path/binary errors before marking tasks `QA Passed` or generating `SXX-DEMO.md`.

## 12. Autonomous Subagent Execution & Skill Binding
*   **Proactive SA Subagent Orchestration:** Upon CBO sign-off/approval of `.bmc-stuff/work/SXX-BLUEPRINT.md`, the SA acts as the proactive autonomous orchestrator for Phase 3. The SA must immediately spawn subagents for independent tasks and manage task progression to completion without halting or waiting for manual human prompts between individual tasks.
*   **Subagent Skill File Binding:** When spawning developer or QA subagents via `invoke_subagent`, the SA must explicitly bind the subagent to its crew role skill by instructing the subagent in its `Prompt` to read `.agents/skills/<role>/SKILL.md` using `view_file` and execute its designated workflow. Subagents must never be launched without explicit skill binding instructions.




