# Roadmap

Living plan — update as phases complete or priorities shift.

## Phase 0 — Documentation (this pass)

Root `CLAUDE.md` + this `claude/` reference set, written before any app code, based on the conversation that scoped the app: a solo, gamified daily-habit app that unifies routine reminders with step/workout/nutrition data already tracked by Health Connect, Lyfta, and MyFitnessPal — rather than rebuilding tracking that already works well.

## Phase 1 — Scaffold (done)

A working skeleton proving the architecture end-to-end, not the finished app:

- `flutter create`, then reorganize into `lib/{core,features}` per `architecture.md`.
- `core/`: theme (minimal, placeholder colors — real design direction is a later phase), `go_router` setup with route stubs for each feature, Drift database class with empty tables, `flutter_local_notifications` wrapper.
- Empty `features/{routines,health_sync,gamification}/` folders created only as their first file lands, not upfront.
- App runs on the Nothing Phone (Android) showing a placeholder home screen.

Branch: `feat/flutter-scaffold`.

## Phase 2 — Routines (done)

- `routines` feature: CRUD for routines (title, trigger type, recurrence) backed by the Drift `routines` table.
- Scheduling logic: compute next notification time per routine, wire to `core/notifications`.
- Completion tracking: mark a routine done for today, backed by `routine_completions`.
- Home screen shows today's routines with complete/incomplete state — this is the first genuinely useful version of the app (a smart todo list with notifications), usable daily even before health data or gamification exist.

Branch: `feat/routines`. Verified end-to-end on the Nothing Phone: save, complete, delete, and confirmed via `dumpsys alarm` that the OS alarm is actually scheduled/cancelled. Found and fixed along the way: exact-alarm scheduling threw `exact_alarms_not_permitted` and silently blocked save on Android 13+ when the "Alarms & reminders" system permission isn't granted — `NotificationService` now checks `canScheduleExactNotifications()` per call and falls back to inexact scheduling instead of assuming exact is available.

## Phase 3 — Health Connect integration (done)

- `health_sync` feature: request Health Connect permissions (steps, workouts, nutrition) via `HealthConnectClient` — the only file that imports `package:health`, per `features.md`.
- Read today's steps (`getTotalStepsInInterval`), workout count, and nutrition (calories/macros where the source app provides them) from Health Connect, cache into `health_snapshots`.
- Home screen gains a "today" summary card: steps vs. goal, workout done/not done, calories consumed.
- Manual refresh (a refresh icon on the card) plus refresh-on-permission-grant; no background sync job, no pull-to-refresh gesture (kept simple — revisit if the icon proves awkward in daily use).

Deviations from the original plan, both because Phase 5 (onboarding/goals) hasn't happened yet:
- **Step goal**: no goal-setting UI exists yet, so `defaultDailyStepGoal = 5000` is a hardcoded placeholder in `health_sync/domain/step_goal.dart` — matches what was actually asked for when this app was scoped, not an arbitrary number. Phase 5 should replace this with a real, editable goal.
- **Calories vs. goal**: dropped for this phase — with no calorie target configured anywhere, showing a "vs. goal" comparison would mean fabricating a number. The card shows raw calories consumed instead; add the comparison once Phase 5 lets the user set a target.

Also required, beyond the `health` package's own setup: `minSdk` raised from Flutter's default to 26 (Health Connect's floor), `MainActivity` changed from `FlutterActivity` to `FlutterFragmentActivity` (needed for the Android 14 permission flow's `registerForActivityResult`), and the manifest additions from the package's Android setup guide (Health Connect queries, `READ_STEPS`/`READ_EXERCISE`/`READ_NUTRITION`/`ACTIVITY_RECOGNITION` permissions, the `ViewPermissionUsageActivity` alias, and the `ACTION_SHOW_PERMISSIONS_RATIONALE` intent filter on `MainActivity`).

Branch: `feat/health-sync`. Verified on-device: the Health Connect permission screen appeared correctly (Activité/Exercice/Pas/Nutrition categories, matching the requested types), granting access routed back into the app cleanly, and the summary card showed real data — actual steps pulled live (4933/5000 that day), with Séance/Calories correctly showing "—" for a day with no logged workout or meal yet rather than a fake zero.

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
