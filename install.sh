#!/usr/bin/env bash

# Baremetal-Crew Installer Script
# Usage:
#   ./install.sh [target_directory]
# Example:
#   ./install.sh .

set -euo pipefail

# Determine source directory (where this script resides)
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]:-$0}" )" && pwd )"
# Parse arguments
TARGET_DIR="."
INDEX_SKILLS=false
YES_TO_ALL=false

CONFIG_RUNTIME="${BMC_RUNTIME:-docker}"
CONFIG_WORKTREES="${BMC_WORKTREES:-false}"
CONFIG_MAX_PING_PONG="${BMC_MAX_PING_PONG:-3}"
CONFIG_COMMUNICATION="${BMC_COMMUNICATION:-ste100}"
CONFIG_PR_DEMO_MODE="${BMC_PR_DEMO_MODE:-reference}"

# Support environment variable override
if [ "${BMC_INDEX_SKILLS:-}" = "true" ]; then
    INDEX_SKILLS=true
fi

print_help() {
    echo "Baremetal-Crew Installer Script"
    echo
    echo "Usage:"
    echo "  $0 [target_directory] [options]"
    echo
    echo "Options:"
    echo "  -h, --help            Show this help message and exit"
    echo "  -y, --yes             Automatic yes to prompts (non-interactive friendly)"
    echo "  -i, --index-skills     Clone and index the pre-approved skills repositories"
    echo "  --runtime <docker|local>  Set target runtime environment (default: docker)"
    echo "  --worktrees           Enable git worktree workspace isolation (default: false)"
    echo "  --no-worktrees        Disable git worktree workspace isolation"
    echo "  --max-ping-pong <N>   Set max ping-pong retries between Dev/QA (default: 3)"
    echo "  --communication <ste100|caveman> Set default communication standard (default: ste100)"
    echo "  --pr-demo-mode <reference|embed|minimal> Set DEMO placement in Pull Requests (default: reference)"
    echo
    echo "Environment Variables:"
    echo "  BMC_INDEX_SKILLS      Set to 'true' to force skills indexing"
    echo "  BMC_RUNTIME           Set target runtime (docker/local)"
    echo "  BMC_WORKTREES         Set worktrees enabled (true/false)"
    echo "  BMC_MAX_PING_PONG     Set max ping-pong retries"
    echo "  BMC_COMMUNICATION     Set communication mode (ste100/caveman)"
    echo "  BMC_PR_DEMO_MODE      Set PR DEMO mode (reference/embed/minimal)"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            print_help
            exit 0
            ;;
        -y|--yes)
            YES_TO_ALL=true
            shift
            ;;
        -i|--index-skills)
            INDEX_SKILLS=true
            shift
            ;;
        --runtime)
            CONFIG_RUNTIME="$2"
            shift 2
            ;;
        --worktrees)
            CONFIG_WORKTREES=true
            shift
            ;;
        --no-worktrees)
            CONFIG_WORKTREES=false
            shift
            ;;
        --max-ping-pong)
            CONFIG_MAX_PING_PONG="$2"
            shift 2
            ;;
        --communication)
            CONFIG_COMMUNICATION="$2"
            shift 2
            ;;
        --pr-demo-mode)
            CONFIG_PR_DEMO_MODE="$2"
            shift 2
            ;;
        -*)
            echo "Error: Unknown option $1"
            echo "Use -h or --help for usage information."
            exit 1
            ;;
        *)
            TARGET_DIR="$1"
            shift
            ;;
    esac
done

# Resolve target directory to absolute path
TARGET_DIR="$( cd "${TARGET_DIR}" && pwd )"

echo "============================================="
echo " Installing Baremetal-Crew..."
echo " Source: ${SRC_DIR}"
echo " Target: ${TARGET_DIR}"
echo "============================================="

# Detect standalone execution
# If running standalone (e.g. downloaded via curl), these directories won't exist locally
RUNNING_STANDALONE=false
if [ ! -d "${SRC_DIR}/knowledge" ] || [ ! -d "${SRC_DIR}/crew" ] || [ ! -d "${SRC_DIR}/bin" ]; then
    RUNNING_STANDALONE=true
fi

# Clean up variables if trap is called
TMP_DOWNLOAD_DIR=""
cleanup_download() {
    if [ -n "${TMP_DOWNLOAD_DIR}" ] && [ -d "${TMP_DOWNLOAD_DIR}" ]; then
        echo "-> Cleaning up temporary files..."
        rm -rf "${TMP_DOWNLOAD_DIR}"
    fi
}
trap cleanup_download EXIT INT TERM

