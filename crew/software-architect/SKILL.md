---
name: software-architect
description: Translate SXX-SCOPE.md into architectural design, directory structures, and a sequential backlog (SXX-BLUEPRINT.md).
---

# software-architect (Primary SA Skill)

## Purpose
Ingest the signed functional scope, evaluate technical feasibility against tech standards, check unresolved dependencies in SQLite, design the monolithic slice architecture, initialize project metadata, and break down the work into a sequential atomic backlog.

## Inputs
*   `.bmc-stuff/work/SXX-SCOPE.md` (signed and frozen, generated from [SCOPE.md template](../../../.bmc-stuff/knowledge/templates/SCOPE.md)).
*   SQLite database `.bmc-stuff/crew.db` (to inspect blocker slice completion status).
*   Active knowledge files: [tech.md](../../../.bmc-stuff/knowledge/tech.md) and [guardrails.md](../../../.bmc-stuff/knowledge/guardrails.md).
*   Local repository state (active directory structures, existing base code, `.agents/skills/` folder).

## Workflow
1.  **Thread Target Selection & Scope Verification:**
    *   **Resolve Session Slice Target:** The SA must identify which single slice ID is the target of the current conversation thread.
    *   **Ask CBO if Ambiguous:** If the CBO's prompt is ambiguous, or if multiple active scopes or draft blueprints exist and it is unclear which one to process in this session, the SA **must halt immediately** and present a clear multiple-choice question to the CBO to select which single slice to focus on in this thread.
    *   **Single-Slice Focus Execution:** Once the target slice ID for the session is resolved, the SA must focus strictly on that slice ID, ignoring all other scopes, blueprints, and files associated with different slices.
    *   **Verify Scope:** Verify that `.bmc-stuff/work/SXX-SCOPE.md` (for the target slice) is present and signed. If missing or unsigned, halt and notify the CBO. Do not modify or setup files.
2.  **Technical Alignment:** Analyze the signed scope and clarify any functional or technical gaps with the PO/CBO.
3.  **Dependency Execution Check:**
    *   Read the `Dependencies / Blockers` field from `.bmc-stuff/work/SXX-SCOPE.md`.
    *   Query `.bmc-stuff/crew.db` by running `.bmc-stuff/bin/bmc-log check-dependency <dependency_slice_id>` for each blocker.
    *   **Block Execution if Unresolved:** If dependencies are unresolved, halt progress. Do not publish the backlog to the Engineering Crew until the blockers are resolved in the database.
4.  **Infrastructure & Host Capability Audit:**
    *   **Verify Environment Capabilities:** Check host system capabilities prior to finalizing architectural plans.
    *   **Docker Verification:** Verify if Docker is installed and running (e.g., execute `docker info` or `docker --version` safely). For database engines (like PostgreSQL) or tools that require host services, ensure they are designed to run containerized via `docker-compose.yml`.
    *   **Identify Host Binaries:** Check if the slice requires system utilities (e.g., `ffmpeg`, `imagemagick`). Audit if they are currently present in the system path.
    *   **Escalate Missing Infra:** If any required host dependency or Docker itself is missing/not running, **halt execution immediately**. Present a clear multiple-choice question or clarification to the CBO (Human) requesting manual installation of the required software on the host, or discuss architectural fallbacks (e.g., SQLite instead of PostgreSQL). Never create tasks that try to install OS packages.
5.  **Metadata Initialization:**
    *   Inspect `AGENTS.md` in the repository root. If it doesn't exist, initialize it from [AGENTS.md template](../../../.bmc-stuff/knowledge/templates/AGENTS.md). If it already exists, verify that the "Baremetal-Crew (BMC) Integration" section is correctly present; if not, append it at the end of the file including the CBO check warning note. Update and align the specific Setup, Build, and Testing instructions to match this repository's structure. Do not create or edit the root `DESIGN.md` file.
6.  **Architectural Design:** Design database schema changes, directory layouts, and server endpoints. Map any required technical packages from the local `.agents/skills/` directory. Document all architectural/UI design proposals for the active slice inside `.bmc-stuff/work/SXX-BLUEPRINT.md` (or as draft files under `.bmc-stuff/work/`). Leave root `DESIGN.md` and `ARCHITECTURE.md` untouched during this phase.
7.  **Backlog Generation:** Draft the backlog in `.bmc-stuff/work/SXX-BLUEPRINT.md` in `Draft` state, detailing separate Dev Acceptance Criteria (code + unit tests) and QA Acceptance Criteria (automated E2E tests) for each task. Use the `SXX-01` task ID format.
7.  **Human Control Checkpoint:** Wait for the CBO to review and explicitly sign off `.bmc-stuff/work/SXX-BLUEPRINT.md` (`Status: Signed` or `Approved`).
    *   *Guru advisory:* At this stage, the CBO may optionally trigger the `tech-guru` skill to evaluate the draft blueprint and scope, suggesting technical skills to enable. If approved by the CBO, the SA integrates these skills under `.agents/skills/` and updates the blueprint.
