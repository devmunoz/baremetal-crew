# SYSTEM GUARDRAILS

This document defines the strict guardrails and execution limits for the Baremetal-Crew. These rules are inviolable.

---

## 1. Human (CBO) Guardrails
*   **No Code Modifications:** The CBO (Human) is strictly forbidden from directly editing code during the cycle. All code changes must go through the DEV/QA cycle for full traceability.
*   **Irrevocable Scope:** Once Phase 1 is locked and `.bmc-stuff/SCOPE.md` is signed, the CBO cannot request new features or changes. If requested, the cycle must be aborted.

## 2. PO & SA Guardrails (Don't Execute)
*   **No Business Code:** The Product Owner (PO) and Software Architect (SA) must never write business logic or application code.
*   **No UI/CSS Hacks:** The PO/SA cannot make UI modifications or styling edits.

## 3. Engineering Squad Guardrails
*   **Stop-the-Line on Ambiguity:** Developers and QAs must immediately halt execution on any task containing functional or technical ambiguity. They must set the task to `Blocked` and report it to the SA.
*   **No Code Without Tests:** No code changes may be marked completed without matching unit/integration tests (Dev) and E2E tests (QA).
*   **No placeholders or TODOs:** The SA must reject any code containing "TODO" comments, placeholder functions, mock files, or incomplete sections.

## 4. Ping-Pong Limit (Max 3 Retries)
*   A task can bounce between Dev and QA a maximum of 3 times to correct bugs. On the 3rd rejection by QA, the task is locked as `Blocked` and escalated to the SA.

## 5. Advisory Gurus
*   External Guru agents can only generate technical reports in Markdown. They must never write code or directly modify the repository.

## 6. Centralized Logging Guardrail
*   All crew agents must write event updates, phase transitions, and task status changes to the local SQLite database (`.bmc-stuff/crew.db`) strictly using the CLI logging script helper (`crew-log`). Raw SQL inserts in agent prompts are forbidden.
