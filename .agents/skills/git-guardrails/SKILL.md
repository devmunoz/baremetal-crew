---
name: git-guardrails
description: Active session guardrails to prevent unsafe git operations (push, reset --hard, clean -fd, branch -D, checkout ., restore ., rebase, stash drop/clear/pop). Use when user wants to enforce git safety and require manual user handling for destructive git actions.
---

# Git Guardrails

ACTIVE FOR THIS SESSION ONCE LOADED.

## Purpose

Enforce strict safety guardrails preventing the AI agent from executing dangerous, destructive, or history-rewriting git actions in the workspace. All forbidden operations must be delegated to the human user to execute manually in their host terminal.

## Forbidden Git Actions

The active session MUST NOT run, invoke, or execute any of the following git commands:

- **`git push`** (all variants, including `git push --force`, `git push origin ...`, `git push -u`, `git push --tags`)
- **`git reset --hard`** (as well as `git reset --merge`, `git reset --keep`)
- **`git clean -f` / `git clean -fd` / `git clean -fx`** (destructive untracked file deletion)
- **`git branch -D`** (forced deletion of unmerged branches)
- **`git checkout .` / `git restore .`** (destructive wiping of all uncommitted workspace changes)
- **`git rebase`** (all variants, including `git rebase --continue`, `git rebase --abort`, `git rebase -i`)
- **`git stash drop` / `git stash clear` / `git stash pop`** (destructive stash manipulation)

## Session Execution Rules

1. **Stop & Delegate:** When a task requires any forbidden git operation, stop execution of that step immediately.
2. **User Hand-off:** Inform the user clearly which git command needs to be run and ask them to run it manually in their terminal.
3. **Wait for Confirmation:** Resume automated work only after the user confirms completion of the manual git action.
4. **Safe Commands Allowed:** Standard read-only and safe local staging commands remain allowed:
   - `git status`, `git diff`, `git log`
   - `git add <file>` (explicit file staging)
   - `git commit -m "..."`
   - `git checkout -b <branch>`, `git checkout <branch>` (branch switching, NOT `git checkout .`)
   - `git branch` (listing), `git branch -d <merged-branch>`

## Verification

Before executing any `git` tool or shell command, check against the **Forbidden Git Actions** list. If matched, HALT and delegate to the user.
