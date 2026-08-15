# CLAUDE.md

Durable engineering principles for this repository. This file is auto-loaded every session and should rarely change — it describes *how* to work, not *what* the app currently looks like. For living, project-specific reference material (architecture, data model, roadmap), see [`claude/CLAUDE.md`](claude/CLAUDE.md).

## General philosophy

- Favor simplicity over unnecessary abstractions.
- Prefer readable code over clever code.
- Every file should have a clear responsibility.
- Avoid overengineering.
- Keep the codebase scalable but lightweight.
- Think as if the project will still be maintained in 5 years.
- If a pattern does not provide clear value, do not introduce it.

## What this app is

Momentum is a solo, gamified daily-habit app: routines with scheduled notifications, plus steps/workouts/nutrition read from Health Connect (Android) — not tracked from scratch. Gamification (XP, streaks, badges) is a layer that reacts to routine completions and health data, not a source of truth for anything.

## Architecture

- Feature-first, not layer-first: `lib/features/<feature>/{data,domain,presentation}`.
- `lib/core/` is only for genuinely cross-cutting infra (routing, theme, local database, notification plugin wrapper) — not a dumping ground.
- Dependency direction within a feature: presentation → domain → data. Domain code never imports Flutter widgets.
- Across features: `gamification` depends on `routines` and `health_sync` (reads their domain models). `routines` and `health_sync` never depend on `gamification`. No circular dependencies.
- Momentum does not build its own sensors or nutrition database. Steps, workouts, and nutrition are read-only from Health Connect via the `health` package. See [`claude/architecture.md`](claude/architecture.md).
- No backend. Single user, single device, all state local. Revisit only if multi-device sync or social features are actually built (see roadmap).

## Flutter / Dart

- Null safety, strict analysis (`flutter_lints` plus stricter rules where it catches real bugs).
- State management: Riverpod (`flutter_riverpod`). Providers live next to the feature that owns them, not in a global `providers/` folder.
- Prefer `ConsumerWidget`/`StatelessWidget` over `StatefulWidget` when the state belongs in a provider.
- Local persistence: Drift (typed SQLite). See [`claude/data-model.md`](claude/data-model.md).
- Routing: `go_router`.
- Avoid writing platform-channel code unless a maintained package genuinely doesn't cover the need.

## Health data

- The `health` package is the single integration point for Health Connect (Android) / HealthKit (iOS, later). No other code talks to platform health APIs directly.
- Read-only, always. Momentum never writes back to Health Connect.
- Explain in-app why a permission is needed before triggering the OS prompt.

## Gamification

- Rules-based and deterministic: streaks, XP thresholds, badge conditions. No scoring "magic" or hidden weighting.
- Gamification state is derived and cacheable, recomputable from routine completions and health snapshots — never the only place a fact lives.

## Naming

- Use meaningful names.
- Avoid abbreviations.
- Avoid generic names like `Utils`, `Manager`, or `Helper`.
- File names should reflect their content.

## Code Style

- Keep functions short.
- Prefer early returns.
- Avoid nested conditionals.
- Avoid duplicated code.
- Comment WHY instead of WHAT.
- Self-documenting code first.

## Testing

- Unit tests for gamification rules and streak/scheduling logic — these are pure functions, keep them that way so they're cheap to test.
- Widget tests for feature screens where interaction logic (not just layout) is involved.

## Git

- Small commits.
- Meaningful commit messages.
- One logical change per commit.
- Never commit directly on `main` — always work on a feature/topic branch, even for small or solo changes.

## Project Quality

Code should be production-ready, modular, and easy to extend, even though this is a solo project — assume future-you is the one who has to maintain it.

## Decision Making

Whenever several implementations are possible:

1. Choose the simplest maintainable solution.
2. Explain why it is preferred.
3. Mention trade-offs when relevant.

Never choose complexity just because it looks impressive.

## Personal Preferences

- Solo gamification only for now — no social/leaderboard, no backend (see `claude/roadmap.md` for what's deferred and why).
- The owner prefers backend engineering generally, but this is a mobile-first solo project — keep it lean and resist adding a backend until multi-device sync or social features are an actual, not hypothetical, requirement.
- Dislikes boilerplate, overengineered architecture, duplicated logic, "AI-looking" code.

## Before writing code

Before implementing a new feature:

- explain the architecture
- explain where files will be created
- explain why this approach is chosen

Only then start implementing.
