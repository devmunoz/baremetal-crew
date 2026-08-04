# [SLICE-ID] BLUEPRINT AND BACKLOG: [Slice Name]

## 1. Slice Architecture
- **Dependencies / Blockers:** [None / List of UNRESOLVED Slice IDs (e.g., S01)]
- **Directory Structure (Monolith):**
  - Directories created or modified in this slice.
- **Database (Schema and Changes):**
  ```sql
  -- SQL statements or schema modified
  ```
- **API Endpoints / Server Routes:**
  - `[METHOD] /route/endpoint` -> Input: `JSON` / Output: `JSON` + HTTP Code.
- **Required Skills:**
  - `.agents/skills/[skill-name]`

## 2. Atomic Task Backlog
### Task ID: [SXX-01] - [Module]
- **Description:** Exactly what needs to be done.
- **Expected Input:** Starting code, mocks, or data.
- **Expected Outcome:** State of system/code upon completion.
- **Dev Criteria (Code and Unit/Integration Tests):**
  - [ ] Implementation of logic in `path/file.js`.
  - [ ] Unit test in `tests/file.test.js`.
- **QA Criteria (E2E/Integration Tests):**
  - [ ] Automated E2E test in `tests/e2e/flow.spec.js`.
- **Status:** [Pending / In Development / Ready for QA / QA Passed / Blocked]
- **Ping-Pong Count:** 0 / 3
