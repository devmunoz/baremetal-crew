# DEMO: Delivery Validation - Slice [SLICE-ID]

> [!IMPORTANT]
> **Environment Requirement:** [Containerized (Docker) / Host Local]
> If containerized, ALL execution steps below use Docker exclusively. Do NOT mix host local execution commands with container commands.
> **Worktree Requirement:** If this slice was developed inside a git worktree, navigate into the worktree path (e.g. `cd .bmc-stuff/worktrees/[SLICE-ID]`) or switch to branch `feature/[SLICE-ID]` before executing the commands below.
## 1. Environment Preparation & Fresh Build
Before running the verification steps, perform a fresh build to ensure all newly added binaries, dependencies, and artifacts (e.g., TUI components, compiled tools) are built into the image:

```bash
# Clean previous containers and perform a fresh build (DO NOT skip --build)
docker compose down
docker compose build --no-cache
docker compose up -d
```

*(If not using Docker, provide equivalent fresh clean build/install commands for local runtime)*

## 2. Path & Mount Verification
Verify container mount paths and volume mappings:
- **Host Path:** `./music` mapped to **Container Path:** `/music`
- **Working Directory inside Container:** `/app`

## 3. Pre-loaded Mock Data & Credentials
- **Test User / Credential:** `admin@baremetal.com` / `password123`
- **Initial Conditions:** [Sample database seeds, container volume state, or environment variables]

## 4. Step-by-Step Human Validation Checklist (CBO)
Execute the exact containerized execution command to test the feature/fix:

- [ ] **Step 1 (Fresh Build & Startup):** Run `docker compose up --build -d` and verify all services start with status `healthy`.
- [ ] **Step 2 (Feature Execution):** Run the exact containerized command (e.g. `docker compose exec app /app/bin/tui --path /music`).
- [ ] **Step 3 (Outcome Verification):** Confirm expected output, UI view, or API response.
- [ ] **Step 4 (Cleanup):** Run `docker compose down`.
