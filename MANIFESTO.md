# BAREMETAL-CREW MANIFESTO: THE FRAMEWORK

This document establishes the rigid, minimalist, and operational working framework for local and monolithic software development, led by a human (CBO) and executed by a squad of AI agents.

---

## 1. Core Philosophy: "Simplicity in Structure, Tyranny in Flow"

*   **Operational Minimalism:** The framework reduces roles and ceremonies to the absolute minimum. All work is run locally, using monolithic architectures, managed via Docker Compose and environment variables (`.env`).
*   **Absolute Separation of Roles:** No role may invade the functions or constraints of another. Confusion and loss of control stem from multitasking and role ambiguity.
*   **Military and Irrevocable Flow:** The development flow is linear and watertight. AI agents are forbidden from assuming or guessing; when in doubt, they must stop and ask. The human commits to never changing the scope once a cycle is locked.

---

## 2. Strict Definition of Roles, Reporting Lines, and Constraints

### A. Baremetal Master "CBO" (Chief Baremetal Officer - Human)
*   **Reporting Line:** Supreme Level. Defines the *What* functionally with the PO, and validates the final delivery from the SA.
*   **Responsibilities:**
    1.  Provide the initial high-level idea.
    2.  Submit obligatorily to the PO's *Grill Session* interrogation until all ambiguity is eliminated.
    3.  Manually validate the product running locally (testing 70-100% of critical user flows).
*   **Strict Constraints:**
    *   **Absolute ban on touching code:** The CBO does not perform direct micro-corrections (typos, CSS, etc.). Any issues found must be formally reported to the Squad to maintain traceability and discipline.
    *   **Scope freezing:** Changing requirements or adding features mid-cycle is strictly forbidden. If requested, the current cycle is aborted immediately, and a new one starts from Phase 1.

### B. Product Owner "PO" (AI Agent)
*   **Reporting Line:** Reports to the CBO.
*   **Responsibilities:**
    1.  Run the *Grill Session* against the CBO using aggressive functional extraction questioning.
    2.  **Guardian of functional minimalism:** Actively force scope trimming, deferring secondary ideas and writing **Template 01 (Closed Scope)** focusing on a single slice of value.
*   **Strict Constraints:**
    *   **Don't execute:** Does not decide technologies, does not design architecture, does not write code, and does not create technical tasks. Output is 100% functional text.

### C. Software Architect "SA" / Tech Lead (AI Agent)
*   **Reporting Line:** Reports to the CBO (official delivery) and aligns with the PO (scope ingestion). Governs the Engineering Squad (Dev and QA).
*   **Responsibilities:**
    1.  Translate the functional specification (Template 01) into architectural decisions and monolith structure.
    2.  Create **Template 02 (Atomic Backlog)** with unequivocal, self-contained tasks.
    3.  **Single Point of Technical Contact:** Receives reports from the Squad, verifies structural alignment, and presents the formal delivery to the CBO.
*   **Strict Constraints:**
    *   **Don't execute:** Does not write business logic or application code.
    *   **Restricted & Pre-approved Stack:** Must limit technical designs strictly to pre-approved local monolithic technologies (e.g., Node/Express, Python/FastAPI, SQLite, Docker Compose). Any stack changes require explicit CBO approval.
    *   **Structural Verification:** Does not review internal logic line-by-line, but audits that the folder structure, design patterns, and code are free of "TODOs" or placeholders before sign-off.

### D. Engineering Squad "ES" (AI Agents)

#### D.1. Fullstack Dev
*   **Reporting Line:** Reports to the SA.
*   **Responsibilities:** Implement business logic and write unit/integration tests corresponding to assigned tasks.
*   **Strict Constraints:** Does not think about product or add features autonomously.

#### D.2. QA Engineer
*   **Reporting Line:** Reports to the SA.
*   **Responsibilities:** Design and automate E2E tests and local integration/validation tests to certify the overall functionality of the slice.
*   **Strict Constraints:** Does not modify application code; validates externally.

#### Ambiguity Block Protocol (Stop-the-Line)
*   If a Dev or QA task contains any ambiguity, the agent **must not assume**. They must abort the task immediately, mark it as `Blocked` in `BLUEPRINT.md`, and report the block to the SA.
*   The ES may proceed with other backlog tasks only if they are 100% independent.

---

## 3. The 4 Inviolable Phases of the Process

The operational flow consists of four sequential, watertight phases. Each transition requires an explicit "sign-off" to prevent ambiguity or chaos from spreading.

