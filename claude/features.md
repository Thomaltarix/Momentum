# Features

## Feature folder convention

Every feature under `lib/features/<name>/` has the same three subfolders, only created once they have content (don't scaffold empty folders):

- `data/` — Drift DAOs/repositories, `health` package calls, anything that talks to a database or an external API.
- `domain/` — plain Dart models and pure logic (recurrence rules, streak calculation, badge conditions). No Flutter imports here — this is what unit tests target.
- `presentation/` — screens, widgets, and the Riverpod providers that wire `domain`/`data` into the UI.

## State management

Riverpod (`flutter_riverpod`), no code generation (`riverpod_generator`) unless the provider count grows enough that the boilerplate actually hurts — plain `Provider`/`NotifierProvider` declarations are enough for a project this size.

Providers are declared in the feature's `presentation/` folder, next to the widgets that consume them — not centralized in a global `providers/` directory. A provider that's genuinely needed by multiple features (e.g. `gamification` reading `routines`' completion state) is exposed from that feature's `domain/` layer and imported directly; it does not get promoted to `core/`.

## Routing

`go_router`, one `GoRouter` instance configured in `core/routing/`. Routes are declared flat (no nested shell routes) until there's an actual need for persistent bottom navigation across sections — at that point, revisit with a `ShellRoute`.

## Notification scheduling convention

`core/notifications/` is a thin wrapper around `flutter_local_notifications` + `timezone`: schedule-at, cancel, cancel-all. It has no knowledge of routines, streaks, or copy text.

The actual scheduling *logic* — which routine gets a notification, at what computed time, with what message — lives in `features/routines/data`, which calls the `core/notifications` wrapper. This keeps `core` reusable and dumb, and keeps the domain-specific logic testable without touching the OS notification APIs.

## Health data access

All calls to the `health` package are made from `features/health_sync/data`. No other feature imports the `health` package directly — if `gamification` needs today's step count, it reads it from `health_sync`'s domain model (backed by the cached Drift snapshot), not from a fresh platform call.
