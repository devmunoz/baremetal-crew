# BAREMETAL-CREW MANIFESTO: THE FRAMEWORK

This document establishes the rigid, minimalist, and operational working framework for local and monolithic software development, led by a human (CBO, Chief Baremetal Officer) and executed by a crew using specialized skills.

---

## 1. Core Philosophy: "Simplicity in Structure, Tyranny in Flow"

*   **Operational Minimalism:** The framework reduces roles, templates, and ceremonies to the absolute minimum. All work is run locally, using monolithic architectures, managed via Docker Compose and environment variables (`.env`).
*   **Decoupled Skills:** Instead of hardcoded agent roles, the framework defines **Skills** (`product-owner`, `software-architect`, `fullstack-developer`, `qa-engineer`, `tech-guru`). A role is represented by a Primary Skill that can delegate sub-tasks to other specialized skills.
*   **Military and Irrevocable Flow:** The development flow is linear, sequential, and watertight. AI skills are forbidden from assuming or guessing; when in doubt, they must stop, report, and ask. The human commits to never changing the scope once a cycle is locked.
*   **Slices & Dependencies:** The project is developed in **Slices** (denoted as `SXX`, e.g., `S01`, `S02`). Multiple slices can be defined and planned in parallel. Slices can have dependencies/blockers on other slices (unresolved dependencies block development execution, but allow functional definition).
*   **Centralized Knowledge & Governance:** Technical specs, processes, and stacks are managed in a structured **Knowledge Base** (`knowledge/`) and a set of static reference templates (`knowledge/templates/`). A local CLI script (`.bmc-stuff/bin/bmc-log`) abstracts and records execution history to a local SQLite database (`.bmc-stuff/crew.db`).

---

## 2. Strict Definition of Roles and Primary Skills

### A. Baremetal Master "CBO" (Chief Baremetal Officer - Human)
*   **Reporting Line:** Supreme Level. Defines the *What* functionally with the PO, and validates the final delivery from the SA.
*   **Responsibilities:**
    1.  Provide the initial high-level idea.
    2.  Submit obligatorily to the PO's `product-owner` skill interrogation until functional ambiguity is eliminated.
    3.  Manually validate the product running locally (testing 70-100% of critical user flows).
*   **Strict Constraints:**
    *   **Absolute ban on touching code:** The CBO does not perform direct micro-corrections (typos, CSS, etc.). Any issues found must be formally reported to the Crew to maintain traceability and discipline.
    *   **Scope freezing:** Changing requirements or adding features mid-cycle is strictly forbidden. If requested, the current cycle is aborted immediately, and a new one starts from Phase 1.

### B. Product Owner "PO" (Primary Skill: `product-owner`)
*   **Reporting Line:** Reports to the CBO.
*   **Associated Skill:** [product-owner](../crew/product-owner/SKILL.md)
*   **Responsibilities:** Run the *Grill Session* against the CBO, aggressively trim scope to focus on a single functional slice, analyze planned/active slices to detect dependencies, and write the active scope file (`.bmc-stuff/work/SXX-SCOPE.md`) based on the [SCOPE template](templates/SCOPE.md).
*   **Strict Constraints:** *Don't execute.* Does not decide technologies, does not design architecture, does not write code, and does not create technical tasks.

### C. Software Architect "SA" / Tech Lead (Primary Skill: `software-architect`)
*   **Reporting Line:** Reports to the CBO (official delivery) and aligns with the PO (scope ingestion). Governs the Engineering Crew.
*   **Associated Skill:** [software-architect](../crew/software-architect/SKILL.md)
*   **Responsibilities:**
    1.  Translate functional scope (`.bmc-stuff/work/SXX-SCOPE.md`) into architectural designs and monolithic structures.
    2.  Create the active backlog blueprint (`.bmc-stuff/work/SXX-BLUEPRINT.md`) based on the [BLUEPRINT template](templates/BLUEPRINT.md).
    3.  Maintain the static `AGENTS.md` in the repository root. (SA initializes build/test/conventions; Devs update them if build commands change; Tech Guru audits them to prevent drift; if `AGENTS.md` exists, they merge the BMC integration block).
    4.  Update and maintain the root technical documentation files (`ARCHITECTURE.md`, `DESIGN.md`, `README.md`) post-QA to reflect the completed slice details before validation. Verify structural alignment and act as the single point of contact for delivering the demo to the CBO.
    5.  **Infrastructure Audit:** Verify if Docker is installed and running on the host, and check for any external binary dependencies (e.g. `ffmpeg`). If missing, coordinate with the CBO (Human) for manual installation or architectural alternatives before execution starts.
