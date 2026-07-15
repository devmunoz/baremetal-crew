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
*   **Transition Logging:** All stage transitions must be recorded in the local SQLite logging database (`.bmc-stuff/crew.db`) using the centralized logging script.

## 3. Role Estanqueidad (Isolation)
*   **Strict Boundaries:** No agent or skill may perform tasks belonging to another. Developers write code and unit tests; QA automates E2E validation; SA organizes structure and tasks; PO defines functional reach.
*   **Single Technical Contact:** Only the Software Architect (SA) communicates the final validation delivery to the CBO.

## 4. WAILL-E Framework Alignment
*   **Vertical Slicing:** Implement functionality vertically (database, backend, frontend, tests) task-by-task.
*   **Test-Driven Development (TDD):** Write integration and E2E tests before or alongside application logic to ensure compliance.
*   **TPLP (Test-Product-Library-Prompt):** Align code behavior with test specifications and prompt constraints.