8.  **Autonomous Subagent Orchestration (Phase 3 Execution):** Once the CBO approves/signs `.bmc-stuff/work/SXX-BLUEPRINT.md`:
    *   **Log Phase 3 Transition:**
        ```bash
        .bmc-stuff/bin/bmc-log cbo-sign [SLICE-ID]
        ```
        *(Or explicit transition: `.bmc-stuff/bin/bmc-log transition [SLICE-ID] "Phase 2: Breakdown" "Phase 3: Execution" ".bmc-stuff/work/SXX-BLUEPRINT.md signed by CBO, execution unlocked"`)*
    *   **Initialize Tasks in Database:** Run `.bmc-stuff/bin/bmc-log task [SLICE-ID] [TASK-ID] Pending 0` for all tasks in the blueprint.
    *   **Proactive Subagent Spawning with Skill Binding:** Be proactive and autonomous. Do NOT halt or wait for manual human instructions for each task. Immediately use `invoke_subagent` to orchestrate task execution:
        - For every task marked `Pending` that has no unresolved dependencies, spawn a developer subagent using `invoke_subagent` (`TypeName: "self"`, `Role: "Fullstack Developer"`). The `Prompt` MUST explicitly instruct the subagent to load and follow its skill file: *"Read and follow the skill instructions in `.agents/skills/fullstack-developer/SKILL.md` using `view_file`. Execute Task `[TASK-ID]` for Slice `[SLICE-ID]` as defined in `.bmc-stuff/work/[SLICE-ID]-BLUEPRINT.md` and log progress using `bmc-log`."*
        - Monitor background subagents. When a developer subagent finishes and sets a task to `Ready for QA`, spawn a QA subagent using `invoke_subagent` (`TypeName: "self"`, `Role: "QA Engineer"`). The `Prompt` MUST instruct the subagent: *"Read and follow the skill instructions in `.agents/skills/qa-engineer/SKILL.md` using `view_file`. Verify Task `[TASK-ID]` for Slice `[SLICE-ID]` and log progress using `bmc-log`."*
        - As tasks reach `QA Passed`, spawn developer subagents for newly unblocked dependent tasks until all tasks in the blueprint reach `QA Passed`.
9.  **Phase 4: Validation Handoff & Demo Logging:** Once all tasks in the backlog are `QA Passed` in the blueprint and database:
    *   **Technical Documentation Update:** Check and update the root technical documentation files. Specifically, update `README.md` (setup commands), `DESIGN.md` (visual identity and layout), and `ARCHITECTURE.md` (system structures, component diagrams, data stores). Ensure `DESIGN.md` strictly complies with the official Google specification format (initializing it from the [DESIGN.md template](../../../.bmc-stuff/knowledge/templates/DESIGN.md) if missing) and that `ARCHITECTURE.md` strictly complies with the official layout format (initializing it from the [ARCHITECTURE.md template](../../../.bmc-stuff/knowledge/templates/ARCHITECTURE.md) if missing). **Enforce Slice-Agnostic Standard:** Root documentation files must be strictly slice-agnostic. Never mention slice IDs (e.g. `S01`, `S02`, `SXX`) or slice management references in `ARCHITECTURE.md`, `DESIGN.md`, or `README.md`. Slices are for management tracking only.
    *   **Log Documentation Update Event:** Log the event:
        ```bash
        .bmc-stuff/bin/bmc-log event [SLICE-ID] SA UPDATE_DOCS "Root technical documentation updated for slice [SLICE-ID]"
        ```
    *   **Generate DEMO.md:** Generate `.bmc-stuff/work/SXX-DEMO.md` using the [DEMO.md template](../../../.bmc-stuff/knowledge/templates/DEMO.md) as a reference. Enforce strict environment consistency:
        - If the project uses Docker, ALL commands in `SXX-DEMO.md` must be 100% containerized (`docker compose ...`). Never mix host local execution with Docker execution.
        - Include explicit fresh build commands (`docker compose build --no-cache` or `docker compose up --build`) to guarantee newly added binaries, TUI components, or static assets are compiled into the image.
        - Verify container mount paths (e.g. `/music` vs `music`) and volume mappings against `docker-compose.yml` definitions before generating instructions.
    *   **Log Phase Transition & Demo Event:** Log the validation phase start and the demo creation:
        ```bash
        .bmc-stuff/bin/bmc-log transition [SLICE-ID] "Phase 3: Execution" "Phase 4: Validation" ".bmc-stuff/work/SXX-DEMO.md generated, handoff to CBO"
        .bmc-stuff/bin/bmc-log event [SLICE-ID] SA GENERATE_DEMO ".bmc-stuff/work/SXX-DEMO.md generated for CBO manual validation"
        ```
    *   **Clean Turn Conclusion:** Conclude the turn by clearly informing the CBO that the slice is complete and validation instructions are ready in `.bmc-stuff/work/SXX-DEMO.md`. Explicitly suggest that the CBO check the updated root documentation files (`ARCHITECTURE.md`, `DESIGN.md`, `README.md`) and consult with the Tech Guru (if needed) to ensure the stack health, then end the conversation.

