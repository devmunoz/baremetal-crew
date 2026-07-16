---
name: qa-engineer
description: Run automated E2E and integration tests against tasks marked Ready for QA, reporting bugs or marking them QA Passed.
---

# qa-engineer (Primary QA Skill)

## Purpose
Certify that the developer's implementation matches the functional requirements of the task through automated E2E and integration tests in the local environment.

## Inputs
*   `.bmc-stuff/work/SXX-BLUEPRINT.md` (generated from [BLUEPRINT.md template](../../../.bmc-stuff/knowledge/templates/BLUEPRINT.md)).
*   Active knowledge files: [principles.md](../../../.bmc-stuff/knowledge/principles.md) and [guardrails.md](../../../.bmc-stuff/knowledge/guardrails.md).
*   Active `.bmc-stuff/work/SXX-SCOPE.md` user flows.

## Workflow
1.  **Monitor Backlog:** Select the current task marked `Ready for QA` in `.bmc-stuff/work/SXX-BLUEPRINT.md`.
2.  **Start Logging:** Log the start of QA testing:
    ```bash
    .bmc-stuff/bin/bmc-log event [SLICE-ID] QA START_QA "Started QA testing for task [TASK-ID]"
    ```
3.  **Test Implementation:** Write and run automated E2E/integration tests matching the task's QA Criteria.
4.  **Read Current Ping-Pong Count:** Read the current `Ping-Pong Count` value (e.g. `1 / 3`) for this task from `.bmc-stuff/work/SXX-BLUEPRINT.md`.
5.  **Acceptance Decision & Logging:**
    *   **Pass (Green Light):** If E2E tests pass at 100%:
        *   Update the task status in `.bmc-stuff/work/SXX-BLUEPRINT.md` to `QA Passed`.
        *   Log the pass event and status in SQLite, preserving the current ping-pong count:
            ```bash
            .bmc-stuff/bin/bmc-log task [SLICE-ID] [TASK-ID] "QA Passed" [CURRENT-PING-PONG]
            .bmc-stuff/bin/bmc-log event [SLICE-ID] QA PASS_QA "Task [TASK-ID] passed all tests"
            ```
        *   Notify the SA.
    *   **Reject (Bug Found):** If tests fail:
        *   Write a structured bug report detailing action, expected vs. actual outcome, and logs.
        *   Increment the task's ping-pong count in `.bmc-stuff/work/SXX-BLUEPRINT.md` (e.g. from `1 / 3` to `2 / 3`).
        *   Set its status to `Pending Correction` in `.bmc-stuff/work/SXX-BLUEPRINT.md`.
        *   Log the reject and the new ping-pong count in SQLite:
            ```bash
            .bmc-stuff/bin/bmc-log task [SLICE-ID] [TASK-ID] "Pending Correction" [NEW-PING-PONG-COUNT]
            .bmc-stuff/bin/bmc-log event [SLICE-ID] QA REJECT_QA "Task [TASK-ID] failed tests: [BUG-SUMMARY]"
            ```
6.  **Ping-Pong Limit Guardrail:**
    *   If rejecting for the **third time** (new ping-pong count is 3):
        *   Mark the task `Blocked` in `.bmc-stuff/work/SXX-BLUEPRINT.md`.
        *   Log the block in SQLite:
            ```bash
            .bmc-stuff/bin/bmc-log task [SLICE-ID] [TASK-ID] "Blocked" 3
            .bmc-stuff/bin/bmc-log event [SLICE-ID] QA PING_PONG_EXCEEDED "Task [TASK-ID] blocked: Ping-pong limit exceeded"
            ```
        *   Escalate to the SA immediately.

## Guardrails & Constraints
*   **Security (No Leaks):** Never commit credentials, local system paths, API keys, or SQLite databases to git.
*   **Commit Convention:** Stage changes and commit them following the Conventional Commits format: `<type>[optional scope]: <description> \n [optional body] \n [optional footer(s)]` (e.g. `test(auth): add integration tests for login`).
*   **Simplicity First:** Write only the code/tests required to fulfill the active task criteria. Avoid speculative E2E flows or abstractions.
*   **Surgical Changes:** Touch only what you must. Do not refactor or reformat unrelated adjacent code. Clean up any unused imports, variables, or functions created by your changes.
