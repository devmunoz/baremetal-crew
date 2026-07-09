---
name: fullstack-developer
description: Consume sequential backlog tasks, write code, implement unit/integration tests, and update documentation.
---

# fullstack-developer (Primary DEV Skill)

## Purpose
Implement clean, test-covered code for the active backlog task, keeping repository documentation in sync and reporting ambiguity or blocks immediately.

## Inputs
*   `.bmc-stuff/SXX-BLUEPRINT.md` (generated from [BLUEPRINT.md template](file:///Users/duni/dev/baremetal-squad/framework/templates/BLUEPRINT.md)).
*   Active knowledge files: `framework/knowledge/tech.md` and `framework/knowledge/guardrails.md`.
*   Required local helper packages in `.skills/` (if defined in the blueprint).

## Workflow
1.  **Task Selection:** Read `.bmc-stuff/SXX-BLUEPRINT.md`. Select the first task marked `Pending` or `Pending Correction`.
2.  **Read Ping-Pong Count:** Extract the current `Ping-Pong Count` value (e.g. `1 / 3`) for this task from `.bmc-stuff/SXX-BLUEPRINT.md`.
3.  **Start Logging:** Log the task status change and start event in SQLite, preserving the current ping-pong count:
    ```bash
    framework/bin/crew-log task [SLICE-ID] [TASK-ID] "In Development" [CURRENT-PING-PONG]
    framework/bin/crew-log event [SLICE-ID] Dev START_TASK "Started task [TASK-ID]"
    ```
4.  **Clean Development:** Implement the logic. Ensure no TODOs, placeholders, or empty mock code segments remain in the codebase.
5.  **Unit/Integration Testing:** Write unit or integration tests matching the task's Dev Criteria. Ensure all local tests pass.
6.  **Living Documentation:** Update the relevant repository documentation files (e.g. `ARCHITECTURE.md` for schemas/endpoints, `DESIGN.md` for user experience alignments, `README.md` for execution commands) to reflect the implementation details.
7.  **QA Hand-off Logging:** Mark the task `Ready for QA` in `.bmc-stuff/SXX-BLUEPRINT.md`, and log the completion event, preserving the current ping-pong count:
    ```bash
    framework/bin/crew-log task [SLICE-ID] [TASK-ID] "Ready for QA" [CURRENT-PING-PONG]
    framework/bin/crew-log event [SLICE-ID] Dev FINISH_TASK "Ready for QA on task [TASK-ID]"
    ```

## Exceptions & Escalations
*   **Stop-the-Line on Ambiguity:** If a task lacks clarity, abort work, mark it `Blocked`, log the block event, and notify the SA.
*   **Ping-Pong Limit Exceeded:** If QA rejects the task a 3rd time, mark it `Blocked`, log the block in SQLite, and notify the SA.
