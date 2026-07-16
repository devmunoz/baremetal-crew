# AGENTS.md

This file provides instructions for AI coding agents working on this repository.

## 🛠️ Setup & Build
*   **Requirements:** [e.g. Node.js v20, Docker]
*   **Install Command:** [e.g. `npm install`]
*   **Run Command:** [e.g. `npm run dev`]

## 🧪 Testing
*   **Unit Tests:** [e.g. `npm test`]
*   **Integration/E2E Tests:** [e.g. `npx playwright test`]

## ⚙️ Coding Conventions
*   **Conventions:** [Specify coding conventions, styling, etc.]
*   **Documentation:** Keep `README.md`, `ARCHITECTURE.md`, and `DESIGN.md` updated with implementation changes.

## 🤖 Baremetal-Crew (BMC) Integration
*   This project is developed using the Baremetal-Crew framework.
*   For roles, workflows, phase transitions, and guardrails, refer to the [Manifesto](.bmc-stuff/knowledge/MANIFESTO.md) only when executing crew role transitions or logging tasks.
*   Find the active slice task backlog in `.bmc-stuff/work/SXX-BLUEPRINT.md` (where `SXX` is the active slice ID, e.g. `S01`). To determine the active slice(s), use the centralized helper command: `.bmc-stuff/bin/bmc-log active`.
