# PROCESS PRINCIPLES

This document defines the core process principles that govern the Baremetal-Crew development lifecycle. All skills and roles must align with these guidelines.

---

## 1. Operational Minimalism (KISS)
*   **Flat Structure:** Reduce meetings, status updates, and bureaucracy. Everything is managed locally.
*   **Single-Slice Focus:** Each cycle (slice) must focus on a single, end-to-end user value flow. Do not attempt multi-feature releases in a single cycle.
*   **Containerization:** All services and environments must run locally under Docker and Docker Compose. No cloud provider configurations.

## 2. Watertight Phase Transitions
*   **Irrevocable Scope:** Once Phase 1 is signed off, the functional scope is frozen. Changes are prohibited until the next cycle.
*   **Explicit Sign-offs:** Each transition between phases requires a formal sign-off (e.g., CBO signs `.bmc-stuff/SCOPE.md`, SA signs `.bmc-stuff/BLUEPRINT.md`, QA marks task `QA Passed`).
*   **Explicit CBO Approval Only (No Inferred Sign-off):** All phase transitions and artifact sign-offs (`SXX-SCOPE.md`, `SXX-BLUEPRINT.md`, `SXX-DEMO.md`) MUST be explicitly authorized by the CBO (Human). Agents are strictly forbidden from assuming approval, inferring sign-off from routine user instructions (e.g., "check recommended skills"), or self-signing artifacts on behalf of the CBO.
*   **Transition Logging:** All stage transitions must be recorded in the local SQLite logging database (`.bmc-stuff/crew.db`) using the centralized logging script.
*   **Framework Binary Protection:** Helper scripts under `bin/` or `.bmc-stuff/bin/` (`bmc-log`, `bmc-index-skills`) are immutable framework executables. Crew agents must NEVER edit, patch, or modify binary scripts.
*   **Centralized DB Access:** All state changes and queries must execute strictly via `.bmc-stuff/bin/bmc-log`. Executing direct shell database commands (e.g., `sqlite3`) is strictly prohibited.

## 3. Role Estanqueidad (Isolation)
*   **Strict Boundaries:** No agent or skill may perform tasks belonging to another. Developers write code and unit tests; QA automates E2E validation; SA organizes structure and tasks; PO defines functional reach.
*   **Single Technical Contact:** Only the Software Architect (SA) communicates the final validation delivery to the CBO.

## 4. BMC Framework Alignment
*   **Vertical Slicing:** Implement functionality vertically (database, backend, frontend, tests) task-by-task.
*   **Test-Driven Development (TDD):** Write integration and E2E tests before or alongside application logic to ensure compliance.
*   **TPLP (Test-Product-Library-Prompt):** Align code behavior with test specifications and prompt constraints.

## 5. Communication Standards & Token Optimization
*   **Simplified Technical English (ASD-STE100):** All inter-agent and CBO communications must strictly follow ASD-STE100 principles. Use active voice, simple tenses, short sentences (≤20 words for instructions, ≤25 for descriptions), and explicit, non-ambiguous terms.
*   **Artifact Token Optimization:** When creating or modifying artifact files (e.g. `SXX-SCOPE.md`, `SXX-BLUEPRINT.md`, `SXX-DEMO.md`, `SXX-SKILLS-RECOMMENDED.md`, `AGENTS.md`, root docs, bug reports), agents must never print the full file content in the chat response. Provide only the exact file path, a concise summary (1–3 sentences in ASD-STE100), and direct actions or instructions for the user/CBO or receiving agents.
*   **Optional Caveman Skill Suggestion:** `caveman` mode is available as an indexed skill in the skills catalog (`skills-catalog.json`). Crew agents may advertise it as an optional suggestion to the CBO for ultra-compressed chat communication, but activation remains strictly up to the CBO. ASD-STE100 and Artifact Token Optimization Standard remain enforced by default across all roles.
*   **Optional Git Worktree Workspace Isolation:** `using-git-worktrees` is available in the skills catalog (`skills-catalog.json`). Crew agents (Tech Guru and SA) may suggest using git worktrees for isolated slice workspaces and parallel slice execution, leaving setup and activation strictly up to the CBO.