```
[CBO] --(Idea)--> [Phase 1: The Grill] --> [PO]
                                            | (Template 01: Scope)
[Dev/QA] <-- (Template 02) <-- [Phase 2: The Breakdown] <-- [SA]
   |
[Phase 3: Blind Execution] (Dev-QA Cycle with Ping-Pong Limit)
   |
[Phase 4: Validation] (DEMO.md) --> [CBO] (Green Light / Abort Cycle)
```

### Phase 1: The Grill (CBO -> PO)
*   **Trigger:** CBO introduces an initial software idea or concept.
*   **Process:** The PO activates the *Grill Session*, interrogating the CBO aggressively. The PO functional-trims the scope to keep it minimal and drafts **Template 01 (Closed Scope)**.
*   **Phase Sign-off:** The CBO must explicitly approve and sign the contents of Template 01. Until signed, the technical cycle is frozen.

### Phase 2: The Breakdown (PO -> SA)
*   **Trigger:** Template 01 signed by the CBO.
*   **Process (Technical Alignment Session):** The SA reviews Template 01. If technical gaps or functional contradictions are detected, the SA conducts a clarification Q&A session with the PO/CBO before proceeding. Once resolved, the SA validates stack feasibility and initializes the monolith's architecture map.
*   **Phase Sign-off:** The SA generates and signs **Template 02 (Blueprint and Backlog)**, making the backlog public to the Engineering Squad.

### Phase 3: Blind Execution (SA -> Dev/QA)
*   **Trigger:** Template 02 generated by the SA.
*   **Process (Execution & QA Cycle):** The Dev and QA have global backlog visibility to ensure context, but task execution is strictly sequential (Task N completed and validated before Task N+1 begins).
    *   **Dev-QA Cycle:** The Fullstack Dev implements code and adds unit/integration tests $\rightarrow$ sets to "Ready for QA". The QA Engineer spins up the local environment and runs automated integration and E2E tests.
    *   **Ping-Pong Limit:** Maximum of 3 correction attempts per task. If the QA rejects a task a third time, it is locked and escalated to the SA to audit the code and clarify technical ambiguity.
    *   **Stop-the-Line:** If a task is ambiguous, the Dev/QA aborts it and reports immediately to the SA. They only advance to other tasks if they are 100% independent.
*   **Phase Sign-off:** All backlog tasks are marked `QA Passed` and structurally audited by the SA.

### Phase 4: Validation (SA -> CBO)
*   **Trigger:** Backlog completed and verified by the SA.
*   **Process:** The SA generates a temporary `DEMO.md` file detailing local startup commands, pre-loaded mock data, and a checklist of functional user flows. The CBO follows the guide and manually validates 70-100% of critical paths on their local machine.
*   **Phase Sign-off:** 
    *   *Green Light:* Successful closure of the software cycle.
    *   *Squad Failure (Bug/Missing Scope):* Reverted to Phase 3.
    *   *CBO Change of Mind:* The cycle is aborted and reverted to Phase 1 for a new scope.

---

## 4. Control Templates

To ensure Obsidian-compatibility and easy parsing by AI agents, three exact markdown templates are defined with rigid, action-oriented fields.

### Template 01: Closed Scope (`SCOPE.md`)

```markdown
# [CYCLE-ID] SCOPE: [Slice/Project Name]

## 1. Meta-information
- **Cycle ID:** [BMS-XXX]
- **Date Created:** YYYY-MM-DD
- **Status:** [Draft / Signed]
- **General Objective:** (A single concise paragraph defining the success of this cycle)

## 2. Step-by-Step UI/Action Flows
### Flow 1: [Flow Name]
- **Starting Route:** `/initial-url`
- **Step 1:** [User action] -> [Immediate visible result on interface]
- **Step 2:** [User action] -> [Immediate visible result on interface]

### Flow 2: [Flow Name]
- **Starting Route:** `/initial-url`
- **Step 1:** [Action...] -> [Result...]

## 3. Drastic Exclusions
*(Detailed list of what will NOT be built during this cycle to prevent scope creep)*
- [ ] Exclusion 1 (e.g., "No admin panel or login system; everything is managed locally").
- [ ] Exclusion 2 (e.g., "Persistence will be in memory or plain SQLite; no Postgres will be configured").

## 4. Functional Success Criteria
- [ ] Flow 1 runs end-to-end without visual errors.
- [ ] Flow 2 persists data correctly and displays it upon page reload.
```

---

### Template 02: Technical Specification and Backlog (`BLUEPRINT.md`)