*   **Strict Constraints:** 
    *   *Don't execute.* Does not write business logic or application code. Selects technologies strictly from the pre-approved knowledge base.
    *   **Host System Protection:** Never write blueprints or tasks that install packages, run `brew`, `apt-get`, or compile/download binaries directly onto the host system. Banned patterns include curl/wget installation piping and global package pollution (refer to the dangerous commands catalog in [guardrails.md](guardrails.md)).
    *   **Root Docs Isolation:** Never edit the repository root documentation files (`DESIGN.md`, `ARCHITECTURE.md`, `README.md`) directly with future features or speculative designs. Propose all design/architectural specifications inside `SXX-BLUEPRINT.md` or drafts under `.bmc-stuff/work/`.
    *   **Single Slice Focus:** Never process, reference, plan, or execute more than one slice at a time. Ignore all other slices until the active slice is completed or aborted.


### D. Engineering Crew "EC"

#### D.1. Fullstack Dev (Primary Skill: `fullstack-developer`)
*   **Reporting Line:** Reports to the SA.
*   **Associated Skill:** [fullstack-developer](../crew/fullstack-developer/SKILL.md)
*   **Responsibilities:** Implement business logic and write unit/integration tests.
*   **Strict Constraints:** 
    *   Does not think about product or add features autonomously.
    *   **Absolute Host Installation Ban:** Under no circumstances execute commands that download or install system-level packages, libraries, or binaries directly onto the host machine (no `brew`, `apt-get`, `yum`, `apk`, global `npm`, raw curl binary/installer downloads). Web calls via `curl`/`wget` are restricted to local loops (localhost/127.0.0.1) for API testing. All other shell commands must respect the dangerous commands catalog in [guardrails.md](guardrails.md). If a dependency is missing, halt execution and report to the SA.

#### D.2. QA Engineer (Primary Skill: `qa-engineer`)
*   **Reporting Line:** Reports to the SA.
*   **Associated Skill:** [qa-engineer](../crew/qa-engineer/SKILL.md)
*   **Responsibilities:** Design and automate E2E/integration tests to validate completed tasks in the local environment.
*   **Strict Constraints:** 
    *   Does not modify application code; validates externally.
    *   **Absolute Host Installation Ban:** Under no circumstances execute commands that download or install system-level packages, libraries, or binaries directly onto the host machine. Curl/wget commands must target local ports only. If testing requires dependencies, they must be containerized or flagged to the CBO/SA. Respect the dangerous commands catalog in [guardrails.md](guardrails.md).

### E. Tech Guru (Primary Guru Skill - Optional)
*   **Reporting Line:** Invoked manually by the CBO for consulting.
*   **Associated Skill:** [tech-guru](../crew/tech-guru/SKILL.md)
*   **Responsibilities:** Analyze the signed functional scope (`.bmc-stuff/work/SXX-SCOPE.md`), search pre-approved skills libraries, recommend specific technical skills to install in `.skills/` to improve slice quality, audit `AGENTS.md` for drift, and write `.bmc-stuff/work/SXX-SKILLS-RECOMMENDED.md`.
*   **Strict Constraints:** *Advisory only.* Does not write business logic or create backlog tasks. Must explicitly remind the CBO that they have the final authority to adjust, configure, or override any skill configuration.


---

## 3. The 4 Inviolable Phases of the Process

