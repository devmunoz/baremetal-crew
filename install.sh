#!/usr/bin/env bash

# Baremetal-Crew Installer Script
# Usage:
#   ./install.sh [target_directory]
# Example:
#   ./install.sh .

set -euo pipefail

# Determine source directory (where this script resides)
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET_DIR="${1:-.}"

# Resolve target directory to absolute path
TARGET_DIR="$( cd "${TARGET_DIR}" && pwd )"

echo "============================================="
echo " Installing Baremetal-Crew..."
echo " Source: ${SRC_DIR}"
echo " Target: ${TARGET_DIR}"
echo "============================================="

# 1. Create target sandbox directories
echo "-> Creating directories..."
mkdir -p "${TARGET_DIR}/.bmc-stuff/bin"
mkdir -p "${TARGET_DIR}/.bmc-stuff/work"
mkdir -p "${TARGET_DIR}/.agents/skills"

# 2. Copy Knowledge Base (including templates)
echo "-> Copying Knowledge Base and templates..."
cp -R "${SRC_DIR}/knowledge" "${TARGET_DIR}/.bmc-stuff/"

# 3. Copy CLI helpers directly into .bmc-stuff/bin/
echo "-> Copying CLI helpers..."
cp "${SRC_DIR}/bin/bmc-log" "${TARGET_DIR}/.bmc-stuff/bin/bmc-log"
chmod +x "${TARGET_DIR}/.bmc-stuff/bin/bmc-log"
cp "${SRC_DIR}/bin/bmc-index-skills" "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills"
chmod +x "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills"

# 4. Copy PO, SA, Dev, QA, and Guru skills to target .agents/skills/
echo "-> Installing primary crew skills to .agents/skills/..."
# We recreate the folder structure for each crew skill to ensure SKILL.md is in the right place
for crew_dir in "${SRC_DIR}/crew/"*; do
    if [ -d "${crew_dir}" ]; then
        crew_name=$(basename "${crew_dir}")
        mkdir -p "${TARGET_DIR}/.agents/skills/${crew_name}"
        cp -R "${crew_dir}/"* "${TARGET_DIR}/.agents/skills/${crew_name}/"
    fi
done

# 5. Optional indexing of skills
echo
if [ -t 0 ]; then
    read -p "Do you want to clone and index the pre-approved skills repositories now? (Requires git & internet) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills"
    else
        echo "Skipping skills indexing. You can run '.bmc-stuff/bin/bmc-index-skills' at any time."
    fi
else
    echo "Non-interactive shell detected. Skipping skills indexing."
    echo "You can run '.bmc-stuff/bin/bmc-index-skills' manually."
fi

echo "============================================="
echo " Baremetal-Crew successfully installed!"
echo " Check '.bmc-stuff/knowledge/MANIFESTO.md' for guidelines."
echo " Events will log to '.bmc-stuff/crew.db'."
echo "============================================="
