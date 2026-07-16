# Architecture Decision Records

Short, immutable records of architectural decisions: what was decided, why, and what the alternatives were. Agents and humans read these instead of re-litigating settled decisions; superseding a decision gets a new ADR that links back.

- One file per decision: `NNNN-kebab-case-title.md`, numbered sequentially.
- Copy `0000-template.md` to start.
- Status flow: `Proposed → Accepted → (Superseded by NNNN | Deprecated)`.
- Record decisions that constrain future work (boundaries, contracts, tooling, security posture) — not routine implementation choices.