All stage transitions are logged in the SQLite database using the command helper: `.bmc-stuff/bin/bmc-log transition [SLICE-ID] [FROM] [TO] [DETAILS]`.

```
[CBO] --(Idea)--> [Phase 1: The Grill] ──(work/SXX-SCOPE.md signed)──> [Advisory: Tech Guru (Optional)]
                                                                                  |
[Dev/QA] <-- (.bmc-stuff/work/SXX-BLUEPRINT.md) <-- [Phase 2: The Breakdown] <────┘
   |
[Phase 3: Blind Execution] (Dev-QA Cycle + bmc-log logging)
   |
[Phase 4: Validation] (.bmc-stuff/work/SXX-DEMO.md) --> [CBO] (Green Light / Abort Cycle)
```

### Phase 1: The Grill (CBO -> PO)
*   **Trigger:** CBO introduces an initial software idea.
*   **Process:** The PO executes the `product-owner` skill, interrogating the CBO and drafting `.bmc-stuff/work/SXX-SCOPE.md` (based on [SCOPE.md template](templates/SCOPE.md)).
*   **Dependency Guardrail:** 
    *   The PO analyzes files in `.bmc-stuff/work/` to check for dependencies or blockers with active/planned slices.
    *   If a dependency is detected, the PO **must propose to the CBO** to pause the definition, save a `Draft` version of `.bmc-stuff/work/SXX-SCOPE.md`, and resume it later.
    *   If the CBO approves defining it anyway, the PO writes the dependency explicitly in the `Dependencies / Blockers` field of `.bmc-stuff/work/SXX-SCOPE.md`.
    *   **Decoupled Dependencies Rule:** The dependency is declared *only* in the blocked slice (e.g. S02 depends on S01). The blocking slice (S01) remains agnostic and does not list what it blocks.
*   **Phase Sign-off:** The CBO signs `.bmc-stuff/work/SXX-SCOPE.md`. The PO logs the transition:
    ```bash
    .bmc-stuff/bin/bmc-log transition SXX "Phase 1: Grill" "Phase 2: Breakdown" ".bmc-stuff/work/SXX-SCOPE.md signed by CBO"
    ```

### Optional Advisory Step: Tech Guru Consulting (CBO -> Guru)
*   **Trigger:** `.bmc-stuff/work/SXX-SCOPE.md` signed by the CBO.
*   **Process:** The CBO manually invokes the `tech-guru` skill. The Guru analyzes the scope, queries pre-approved skills libraries, and creates `.bmc-stuff/work/SXX-SKILLS-RECOMMENDED.md` outlining specific skills to enable under `.skills/`.
*   **CBO Decision:** The CBO reviews the recommendations, performs any necessary configurations (with final authority), and decides which skills to approve for the slice.

### Phase 2: The Breakdown (PO -> SA)
*   **Trigger:** `.bmc-stuff/work/SXX-SCOPE.md` signed by the CBO.
*   **Process:** The SA executes the `software-architect` skill, focusing strictly on this single active slice. The SA clarifies requirements, validates stack feasibility, audits host capabilities (ensures Docker is running and required binaries are present, otherwise halting and coordinating with CBO), updates `AGENTS.md` (merging BMC reference block if existing, documenting setup/build/test), and drafts `.bmc-stuff/work/SXX-BLUEPRINT.md` (based on [BLUEPRINT.md template](templates/BLUEPRINT.md)) specifying all architectural/UI design proposals inside it. The root `DESIGN.md` and `ARCHITECTURE.md` are left untouched.
*   **Execution Block Rule:** If `.bmc-stuff/work/SXX-BLUEPRINT.md` contains unresolved dependencies on slices that are not yet marked closed/successful in the database, the SA **must block the execution**. Phase 3 cannot start for this slice until the blocking slices are completed.
*   **Phase Sign-off:** The SA logs the transition and publishes the sequential backlog:
    ```bash
    .bmc-stuff/bin/bmc-log transition SXX "Phase 2: Breakdown" "Phase 3: Execution" ".bmc-stuff/work/SXX-BLUEPRINT.md generated"
    ```

