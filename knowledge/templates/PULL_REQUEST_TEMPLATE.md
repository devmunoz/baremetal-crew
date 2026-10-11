<!-- Baremetal-Crew (BMC) Pull Request Template -->
# Pull Request: [Slice Name / Feature Title]

## 1. Summary
<!-- Provide a 1-3 sentence summary of the feature, bug fix, or system change in ASD-STE100 style. -->
- **Slice Reference:** [SXX] (or internal feature branch)
- **Target Branch:** `main` (or `master`)
- **Isolation Source:** `.bmc-stuff/worktrees/[SLICE-ID]` (or `feature/[SLICE-ID]`)

## 2. Key Deliverables & Changes
<!-- List primary modules, files, endpoints, or data models modified in this change. -->
- Deliverable 1: Description of change
- Deliverable 2: Description of change

## 3. Verification & Validation
<!--
Format this section based on `pr_demo_mode` in `.bmc-stuff/config.json`:
- Mode 'embed' (Default): Embed the manual verification checklist from `.bmc-stuff/work/SXX-DEMO.md` below.
- Mode 'reference': Replace the checklist below with: "- **Demo Guide:** See `.bmc-stuff/work/[SLICE-ID]-DEMO.md`".
- Mode 'minimal': Omit the manual checklist and keep only automated test status.
-->

### Automated Test Status
- All unit, integration, and E2E tests passed (100%).

### Manual Verification Checklist (CBO)
<!-- Step-by-step instructions from .bmc-stuff/work/[SLICE-ID]-DEMO.md -->
- [ ] **Step 1 (Environment Setup & Fresh Build):** Run clean build command (e.g. `docker compose build --no-cache && docker compose up -d`).
- [ ] **Step 2 (Feature Execution):** Run the verification command (e.g. `docker compose exec app ...`).
- [ ] **Step 3 (Outcome Verification):** Confirm expected output, API response, or UI view.
- [ ] **Step 4 (Cleanup):** Run cleanup command (e.g. `docker compose down`).
## 4. Governance & Quality Checklist
- [ ] Automated unit and integration tests pass cleanly.
- [ ] E2E acceptance tests pass with 0 ping-pong blocks.
- [ ] Root documentation (`ARCHITECTURE.md`, `DESIGN.md`, `README.md`) reflects validated codebase without speculative designs.
- [ ] Codebase and root docs remain strictly slice-agnostic.
- [ ] No secrets, credentials, local system paths, or SQLite databases committed.
