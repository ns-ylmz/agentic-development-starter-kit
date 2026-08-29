---
name: setup-project
description: Use once, right after dropping this starter kit into a new project (or starting a project from it), to adapt every placeholder to the project's actual shape.
---

# Setup Project Workflow

When explicitly requested, this skill configures the initial shape of the project based on the user's stack and layout choices.

1. **Project shape and stack**: ask the user what the project's technology stack is and what the architectural layout should be (e.g., monolithic backend, client-server, microservices, etc.).
2. **Domain boundaries**: based on the response, generate or update `.ai/guidelines/architecture.md` to reflect the specific layers of the project.
3. **Tooling and CI**: propose a `.gitignore`, appropriate linting/formatting configurations (e.g., `.prettierrc`, `ruff.toml`, etc.), and a basic CI workflow if one doesn't exist.
4. **Docs**: Update `README.md` to reflect the project's name and purpose.
5. **Delete self**: After all changes are confirmed and applied, remove this skill file as it is no longer needed.
