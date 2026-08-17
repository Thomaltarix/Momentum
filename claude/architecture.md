# Architecture

## App layout

```
lib/
  core/
    theme/          — colors, typography, spacing tokens
    routing/         — go_router configuration
    db/              — Drift database class + migrations (shared by all features)
    notifications/   — flutter_local_notifications wrapper (thin: schedule/cancel primitives only)
  features/
    routines/        — todo/routine CRUD, scheduling, completion tracking
    health_sync/      — Health Connect integration (steps, workouts, nutrition, weight) plus manual entry for the metrics that support it
    gamification/     — XP, streaks, badges — listens to routines + health_sync
  app.dart
  main.dart
```

Each feature follows `data/` (repositories, Drift DAOs, `health` package calls), `domain/` (models, pure logic — recurrence rules, streak math, badge conditions), `presentation/` (screens, widgets, Riverpod providers). `core/` only holds infra genuinely shared by every feature — it is not a place to put anything that doesn't obviously belong to one feature.

## Data flow

```
Health Connect (Android OS) / HealthKit (iOS, later)      Typed directly into Momentum
   │  `health` package, read-only                              │
   ▼                                                            ▼
   └──────────────────  features/health_sync  ──────────────────┘
                   (per metric: DataSourceSettings picks one source, never both)
   │
   ▼
features/gamification  (listens to health_sync + routines, computes XP/streaks/badges)
   ▲
   │
features/routines  (local CRUD + scheduled notifications — Drift is the source of truth, no external dependency)
```

`health_sync` caches a daily snapshot in Drift rather than re-querying the OS API on every read. Two reasons: the Health Connect API can be slow/rate-limited, and a local snapshot gives Momentum a history even on days the OS query fails or permissions get briefly revoked.

Weight, workouts, and nutrition can each be switched to manual entry instead — `HealthSyncRepository` checks that metric's `DataSourceSettings` row and reads from a local `*Entries` table instead of Health Connect (see `claude/data-model.md`). The two sources are never merged for the same metric: mixing would double-count (e.g. a workout typed in by hand, then synced again by Lyfta once a wearable is set up). Still read-only towards Health Connect itself — manual entries never get written back to it.

## Dependency direction

Presentation → domain → data, within each feature. Across features: `gamification` depends on `routines` and `health_sync` (reads their domain models). `routines` and `health_sync` never import from `gamification`. No feature imports from `presentation/` of another feature — cross-feature communication happens through domain models and Riverpod providers, not shared widgets.

## Platform target

Primary dev/test target is Android (no wearable involved — steps come from the phone sensor via Health Connect, workouts from Lyfta, nutrition from MyFitnessPal, both synced into Health Connect). The `health` package exposes the same API for HealthKit, so iOS support is architecturally possible later, but won't be tested until there's an iOS device to verify permission flows and data shapes on.

## Why no backend (for now)

Single-user, single-device app — all state lives locally in Drift. A backend would be speculative complexity today. Revisit only when a real requirement shows up: multi-device sync, or a social/leaderboard gamification feature (see `roadmap.md`, explicitly deferred).