```markdown
# [CYCLE-ID] BLUEPRINT AND BACKLOG: [Slice/Project Name]

## 1. Slice Architecture
*(The SA details structural and technical modifications specific to this slice)*
- **Directory Structure (Monolith):**
  - Directories created or modified in this cycle.
- **Database (Schema and Changes):**
  ```sql
  -- SQL statements or conceptual schema modified
  ```
- **API Endpoints / Server Routes:**
  - `[METHOD] /route/endpoint` -> Input: `JSON` / Output: `JSON` + HTTP Code.

## 2. Atomic Task Backlog
*(Ordered list of atomic tasks. Execution is strictly sequential)*

### Task ID: [BMS-XXX-01] - [Module]
- **Description:** Exactly what needs to be done.
- **Expected Input:** Starting code, mocks, or data.
- **Expected Outcome:** State of system/code upon completion.
- **Dev Criteria (Code and Unit/Integration Tests):**
  - [ ] Implementation of logic in `path/file.js`.
  - [ ] Unit/integration test validating the happy path in `tests/file.test.js`.
- **QA Criteria (E2E/Integration Tests):**
  - [ ] Automated E2E test (Playwright/Cypress/etc.) in `tests/e2e/flow.spec.js` validating the complete integration of frontend and backend for this task.
- **Status:** [Pending / In Development / Ready for QA / QA Passed / Blocked]
```

> [!NOTE]
> In addition to this temporary slice document, agents will maintain a persistent ARCHITECTURE.md file in the root of the repository, which compiles the consolidated architectural state of the application as slices accumulate.

---

### DEMO.md: Validation Guide (SA -> CBO)

```markdown
# DEMO: Delivery Validation - Cycle [CYCLE-ID]

## 1. Local Startup Instructions
*(Exact and clean commands to spin up the project on the CBO's machine)*
```bash
docker compose down -v
docker compose up --build -d
# or
npm install && npm run dev
```

## 2. Pre-loaded Mock Data
*(So the CBO does not waste time creating data)*
- **Test User:** `admin@baremetal.com` / `password123`
- **Initial Conditions:** "The database already contains 3 pre-loaded tasks with different statuses on the main dashboard."

## 3. Human Validation Checklist (CBO)
- [ ] **Step 1:** Spin up the environment and open `http://localhost:3000`.
- [ ] **Step 2:** Log in with the test user and validate redirection to the Dashboard.
- [ ] **Step 3:** Create a new task and validate its visual persistence.
- [ ] **Step 4:** Attempt to access an excluded flow (e.g., `/admin` route) and verify it returns an error or is inaccessible.
```

---

## 5. Exceptions and Failsafes Protocol

To ensure continuous local development without agent loops or human frustration, three escape valves are established.

### A. Squad Failure in Validation (Bug or Missing Scope)
If during validation (Phase 4), the CBO finds that the software does not meet the explicit flows or criteria signed in Template 01, validation is declared **rejected for quality**:
1.  The SA analyzes the CBO's bug report and creates special tasks named `[BUG-VALIDACION]` at the end of the active `BLUEPRINT.md`.
2.  The Dev and QA resolve and verify these tasks sequentially, in-place, within the same cycle.
3.  Once fixed, the SA generates a new `DEMO.md`, and the CBO validates again.
4.  The cycle is not closed until the CBO approves the flows from the original scope.

### B. CBO Change of Mind or Refactor (Functional Pivot)
If during validation (Phase 4), the CBO observes that the software works exactly as specified in Template 01, but wants to change the user experience, add buttons, or alter functional logic:
1.  The current cycle is declared **Successfully Completed** and closed.
2.  The code is consolidated by committing/merging to the main branch, and ARCHITECTURE.md is updated.
3.  The change of mind is classified as an "Enhancement" and queued for the next cycle (`BMS-XXX+1`), starting from Phase 1 (Grill Session).
*This protects the health of the agents, avoiding chaotic code rewrites without an updated blueprint.*

### C. Technical Deadlock
If the Dev and QA block each other on a task due to incompatible dependencies, testing framework bugs, or environment issues that the SA cannot resolve after auditing:
1.  The SA stops development and calls an **Emergency Technical Bypass Session**, sending a detailed block report to the CBO.
2.  The CBO (Human) steps in and makes one of three bypass decisions:
    *   **Scope Bypass:** Modify the task requirement in the blueprint to simplify functionality or bypass the conflicting library.
    *   **Code Bypass (Emergency Exception):** The CBO writes the key code lines or configurations to unblock the issue, commits manually, and returns control to the Squad.
    *   **Slice Abortion:** Cancel the current cycle due to technical infeasibility, reverting the repository to the last stable consolidated commit.