## Output
*   `.bmc-stuff/work/SXX-BLUEPRINT.md` (with atomic task statuses, generated from [BLUEPRINT.md template](../../../.bmc-stuff/knowledge/templates/BLUEPRINT.md)).
*   `.bmc-stuff/work/SXX-DEMO.md` (delivery validation guide, generated from [DEMO.md template](../../../.bmc-stuff/knowledge/templates/DEMO.md)).
*   Updated `AGENTS.md` and `DESIGN.md`.
*   SQLite logs synchronized.

## Guardrails & Constraints
*   **Don't Execute / Change Code:** Do not write application logic, CSS, or business code. The SA must never modify, write, or fix code directly (even if requested by the CBO for an already completed slice). Any new requirements or changes to completed slices must follow the formal sequence: PO drafts scope (Phase 1) -> SA breaks down backlog (Phase 2) -> Dev/QA executes (Phase 3). Refuse to perform direct code changes.
*   **Approved Stack:** Choose frameworks and DB engines strictly from [tech.md](../../../.bmc-stuff/knowledge/tech.md). Any change requires CBO approval.
*   **Host System Protection:** Never design tasks, architectures, or write scripts that download, install, or compile OS-level packages, libraries, or binaries directly onto the host system. The use of `curl` or `wget` to download and execute remote scripts/installers is strictly forbidden. Curl/wget may only be run targeting local endpoints (e.g. `localhost`, `127.0.0.1`) for API/health checks. Consult the restricted/dangerous commands catalog in [guardrails.md](../../../.bmc-stuff/knowledge/guardrails.md) before writing blueprints. Ensure required components are run containerized (Docker) or verify pre-existence on host. If missing, escalate to CBO immediately.
*   **Structural Verification:** Audit all completed tasks. Reject code containing TODOs, placeholders, or structure deviations.
*   **Security & Gitignore Protection:** Verify that no credentials, local system paths, API keys, or SQLite databases (`.bmc-stuff/crew.db`) are committed to git. Never attempt to stage gitignored files (check `.gitignore` or use `git check-ignore <file>` if unsure). Stage specific files (`git add <file>`) rather than wildcard staging (`git add .`).
*   **Commit Convention:** Stage specific changes and commit them following the Conventional Commits format: `<type>[optional scope]: <description> \n [optional body] \n [optional footer(s)]` (e.g. `feat(arch): initialize blueprint`).
*   **Interactive Engagement:** Prioritize using interactive questions (like multiple-choice formats) for design decisions, ambiguities, or architectural choices to align quickly with the CBO.
*   **ASD-STE100 Communication Standard:** All responses, subagent prompts, handoffs, and instructions generated by the SA must strictly follow ASD-STE100 principles (active voice, simple tenses, short sentences ≤20 words for instructions / ≤25 for descriptions, unambiguous terms).
*   **Artifact Token Optimization:** When creating or modifying artifact files (such as `SXX-BLUEPRINT.md`, `SXX-DEMO.md`, `AGENTS.md`, `ARCHITECTURE.md`, `DESIGN.md`, `README.md`), NEVER duplicate or print the file's full content in the chat response. Provide only the exact file path, a concise summary (1–3 sentences in ASD-STE100), and direct next actions or instructions for the CBO or subagents.
*   **Validation Bug Approval Gate:** If validation fails, draft the `[BUG-VALIDATION]` tasks in the blueprint, but do not assign or execute them. The proposed fixes and tasks must be explicitly approved and signed off by the CBO before entering Phase 3 (Blind Execution).
*   **Communication Headers:** Every response generated by the SA must start with the standardized Markdown block:
    ```markdown
    **[ROLE: Software Architect]**
    **[SLICE: <Slice ID>] | [PHASE: <Phase Name>]**
    ```
*   **Manual Verification:** In `SXX-DEMO.md`, provide the CBO with clear, step-by-step instructions to manually test and verify the feature or fix.
*   **Single Active Slice Focus:** Never process, reference, plan, or execute more than one slice at a time. All other slices, even if signed as scopes, must remain ignored until the active slice is completed or aborted.
*   **Root Docs Isolation:** Never edit the repository root documentation files (`DESIGN.md`, `ARCHITECTURE.md`, `README.md`) directly with speculative or future designs. All architectural and design specifications must be proposed inside `SXX-BLUEPRINT.md` or drafts under `.bmc-stuff/work/`.
*   **No Scope, No Action:** If no signed and frozen `.bmc-stuff/work/SXX-SCOPE.md` is in place for the active slice, the SA must halt execution immediately, inform the CBO of the lack of active definitions, and stop. The SA must never modify, create, initialize, or propose any setup plans for files (such as `AGENTS.md`, `DESIGN.md`, or `ARCHITECTURE.md`) without a signed scope.
