# TECHNICAL STANDARDS & CATALOG

This document defines the pre-approved technology stacks, architectural conventions, and repository standards for the Baremetal-Crew.

---

## 1. Monolithic Architecture
*   All projects must be developed as a single codebase (monolith) to reduce coordination overhead and local setup complexity.

## 2. Pre-approved Tech Stack Catalog
The Software Architect (SA) must choose technologies exclusively from this catalog:
*   **Languages & Core Frameworks:**
    *   **JavaScript/TypeScript:** Node.js (Express, Fastify, Nest.js), Native HTML/CSS/JS (no framework), React, Next.js.
    *   **Python:** FastAPI, Flask.
    *   **Go:** Standard library, Gin, Fiber.
*   **Database Engines:**
    *   **SQLite:** Default choice for local development (zero configuration).
    *   **PostgreSQL:** Utilized when explicit relational scaling is needed, run via local Docker Compose.
*   **Testing Frameworks:**
    *   Playwright, Cypress, Jest, Vitest, unittest, pytest.

## 3. Infrastructure & System Dependencies
*   **Container-First Infrastructure:** All infrastructure components (e.g., PostgreSQL, Redis) and external system utilities/binaries (e.g., `ffmpeg`, `imagemagick`) that are not standard language runtimes must be containerized and run via local `docker-compose.yml`.
*   **Host-Level Isolation:** The repository code must not rely on globally installed binaries on the user's host machine, unless they are standard dev tools (e.g. `node`, `python`, `git`, `docker`) that have been checked and confirmed to be present.

## 4. Living Documentation Standard

To prevent documentation from going out of sync with the implementation:
*   **ARCHITECTURE.md:** Must document database schemas, folder layout, API endpoints, and architectural patterns of the codebase.
*   **DESIGN.md:** Documents UX/UI design decisions, UI component structure, design tokens, and user flow principles.
*   **README.md:** Must document local execution, dependencies, and environment variables.
*   **Dev Rule:** The Fullstack Developer is responsible for updating the affected documentation files as part of their tasks.

## 4. Local SKILLS Specification (agentskills.io)
*   Reusable technical setups or tool executions (e.g. `fastapi-setup`, `docker-compose-setup`) must be stored in the local `.skills/` folder at the root of the repository.
*   Each skill must contain a `SKILL.md` file following the agentskills.io standard.
