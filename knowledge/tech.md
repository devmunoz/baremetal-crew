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
*   **ARCHITECTURE.md:** Must define the overall system structure. It must strictly comply with the official ARCHITECTURE.md specification (timajwilliams/architecture), including the following numbered h2 sections: 1. Project Structure, 2. High-Level System Diagram, 3. Core Components, 4. Data Stores, 5. External Integrations / APIs, 6. Deployment & Infrastructure, 7. Security Considerations, 8. Development & Testing Environment, 9. Future Considerations / Roadmap, 10. Project Identification, and 11. Glossary / Acronyms.
*   **DESIGN.md:** Defines the visual identity and style guide of the application. It must strictly adhere to the official DESIGN.md specification (spec.md), including the YAML frontmatter for design tokens (colors, typography, rounded, spacing, components) and the designated h2 body sections: Overview, Colors, Typography, Layout, Elevation & Depth, Shapes, Components, and Do's and Don'ts.
*   **README.md:** Must document local execution, dependencies, and environment variables.
*   **Slice-Agnostic Standard:** Root documentation (`ARCHITECTURE.md`, `DESIGN.md`, `README.md`) and production source code MUST be strictly slice-agnostic. Slices (`SXX`) are management artifacts used in `.bmc-stuff/work/` and database tracking. Slice IDs must NEVER appear in root documentation files, code comments, or application source code.
*   **Dev Rule:** The Fullstack Developer is responsible for updating the affected documentation files as part of their tasks.
## 5. Local SKILLS Specification (agentskills.io)
*   Reusable technical setups or tool executions (e.g. `fastapi-setup`, `docker-compose-setup`) must be stored in the local `.agents/skills/` folder at the root of the repository.
*   Each skill must contain a `SKILL.md` file following the agentskills.io standard.
*   **Indexing & Synchronization:** Local skills under `.agents/skills/` are maintained and synchronized using `.bmc-stuff/bin/bmc-index-skills`. The script clones pre-approved skills repositories into `.bmc-stuff/skills-cache/` and updates existing local skills matching primary crew skills (`crew/`) or cached indexes.