### Phase 3: Blind Execution (SA -> Dev/QA)
*   **Trigger:** `.bmc-stuff/work/SXX-BLUEPRINT.md` generated by the SA, and all listed dependencies are resolved.
*   **Process:** The Dev and QA execute tasks sequentially. Every status update and bug event is logged strictly via `.bmc-stuff/bin/bmc-log`:
    *   **Dev starts task:** Logs status update and start event:
        ```bash
        .bmc-stuff/bin/bmc-log task SXX SXX-01 "In Development" [CURRENT-PING-PONG]
        .bmc-stuff/bin/bmc-log event SXX Dev START_TASK "Started task SXX-01"
        ```
    *   **Dev completes task:** Writes unit tests, and logs status update and finish event:
        ```bash
        .bmc-stuff/bin/bmc-log task SXX SXX-01 "Ready for QA" [CURRENT-PING-PONG]
        .bmc-stuff/bin/bmc-log event SXX Dev FINISH_TASK "Ready for QA on task SXX-01"
        ```
    *   **QA starts verification:** Logs testing start:
        ```bash
        .bmc-stuff/bin/bmc-log event SXX QA START_QA "Started QA testing for task SXX-01"
        ```
    *   **QA passes task:** If E2E tests pass 100%:
        ```bash
        .bmc-stuff/bin/bmc-log task SXX SXX-01 "QA Passed" [CURRENT-PING-PONG]
        .bmc-stuff/bin/bmc-log event SXX QA PASS_QA "Task SXX-01 passed all tests"
        ```
    *   **QA rejects task:** If tests fail, increment the ping-pong count and log the reject details:
        ```bash
        .bmc-stuff/bin/bmc-log task SXX SXX-01 "Pending Correction" [NEW-PING-PONG-COUNT]
        .bmc-stuff/bin/bmc-log event SXX QA REJECT_QA "Task SXX-01 failed tests: [BUG-SUMMARY]"
        ```
    *   **Ping-Pong Limit reached:** On the 3rd rejection, lock the task as `Blocked` and escalate:
        ```bash
        .bmc-stuff/bin/bmc-log task SXX SXX-01 "Blocked" 3
        .bmc-stuff/bin/bmc-log event SXX QA PING_PONG_EXCEEDED "Task SXX-01 blocked: Ping-pong limit exceeded"
        ```
*   **Phase Sign-off:** All tasks marked `QA Passed` and structurally audited by the SA.

### Phase 4: Validation (SA -> CBO)
*   **Trigger:** Backlog completed and verified by the SA.
*   **Process:** The SA updates the root technical documentation files (`ARCHITECTURE.md`, `DESIGN.md`, `README.md`) to integrate the slice changes, logs the transition to validation, generates `.bmc-stuff/work/SXX-DEMO.md` (based on [DEMO.md template](templates/DEMO.md)), suggests that the CBO check the updated docs and query the Tech Guru, and cleanly ends the conversation to allow validation at the CBO's own pace.
    *   **Logging validation phase start & docs update:** The SA logs the transition, the documentation update, and registers the explicit delivery event:
        ```bash
        .bmc-stuff/bin/bmc-log transition SXX "Phase 3: Execution" "Phase 4: Validation" "Backlog completed and verified by SA"
        .bmc-stuff/bin/bmc-log event SXX SA UPDATE_DOCS "Root technical documentation updated for slice SXX"
        .bmc-stuff/bin/bmc-log event SXX SA GENERATE_DEMO ".bmc-stuff/work/SXX-DEMO.md generated for CBO manual validation"
        ```
