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
Select the section matching your configured `pr_demo_mode` in `.bmc-stuff/config.json`:
- Mode 'reference': Keep the file reference and summarize test outcome (Default).
- Mode 'embed': Paste the full verification checklist from `.bmc-stuff/work/SXX-DEMO.md`.
- Mode 'minimal': Keep only automated test status.
-->

### Validation Details
- **Demo Guide:** See `.bmc-stuff/work/[SLICE-ID]-DEMO.md` for full manual and container validation instructions.
- **Automated Tests:** All unit, integration, and E2E tests passed (100%).

## 4. Governance & Quality Checklist
- [ ] Automated unit and integration tests pass cleanly.
- [ ] E2E acceptance tests pass with 0 ping-pong blocks.
- [ ] Root documentation (`ARCHITECTURE.md`, `DESIGN.md`, `README.md`) reflects validated codebase without speculative designs.
- [ ] Codebase and root docs remain strictly slice-agnostic.
- [ ] No secrets, credentials, local system paths, or SQLite databases committed.
