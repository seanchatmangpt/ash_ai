# Agent Operating Contract

Scope: repository-wide unless a deeper `AGENTS.md` narrows a subtree. Live tree evidence outranks stale prose.

Resolve repo/ref/base to an exact commit before editing. Read applicable root+nested doctrine, README/architecture, manifests, task runners, CI, generation, and release policy. Preserve interfaces, authority, receipts/replay, generated/manual boundaries, compatibility, and maximal reversible lawful options; apply Chesterton's fence before deleting a boundary.

Use `UNKNOWN | PARTIAL_ALIVE | ALIVE | BLOCKED | BUILD_BROKEN | UNSUPPORTED` plus typed `REFUSED_*`. `ALIVE` requires observed execution of the exact admitted subject. Track observed/admitted/executed/changed/verified/inferred/refused/blocked/unsupported separately; inspection is not execution.

`A = μ(O*)`; `R = receipt(A)`. Separate `SELECT`, `CONSTRUCT`, `DO`. Planner/model/generator/proof/hook output has no ambient execution authority; hooks manufacture intents, never actuate. Consequential `DO` uses the admitted receipt-bearing boundary.

Follow `parse → orient → resolve → materialize → read doctrine → inspect → admit/refuse → diagnose/repair → construct → actuate → receipt → replay → standing`. Prefer the existing lawful path and smallest coherent diff. Generated artifacts are projections: edit their owning source. No fabricated evidence, weakened tests, unit substitution for requested integration/e2e proof, or unrelated refactors.

Acceptance: exact user behavior/command → live documented repo command → narrowest equivalent. Preserve command/exit/diagnostic on failure, form a new hypothesis, repair narrowly, rerun the boundary. CI supplements local proof; it is not truth.

Unless explicitly instructed otherwise: purpose branch, intentional commit, non-force push, draft PR, no merge. Final receipt identifies repo/base/tree, transports/failures, changes/generated status, commands/exits, replay, branch/SHA/PR, standing, and falsifiers.