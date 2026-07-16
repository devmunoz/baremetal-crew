# SYSTEM GUARDRAILS

This document defines the strict guardrails and execution limits for the Baremetal-Crew. These rules are inviolable.

---

## 1. Human (CBO) Guardrails
*   **No Code Modifications:** The CBO (Human) is strictly forbidden from directly editing code during the cycle. All code changes must go through the DEV/QA cycle for full traceability.
*   **Irrevocable Scope:** Once Phase 1 is locked and `.bmc-stuff/SCOPE.md` is signed, the CBO cannot request new features or changes. If requested, the cycle must be aborted.

## 2. PO & SA Guardrails (Don't Execute)
*   **No Business Code:** The Product Owner (PO) and Software Architect (SA) must never write business logic or application code.
*   **No UI/CSS Hacks:** The PO/SA cannot make UI modifications or styling edits.
*   **No Scope, No Action:** The SA must never modify, create, or initialize any files (including `AGENTS.md`, `DESIGN.md`, or `ARCHITECTURE.md`) without a signed and frozen `.bmc-stuff/work/SXX-SCOPE.md` for the active slice.
*   **Propose, Don't Execute:** If the SA detects that the repository is uninitialized or missing metadata/base files but lacks a signed scope or explicit instruction to proceed, the SA must halt execution, report this to the CBO, propose the initialization plan, and wait for confirmation. Autonomous execution without any clear scope or plan is strictly forbidden.

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

## 7. Security & Secret Management Guardrail
*   **No Leaks:** Never commit credentials, local system paths, API keys, certificates, or SQLite databases to git. Use environment files (`.env`) for local runtime secrets and create `.env.example` templates if modifications are made.

## 8. Development Guardrails (Minimalism & Scope)
### Simplicity First
*   **Minimum Code:** Write only the code required to fulfill the active task criteria. Avoid speculative features, early optimizations, or abstractions for single-use code.
*   **Complexity Check:** Keep implementations minimal and clean. If a solution can be written in a significantly shorter/simpler manner, it must be rewritten.

### Surgical Changes
*   **Scope Limit:** Touch only the files and lines necessary for the task. Refactoring or reformatting unrelated adjacent code is strictly prohibited.
*   **Clean Orphans:** Remove unused imports, variables, or functions created by your changes. Do not clean up pre-existing dead code in unrelated modules unless explicitly requested in the task.
