# Roadmap

Living plan — update as phases complete or priorities shift.

## Phase 0 — Documentation (this pass)

Root `CLAUDE.md` + this `claude/` reference set, written before any app code, based on the conversation that scoped the app: a solo, gamified daily-habit app that unifies routine reminders with step/workout/nutrition data already tracked by Health Connect, Lyfta, and MyFitnessPal — rather than rebuilding tracking that already works well.

## Phase 1 — Scaffold

A working skeleton proving the architecture end-to-end, not the finished app:

- `flutter create`, then reorganize into `lib/{core,features}` per `architecture.md`.
- `core/`: theme (minimal, placeholder colors — real design direction is a later phase), `go_router` setup with route stubs for each feature, Drift database class with empty tables, `flutter_local_notifications` wrapper.
- Empty `features/{routines,health_sync,gamification}/` folders created only as their first file lands, not upfront.
- App runs on the Nothing Phone (Android) showing a placeholder home screen.

## Phase 2 — Routines

- `routines` feature: CRUD for routines (title, trigger type, recurrence) backed by the Drift `routines` table.
- Scheduling logic: compute next notification time per routine, wire to `core/notifications`.
- Completion tracking: mark a routine done for today, backed by `routine_completions`.
- Home screen shows today's routines with complete/incomplete state — this is the first genuinely useful version of the app (a smart todo list with notifications), usable daily even before health data or gamification exist.

## Phase 3 — Health Connect integration

- `health_sync` feature: request Health Connect permissions (steps, workouts, nutrition), explained in-app first.
- Read today's steps, workout count, and nutrition (calories/macros where available) from Health Connect, cache into `health_snapshots`.
- Home screen gains a "today" summary: steps vs. goal, calories vs. goal, workout done/not done — goals set once during onboarding (see Phase 5).
- Manual refresh (pull-to-refresh) plus refresh-on-foreground; no background sync job.

## Phase 4 — Gamification

- `gamification` feature: pure functions in `domain` for streak calculation (routines completed + health goals met) and XP/level thresholds.
- Badge definitions as a fixed list; unlock check runs whenever `gamification_state` is (re)evaluated.
- UI: streak counter and level/XP visible on the home screen, a dedicated screen for badge collection.
- This is the phase that turns "todo list with health stats" into the gamified experience that was the actual point of building a custom app instead of using existing ones.

## Phase 5 — Onboarding and polish

- First-run flow: set step goal, calorie/macro goals, add initial routines from a couple of suggested templates (e.g. "weigh-in after waking", "5000 steps", "morning workout").
- Settings screen: edit goals, edit/delete routines, notification permission re-request if revoked.
- Visual design pass — no direction decided yet; revisit once the core flows exist to design around, same lesson learned on the portfolio project (design is easier to get right against real content/screens than in the abstract).

## Phase 6 — Deferred, not started unless requirements change

- **iOS support** — architecturally possible (the `health` package abstracts HealthKit the same way), but untested until there's an iOS device available.
- **Social / leaderboard gamification** — would require a backend (auth, shared state across users). Explicitly out of scope while gamification stays solo.
- **Manual workout logging fallback** — only needed if Lyfta ever stops syncing to Health Connect; not built preemptively.
- **Multi-device sync** — only relevant if a second device enters the picture; local-only Drift storage is sufficient today.
