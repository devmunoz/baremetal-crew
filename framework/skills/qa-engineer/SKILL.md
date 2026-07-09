---
name: qa-engineer
description: Run automated E2E and integration tests against tasks marked Ready for QA, reporting bugs or marking them QA Passed.
---

# qa-engineer (Primary QA Skill)

## Purpose
Certify that the developer's implementation matches the functional requirements of the task through automated E2E and integration tests in the local environment.

## Inputs
*   `.bmc-stuff/SXX-BLUEPRINT.md` (generated from [BLUEPRINT.md template](file:///Users/duni/dev/baremetal-squad/framework/templates/BLUEPRINT.md)).
*   Active knowledge files: `framework/knowledge/principles.md` and `framework/knowledge/guardrails.md`.
*   Active `.bmc-stuff/SXX-SCOPE.md` user flows.

## Workflow
1.  **Monitor Backlog:** Select the current task marked `Ready for QA` in `.bmc-stuff/SXX-BLUEPRINT.md`.
2.  **Start Logging:** Log the start of QA testing:
    ```bash
    framework/bin/crew-log event [SLICE-ID] QA START_QA "Started QA testing for task [TASK-ID]"
    ```
3.  **Test Implementation:** Write and run automated E2E/integration tests matching the task's QA Criteria.
4.  **Read Current Ping-Pong Count:** Read the current `Ping-Pong Count` value (e.g. `1 / 3`) for this task from `.bmc-stuff/SXX-BLUEPRINT.md`.
5.  **Acceptance Decision & Logging:**
    *   **Pass (Green Light):** If E2E tests pass at 100%:
        *   Update the task status in `.bmc-stuff/SXX-BLUEPRINT.md` to `QA Passed`.
        *   Log the pass event and status in SQLite, preserving the current ping-pong count:
            ```bash
            framework/bin/crew-log task [SLICE-ID] [TASK-ID] "QA Passed" [CURRENT-PING-PONG]
            framework/bin/crew-log event [SLICE-ID] QA PASS_QA "Task [TASK-ID] passed all tests"
            ```
        *   Notify the SA.
    *   **Reject (Bug Found):** If tests fail:
        *   Write a structured bug report detailing action, expected vs. actual outcome, and logs.
        *   Increment the task's ping-pong count in `.bmc-stuff/SXX-BLUEPRINT.md` (e.g. from `1 / 3` to `2 / 3`).
        *   Set its status to `Pending Correction` in `.bmc-stuff/SXX-BLUEPRINT.md`.
        *   Log the reject and the new ping-pong count in SQLite:
            ```bash
            framework/bin/crew-log task [SLICE-ID] [TASK-ID] "Pending Correction" [NEW-PING-PONG-COUNT]
            framework/bin/crew-log event [SLICE-ID] QA REJECT_QA "Task [TASK-ID] failed tests: [BUG-SUMMARY]"
            ```
6.  **Ping-Pong Limit Guardrail:**
    *   If rejecting for the **third time** (new ping-pong count is 3):
        *   Mark the task `Blocked` in `.bmc-stuff/SXX-BLUEPRINT.md`.
        *   Log the block in SQLite:
            ```bash
            framework/bin/crew-log task [SLICE-ID] [TASK-ID] "Blocked" 3
            framework/bin/crew-log event [SLICE-ID] QA PING_PONG_EXCEEDED "Task [TASK-ID] blocked: Ping-pong limit exceeded"
            ```
        *   Escalate to the SA immediately.