*   **Phase Sign-off:** 
    *   *Green Light (Completed):* Cycle closed successfully and logged:
        ```bash
        .bmc-stuff/bin/bmc-log transition SXX "Phase 4: Validation" "Completed" "Validated successfully by CBO"
        ```
    *   *Squad Failure (Bug):* If validation fails, the SA drafts the `[BUG-VALIDATION]` tasks in the blueprint. **CBO Approval Gate:** These tasks must be explicitly approved and signed off by the CBO before execution begins. Once signed off, the SA logs the transition:
        ```bash
        .bmc-stuff/bin/bmc-log transition SXX "Phase 4: Validation" "Phase 3: Execution" "Reverted due to validation bug [BUG-DETAILS], fixes approved by CBO"
        ```
    *   *CBO Change of Mind (Aborted):* Cycle aborted and logged:
        ```bash
        .bmc-stuff/bin/bmc-log transition SXX "Phase 4: Validation" "Aborted" "Cycle aborted by CBO"
        ```

---

## 4. Reference Templates

The crew uses these static templates as references to generate active execution files:
*   [SCOPE.md](templates/SCOPE.md) (`scope_template`): Template format used by the PO to generate `.bmc-stuff/work/SXX-SCOPE.md`.
*   [BLUEPRINT.md](templates/BLUEPRINT.md) (`blueprint_template`): Template format used by the SA to generate `.bmc-stuff/work/SXX-BLUEPRINT.md`.
*   [DEMO.md](templates/DEMO.md) (`demo_template`): Template format used by the SA to generate `.bmc-stuff/work/SXX-DEMO.md` for CBO validation.

---

## 5. Exceptions and Failsafes Protocol

*   **Squad Failure (Validation Bug):** The SA appends `[BUG-VALIDATION]` tasks to `.bmc-stuff/work/SXX-BLUEPRINT.md`, which the Crew executes and verifies in-place.
*   **CBO Change of Mind:** The current cycle is closed as `Successfully Completed`, committed to the main branch, and the improvements are queued as a new cycle starting from Phase 1.
*   **Technical Deadlock:** The SA halts execution, logs a `BLOCK` event via `bmc-log event`, and escalates to the CBO for a **Session of Emergency Technical Bypass** (Scope Bypass, Code Bypass, or Slice Abortion).

---

## 6. Project Governance & Standards

All Crew operations are configured and guided by the files in the structured **Knowledge Base** directory:
*   [principles.md](principles.md): Defines operational minimalism, isolation rules, and WAILL-E framework principles.
*   [tech.md](tech.md): Defines pre-approved technologies, monolithic structures, living documentation files (`ARCHITECTURE.md`, `DESIGN.md`), and local skills lifecycle.
*   [guardrails.md](guardrails.md): Defines absolute limits for roles, the 3-attempt ping-pong limit, Stop-the-Line rules, and logging protocols.

### Pre-approved Skills Libraries
The Tech Guru and SA can pull reusable skill definitions from these sources:
*   **WAILL-E Core:** Minimal required skills for the Crew (slicing, TDD, TPLP).
*   **addyosmani-agent-skills:** Standard technical engineering skills.
*   **mattpocock-skills:** Engineering development and testing skills.
*   **obra-superpowers:** High-level development process control skills.

### Centralized SQLite Database CLI Helper (`bmc-log`)
All writes and queries to the SQLite database `.bmc-stuff/crew.db` must go through the centralized CLI script. Raw SQL operations are strictly forbidden.

**Write Operations:**
*   `.bmc-stuff/bin/bmc-log transition <slice_id> <from_phase> <to_phase> <details>`
*   `.bmc-stuff/bin/bmc-log task <slice_id> <task_id> <status> [ping_pong_count]`
*   `.bmc-stuff/bin/bmc-log event <slice_id> <agent_role> <event_type> <message>`

**Query Operations:**
*   `.bmc-stuff/bin/bmc-log active` (Lists all active/incomplete slice IDs)
*   `.bmc-stuff/bin/bmc-log show-slice <slice_id>` (Displays current phase, tasks list, and recent events for a slice)
*   `.bmc-stuff/bin/bmc-log check-dependency <slice_id>` (Checks if a dependency slice is completed; returns exit code 0 if resolved, 1 otherwise)
