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

# Support environment variable override
if [ "${BMC_INDEX_SKILLS:-}" = "true" ]; then
    INDEX_SKILLS=true
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --index-skills)
            INDEX_SKILLS=true
            shift
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
    REPO="devmunoz/baremetal-crew"

    if [ -n "${GITHUB_TOKEN:-}" ]; then
        echo "Using GITHUB_TOKEN for authenticated private download..."
        # 1. Fetch latest release metadata
        RELEASE_JSON=$(curl -s -f -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/${REPO}/releases/latest")
        # 2. Extract asset URL for baremetal-crew.tar.gz (without using jq to avoid dependencies)
        ASSET_URL=$(echo "${RELEASE_JSON}" | grep -m 1 -o '"url": "[^"]*assets/[0-9]*"' | cut -d'"' -f4 || true)
        
        if [ -z "${ASSET_URL}" ]; then
            echo "Error: Could not find 'baremetal-crew.tar.gz' asset URL in release metadata."
            exit 1
        fi
        
        echo "Downloading asset..."
        curl -L -f -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/octet-stream" -o "${TARBALL_PATH}" "${ASSET_URL}"
    else
        echo "No GITHUB_TOKEN found. Attempting public download..."
        PUBLIC_URL="https://github.com/devmunoz/baremetal-crew/releases/latest/download/baremetal-crew.tar.gz"
        if ! curl -L -f -o "${TARBALL_PATH}" "${PUBLIC_URL}"; then
            echo
            echo "Error: Public download failed."
            echo "If the repository is private, please export GITHUB_TOKEN with read permissions before running."
            exit 1
        fi
    fi

    echo "-> Unpacking release package..."
    tar -xzf "${TARBALL_PATH}" -C "${TMP_DOWNLOAD_DIR}"
    
    # Re-route the source directory to point to the unpacked contents
    SRC_DIR="${TMP_DOWNLOAD_DIR}"
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

# 5. Initialize or Merge AGENTS.md in the target root
if [ ! -f "${TARGET_DIR}/AGENTS.md" ]; then
    echo "-> Initializing AGENTS.md in target project root..."
    cp "${SRC_DIR}/knowledge/templates/AGENTS.md" "${TARGET_DIR}/AGENTS.md"
else
    echo "-> Existing AGENTS.md found in target root. Skipping overwrite."
    echo "   The Software Architect (SA) or Tech Guru will manually merge the Baremetal-Crew integration section."
fi

# 6. Optional indexing of skills
echo
if [ "${INDEX_SKILLS}" = "true" ]; then
    echo "-> Executing pre-approved skills indexing..."
    "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills"
elif [ -t 0 ]; then
    read -p "Do you want to clone and index the pre-approved skills repositories now? (Requires git & internet) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "${TARGET_DIR}/.bmc-stuff/bin/bmc-index-skills"
    else
        echo "Skipping skills indexing. You can run '.bmc-stuff/bin/bmc-index-skills' at any time."
    fi
else
    echo "Non-interactive shell detected. Skipping skills indexing."
    echo "You can run '.bmc-stuff/bin/bmc-index-skills' manually or use '--index-skills' flag / 'BMC_INDEX_SKILLS=true' env var."
fi

echo "============================================="
echo " Baremetal-Crew successfully installed (Version: ${VERSION})!"
echo " Check '.bmc-stuff/knowledge/MANIFESTO.md' for guidelines."
echo " Events will log to '.bmc-stuff/crew.db'."
echo "============================================="
