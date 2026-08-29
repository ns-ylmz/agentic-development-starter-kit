---
name: start-task
description: >-
  Use to initiate a new bounded task. Ensures a fresh state on main, creates a
  new branch, sets up the planning template, and drafts the initial task
  boundaries before implementation begins.
---

# `start-task` Skill

You are initiating a new task following the project's Agentic Git Collaboration Workflow. Do NOT write any application code yet.

Follow these steps exactly in order:

1.  **Fresh Start:**
    *   Switch to the `main` branch (`git checkout main`).
    *   Pull the latest changes (`git pull origin main`).

2.  **Branch Creation:**
    *   Generate a branch name following Conventional Commits format based on the user's request (e.g., `feat/login-page`, `fix/header-alignment`, `refactor/api-client`).
    *   Create and switch to the new branch (`git checkout -b <branch-name>`).

3.  **Template Setup:**
    *   Copy `planning/templates/task-plan.md` to `planning/active/<branch-name-without-type>.md`. (For example, if branch is `feat/login-page`, create `planning/active/login-page.md`).

4.  **Initial Scoping:**
    *   Based on the user's prompt, fill out the `## Objective`, `## Context`, and `## Scope & Boundaries` sections of the newly created markdown file.
    *   To fill out the boundaries accurately, review `.ai/domain-boundaries.md` and check the directory structure of the project. Specify exactly which directories will be modified and which ones are strictly out of bounds.

5.  **User Review:**
    *   Present a summary of the drafted task plan to the user.
    *   Ask the user: "Does this plan and scope look correct? If so, we can proceed with the `implement` skill, or I can refine the boundaries based on your feedback."
