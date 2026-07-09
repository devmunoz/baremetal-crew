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
mkdir -p "${TARGET_DIR}/.bmc-stuff"
mkdir -p "${TARGET_DIR}/.agents/skills"

# 2. Copy Knowledge Base and Reference Templates
echo "-> Copying Knowledge Base and templates..."
cp -R "${SRC_DIR}/framework/knowledge" "${TARGET_DIR}/.bmc-stuff/"
cp -R "${SRC_DIR}/framework/templates" "${TARGET_DIR}/.bmc-stuff/"

# 3. Copy crew-log CLI script directly into .bmc-stuff/
echo "-> Copying crew-log logging helper..."
cp "${SRC_DIR}/framework/bin/crew-log" "${TARGET_DIR}/.bmc-stuff/crew-log"
chmod +x "${TARGET_DIR}/.bmc-stuff/crew-log"

# 4. Copy Manifesto to .bmc-stuff/ for reference
echo "-> Copying Manifesto..."
cp "${SRC_DIR}/framework/MANIFESTO.md" "${TARGET_DIR}/.bmc-stuff/MANIFESTO.md"

# 5. Copy PO, SA, Dev, and QA skills to target .agents/skills/
echo "-> Installing primary skills to .agents/skills/..."
# We recreate the folder structure for each skill to ensure SKILL.md is in the right place
for skill_dir in "${SRC_DIR}/framework/skills/"*; do
    if [ -d "${skill_dir}" ]; then
        skill_name=$(basename "${skill_dir}")
        mkdir -p "${TARGET_DIR}/.agents/skills/${skill_name}"
        cp -R "${skill_dir}/"* "${TARGET_DIR}/.agents/skills/${skill_name}/"
    fi
done

echo "============================================="
echo " Baremetal-Crew successfully installed!"
echo " Check '.bmc-stuff/MANIFESTO.md' for guidelines."
echo " Events will log to '.bmc-stuff/crew.db'."
echo "============================================="
