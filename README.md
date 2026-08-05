# Baremetal-Crew (BMC)

A rigid, minimalist, and highly structured human/agent development framework for local, monolithic software projects.

---

## 📖 What is Baremetal-Crew?
Baremetal-Crew enforces a linear, watertight workflow between a Human (**CBO**, Chief Baremetal Officer) and a Crew of specialized AI agents:
1.  **Product Owner (PO):** Interrogates the CBO to freeze functional scope (`SXX-SCOPE.md`).
2.  **Software Architect (SA):** Breaks down the scope into technical designs and atomic tasks (`SXX-BLUEPRINT.md`).
3.  **Fullstack Dev:** Implements code and unit tests blindly task-by-task.
4.  **QA Engineer:** Automates integration/E2E tests to verify implementation.
5.  **Tech Guru:** Evaluates technical needs and indexes/recommends external skills catalog.

For detailed information on the philosophy, roles, and the 4 inviolable phases, read the [Baremetal-Crew Manifesto](knowledge/MANIFESTO.md).

---

## 🚀 Installation & Setup

You can install Baremetal-Crew in a target project directory using either of the following options:

### Option 1: Local Clone Installation
Use this option if you have already cloned the `baremetal-crew` repository locally. Run the installer script and pass the target project directory:

```bash
./install.sh /path/to/target/project -y -i
```

### Installer Flags & Options

The `install.sh` script supports the following command-line flags:

| Flag | Short | Description |
| :--- | :--- | :--- |
| `-i`, `--index-skills` | `-i` | Automatically clone, index pre-approved technical skills libraries, and update matching skills in `.agents/skills/` during install. |
| `-y`, `--yes` | `-y` | Non-interactive mode (automatically confirms installation prompts). |
| `-h`, `--help` | `-h` | Display the installer help message and options. |
---

### Option 2: One-Command Remote Installation (Standalone)
Use this option to install the framework directly from GitHub without cloning the repo. The installer will automatically download and unpack the latest release package.

#### A. Private Repository (Current)
Export your GitHub Personal Access Token (PAT) with read permissions, navigate to your target project folder, and run:

```bash
export GITHUB_TOKEN="your_personal_access_token_here"

curl -H "Authorization: token $GITHUB_TOKEN" -L \
  "https://raw.githubusercontent.com/devmunoz/baremetal-crew/master/install.sh" | bash
```

*Note: If you want to specify the target directory explicitly instead of using the current folder, pass it as a parameter using the `bash -s` syntax:*

```bash
curl -H "Authorization: token $GITHUB_TOKEN" -L \
  "https://raw.githubusercontent.com/devmunoz/baremetal-crew/master/install.sh" | bash -s -- /path/to/target/project
```

#### B. Public URL installation (not available yet)
Just run into your project folder:

```bash
cd /path/to/target/project
curl -L "https://raw.githubusercontent.com/devmunoz/baremetal-crew/master/install.sh" | bash
```

---
---

## 🛠️ Helper Utilities & Skills Management

Baremetal-Crew provides centralized CLI utilities under `.bmc-stuff/bin/`:

*   **`.bmc-stuff/bin/bmc-log`**: Manages execution state, phase transitions, and task logs in `.bmc-stuff/crew.db`.
*   **`.bmc-stuff/bin/bmc-index-skills`**: Clones and indexes pre-approved skills repositories into `.bmc-stuff/skills-cache/` and synchronizes matching skills under `.agents/skills/`.

### Skills Indexer & Updater CLI Options (`bmc-index-skills`)

| Flag / Option | Description |
| :--- | :--- |
| `-t`, `--target <path>` | Specify target project directory path (defaults to working directory). |
| `-c`, `--check` | Check local `.agents/skills/` for available updates without overwriting files. |
| `-u`, `--update-local` | Automatically update local `.agents/skills/` from primary crew skills and cache (default: enabled). |
| `--no-update-local` | Skip updating local `.agents/skills/`. |
| `-s`, `--silent` | Run silently without verbose terminal logs. |

Example usage:
```bash
# Index skills catalog and update matching .agents/skills in target project
.bmc-stuff/bin/bmc-index-skills --target /path/to/project

# Check for local skill updates without overwriting
.bmc-stuff/bin/bmc-index-skills --check
```

## 🌟 Credits & Skill Sources

The primary crew skills and advisory skills indexing catalogs are inspired by and sourced from the following repositories:
*   [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) – General software engineering agent skills.
*   [mattpocock/skills](https://github.com/mattpocock/skills) – Engineering triage, domain modeling, and testing skills.
*   [obra/superpowers](https://github.com/obra/superpowers) – Adversarial and verification skills.
*   [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) – Ultra-compressed token communication mode.
