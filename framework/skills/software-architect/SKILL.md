---
name: software-architect
description: Translate SXX-SCOPE.md into architectural design, directory structures, and a sequential backlog (SXX-BLUEPRINT.md).
---

# software-architect (Primary SA Skill)

## Purpose
Ingest the signed functional scope, evaluate technical feasibility against tech standards, check unresolved dependencies in SQLite, design the monolithic slice architecture, initialize project metadata, and break down the work into a sequential atomic backlog.

## Inputs
*   `.bmc-stuff/SXX-SCOPE.md` (signed and frozen, generated from [SCOPE.md template](file:///Users/duni/dev/baremetal-squad/framework/templates/SCOPE.md)).
*   SQLite database `.bmc-stuff/crew.db` (to inspect blocker slice completion status).
*   Active knowledge files: `framework/knowledge/tech.md` and `framework/knowledge/guardrails.md`.
*   Local repository state (active directory structures, existing base code, `.skills/` folder).

## Workflow
1.  **Technical Alignment:** Analyze the scope. Conduct a clarification Q&A session with the PO/CBO if gaps arise.
2.  **Dependency Execution Check:**
    *   Read the `Dependencies / Blockers` field from `.bmc-stuff/SXX-SCOPE.md`.
    *   Query `.bmc-stuff/crew.db` to check if the dependencies are closed and marked successful.
    *   **Block Execution if Unresolved:** If dependencies are unresolved, halt progress. Do not publish the backlog to the Engineering Crew until the blockers are resolved in the database.
3.  **Metadata Initialization:**
    *   Initialize or update `AGENTS.md` in the repository root.
    *   Initialize or update `DESIGN.md` in the repository root.
4.  **Architectural Design:** Design database schema changes, directory layouts, and server endpoints. Map any required technical packages from the local `.skills/` directory.
5.  **Backlog Generation:** Draft the backlog in `.bmc-stuff/SXX-BLUEPRINT.md`, detailing separate Dev Acceptance Criteria (code + unit tests) and QA Acceptance Criteria (automated E2E tests) for each task. Use the `SXX-01` task ID format.
6.  **Logging & Handoff:**
    *   Record the phase transition:
        ```bash
        .bmc-stuff/crew-log transition [SLICE-ID] "Phase 2: Breakdown" "Phase 3: Execution" ".bmc-stuff/SXX-BLUEPRINT.md generated, tasks published"
        ```
    *   Initialize the state of each task in the database using the CLI helper:
        ```bash
        .bmc-stuff/crew-log task [SLICE-ID] [TASK-ID] Pending 0
        ```
    *   Publish the backlog and trigger the implementation phase.

## Output
*   `.bmc-stuff/SXX-BLUEPRINT.md` (with atomic task statuses, generated from [BLUEPRINT.md template](file:///Users/duni/dev/baremetal-squad/framework/templates/BLUEPRINT.md)).
*   Updated `AGENTS.md` and `DESIGN.md`.
*   SQLite logs synchronized.

## Guardrails & Constraints
*   **Don't Execute:** Do not write application logic, CSS, or business code.
*   **Approved Stack:** Choose frameworks and DB engines strictly from `framework/knowledge/tech.md`. Any change requires CBO approval.
*   **Structural Verification:** Audit all completed tasks. Reject code containing TODOs, placeholders, or structure deviations.