# Helper to insert version metadata into MANIFESTO.md
update_manifesto_title() {
    local file="$1"
    local version="$2"
    if [ -f "$file" ]; then
        local tmp_file
        tmp_file=$(mktemp)
        local found=false
        while IFS= read -r raw_line || [ -n "$raw_line" ]; do
            local line
            line=$(echo "$raw_line" | tr -d '\r')
            if [ "$found" = false ] && [ "$line" = "# BAREMETAL-CREW MANIFESTO: THE FRAMEWORK" ]; then
                echo "# BAREMETAL-CREW MANIFESTO: THE FRAMEWORK - ${version}" >> "$tmp_file"
                found=true
            else
                echo "$raw_line" >> "$tmp_file"
            fi
        done < "$file"
        mv "$tmp_file" "$file"
    fi
}

VERSION="unknown"

if [ "${RUNNING_STANDALONE}" = true ]; then
    echo "-> Standalone installation detected. Fetching latest release package..."
    TMP_DOWNLOAD_DIR=$(mktemp -d)
    TARBALL_PATH="${TMP_DOWNLOAD_DIR}/baremetal-crew.tar.gz"
    PUBLIC_URL="https://github.com/devmunoz/baremetal-crew/releases/latest/download/baremetal-crew.tar.gz"
    if ! curl -L -f -o "${TARBALL_PATH}" "${PUBLIC_URL}"; then
        echo
        echo "Error: Release download failed from ${PUBLIC_URL}."
        exit 1
    fi

    echo "-> Unpacking release package..."
    tar -xzf "${TARBALL_PATH}" -C "${TMP_DOWNLOAD_DIR}"
    
    # Re-route the source directory to point to the unpacked contents
    SRC_DIR="${TMP_DOWNLOAD_DIR}"
fi

# Confirmation prompt in interactive mode
if [ -t 0 ] && [ "${YES_TO_ALL}" = "false" ]; then
    echo "============================================="
    echo " Baremetal-Crew Installation Information"
    echo " Target: ${TARGET_DIR}"
    echo
    echo " The following changes will be made in the target directory:"
    echo "   - Create: .bmc-stuff/ (knowledge base and CLI tools)"
    echo "   - Create: .agents/skills/ (crew role skill definitions)"
    echo "   - Initialize or update: AGENTS.md (in the repository root)"
    echo "   - Initialize: .bmc-stuff/config.json (framework configuration)"
    echo "============================================="
    read -p "Do you want to proceed with the installation? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation aborted by the user."
        exit 0
    fi

    read -p "Runtime environment [docker/local] (default: ${CONFIG_RUNTIME}): " -r input_runtime
    if [ -n "${input_runtime}" ]; then
        CONFIG_RUNTIME="${input_runtime}"
    fi

    read -p "Enable git worktree workspace isolation? [y/N] (default: ${CONFIG_WORKTREES}): " -n 1 -r input_wt
    echo
    if [[ $input_wt =~ ^[Yy]$ ]]; then
        CONFIG_WORKTREES=true
    elif [[ $input_wt =~ ^[Nn]$ ]]; then
        CONFIG_WORKTREES=false
    fi
fi

# 1. Create target sandbox directories
echo "-> Creating directories..."
mkdir -p "${TARGET_DIR}/.bmc-stuff/bin"
mkdir -p "${TARGET_DIR}/.bmc-stuff/work"
mkdir -p "${TARGET_DIR}/.agents/skills"

# Determine version
if [ -f "${SRC_DIR}/knowledge/VERSION" ]; then
    VERSION=$(cat "${SRC_DIR}/knowledge/VERSION")
else
    VERSION=$(git -C "${SRC_DIR}" describe --tags --abbrev=0 2>/dev/null || echo "local")
fi

# 2. Copy Knowledge Base (including templates)
echo "-> Copying Knowledge Base and templates..."
cp -R "${SRC_DIR}/knowledge" "${TARGET_DIR}/.bmc-stuff/"
update_manifesto_title "${TARGET_DIR}/.bmc-stuff/knowledge/MANIFESTO.md" "${VERSION}"
rm -f "${TARGET_DIR}/.bmc-stuff/knowledge/VERSION"

