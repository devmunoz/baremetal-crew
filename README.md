# Baremetal-Crew (BMC)

A rigid, minimalist, and highly structured human/agent development framework for local, monolithic software projects.

---

## 📖 What is Baremetal-Crew?
Baremetal-Crew enforces a linear, watertight workflow between a Human (**CBO**) and a Crew of specialized AI agents:
1.  **Product Owner (PO):** Interrogates the CBO to freeze functional scope (`SXX-SCOPE.md`).
2.  **Software Architect (SA):** Breaks down the scope into technical designs and atomic tasks (`SXX-BLUEPRINT.md`).
3.  **Fullstack Dev:** Implements code and unit tests blindly task-by-task.
4.  **QA Engineer:** Automates integration/E2E tests to verify implementation.
5.  **Tech Guru:** Evaluates technical needs and indexes/recommends external skills catalog.

For detailed information on the philosophy, roles, and the 4 inviolable phases, read the [Baremetal-Crew Manifesto](framework/knowledge/MANIFESTO.md).

---

## 🚀 Installation & Setup

To install the framework in a target repository, run the installer script:

```bash
./install.sh /path/to/target/project
```

### What the installer does:
1.  Creates a metadata sandbox folder `.bmc-stuff/` in your project root, with `bin/`, `work/`, and `knowledge/` subdirectories.
2.  Copies the core **Knowledge Base** (`.bmc-stuff/knowledge/`) and **Reference Templates** (`.bmc-stuff/knowledge/templates/`).
3.  Copies the database logging helper `.bmc-stuff/bin/bmc-log` and indexer `.bmc-stuff/bin/bmc-index-skills`.
4.  Optionally clones and indexes pre-approved skills repositories from GitHub (such as Addy Osmani, Matt Pocock, Julius Brussee, and Obra skills) to `.bmc-stuff/skills-cache/` for the Tech Guru to analyze.
5.  Installs the primary AI skills into your project's `.agents/skills/` directory.

---

## 🛠️ Logging and Database
All cycle history, tasks statuses, and transitions are recorded locally in a SQLite database at `.bmc-stuff/crew.db`. You can manage transitions or query status using the CLI command:

```bash
.bmc-stuff/bin/bmc-log transition S01 "Phase 1: Grill" "Phase 2: Breakdown" "SCOPE signed"
```