# 3. Copy CLI helpers directly into .bmc-stuff/bin/
echo "-> Copying CLI helpers..."
cp "${SRC_DIR}/bin/bmc-log" "${TARGET_DIR}/.bmc-stuff/bin/bmc-log"
chmod +x "${TARGET_DIR}/.bmc-stuff/bin/bmc-log"
cp "${SRC_DIR}/bin/bmc-index-skills" "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills"
chmod +x "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills"
cp "${SRC_DIR}/bin/bmc-config" "${TARGET_DIR}/.bmc-stuff/bin/bmc-config"
chmod +x "${TARGET_DIR}/.bmc-stuff/bin/bmc-config"
ln -sf .bmc-stuff/bin/bmc-log "${TARGET_DIR}/bmc-log"
ln -sf .bmc-stuff/bin/bmc-config "${TARGET_DIR}/bmc-config"

# 4. Initialize Framework Configuration (.bmc-stuff/config.json)
echo "-> Initializing framework configuration..."
"${TARGET_DIR}/.bmc-stuff/bin/bmc-config" init \
    --runtime "${CONFIG_RUNTIME}" \
    $([ "${CONFIG_WORKTREES}" = "true" ] && echo "--worktrees" || echo "--no-worktrees") \
    --max-ping-pong "${CONFIG_MAX_PING_PONG}" \
    --communication "${CONFIG_COMMUNICATION}" \
    --pr-demo-mode "${CONFIG_PR_DEMO_MODE}"

# 5. Copy PO, SA, Dev, QA, and Guru skills to target .agents/skills/
echo "-> Installing primary crew skills to .agents/skills/..."
# We recreate the folder structure for each crew skill to ensure SKILL.md is in the right place
for crew_dir in "${SRC_DIR}/crew/"*; do
    if [ -d "${crew_dir}" ]; then
        crew_name=$(basename "${crew_dir}")
        mkdir -p "${TARGET_DIR}/.agents/skills/${crew_name}"
        cp -R "${crew_dir}/"* "${TARGET_DIR}/.agents/skills/${crew_name}/"
    fi
done

# 6. Initialize or Merge AGENTS.md in the target root
if [ ! -f "${TARGET_DIR}/AGENTS.md" ]; then
    echo "-> Initializing AGENTS.md in target project root..."
    cp "${SRC_DIR}/knowledge/templates/AGENTS.md" "${TARGET_DIR}/AGENTS.md"
else
    echo "-> Existing AGENTS.md found in target root."
    if ! grep -q "Baremetal-Crew" "${TARGET_DIR}/AGENTS.md"; then
        echo "   No Baremetal-Crew reference found. Appending integration block..."
        printf "\n## 🤖 Baremetal-Crew (BMC) Integration\n> [!IMPORTANT]\n> The CBO must check this \`AGENTS.md\` file against the framework guidelines (Setup, Build, Testing, and Conventions) to align both when running the agentic process with the framework for the first time.\n*   This project is developed using the Baremetal-Crew framework.\n*   For roles, workflows, phase transitions, and guardrails, refer to the [Manifesto](.bmc-stuff/knowledge/MANIFESTO.md) only when executing crew role transitions or logging tasks.\n*   Find the active slice task backlog in \`.bmc-stuff/work/SXX-BLUEPRINT.md\` (where \`SXX\` is the active slice ID, e.g. \`S01\`). To determine the active slice(s), use the centralized helper command: \`.bmc-stuff/bin/bmc-log active\`.\n" >> "${TARGET_DIR}/AGENTS.md"
    else
        echo "   Baremetal-Crew reference already present. Skipping merge."
    fi
fi

# 7. Optional indexing of skills
echo
if [ "${INDEX_SKILLS}" = "true" ]; then
    echo "-> Executing pre-approved skills indexing and updating existing .agents/skills..."
    "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills" --target "${TARGET_DIR}"
elif [ -t 0 ]; then
    read -p "Do you want to clone and index the pre-approved skills repositories now? (Requires git & internet) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills" --target "${TARGET_DIR}"
    else
        echo "Skipping skills indexing. You can run '.bmc-stuff/bin/bmc-index-skills' at any time."
    fi
else
    echo "Non-interactive shell detected. Skipping skills indexing."
    echo "You can run '.bmc-stuff/bin/bmc-index-skills' manually or use '-i' / '--index-skills' flag / 'BMC_INDEX_SKILLS=true' env var."
fi

echo "============================================="
echo " Baremetal-Crew successfully installed (Version: ${VERSION})!"
echo " Check '.bmc-stuff/knowledge/MANIFESTO.md' for guidelines."
echo " Events will log to '.bmc-stuff/crew.db'."
echo "============================================="
