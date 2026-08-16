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

## Phase 4 — Gamification (done)

- `gamification` feature: `evaluatePendingDays` in `domain` — a pure, unit-tested function that replays every day since the last evaluation (not just "today", so gaps between app opens still score correctly), computing streak/XP/level one day at a time. "Successful day" = every routine due that day was completed AND the step goal was met (no calorie goal exists yet — see Phase 3's note, same reasoning applies here).
- Badge definitions as a fixed list (`badge_definitions.dart`); unlock check runs after each evaluation, keyed by `code` so an already-unlocked badge is never re-checked.
- UI: a status strip (level/XP, streak, a trophy button) above the today summary card, and a dedicated `BadgesScreen` listing all definitions with locked/unlocked state.
- This is the phase that turns "todo list with health stats" into the gamified experience that was the actual point of building a custom app instead of using existing ones.

Branch: `feat/gamification`. Verified on-device, and it caught a real bug: reinstalling over an existing install (`adb install -r`, not a fresh `pm clear`) crashed with `SqliteException: no such table: gamification_states` — `AppDatabase.schemaVersion` had never been bumped past `1` despite three phases of tables being added, so Drift saw a matching version number and skipped creating anything new on an existing database. Fixed with a real `MigrationStrategy` (`onCreate: createAll`, `onUpgrade` from `<2` creates `GamificationStates`/`Badges`) and `schemaVersion` bumped to `2`, per the "never edit a past migration, add a new step" policy in `data-model.md`. Confirmed the migration runs cleanly against the phone's existing database (Health Connect data and permissions survived the upgrade) before this was called done.

## Phase 5 — Design system and health detail screens (done)

The visual design pass mentioned as "no direction decided yet" below turned out to have a direction: explored first as a from-scratch Figma mockup (design tokens + `RoutineRow`/`BadgeCard` components, blocked partway through by the Figma team plan's MCP tool-call limit), then re-generated end-to-end with Stitch (Google) once Figma was unavailable, which produced a cohesive dark/amber system across Accueil/Badges/Nouvelle routine plus four screens that hadn't existed yet: Pas, Séances, Nutrition, Statut. This phase ports that direction into the real app and builds those four screens for real, done autonomously mid-session per the owner's "continue the features, redo the current pages at the front level" instruction.

- **Design system**: `AppColors`/`AppTheme` rebuilt around the explored palette (near-black background, surface cards, one amber accent `#F5A524` for action/motivation, emerald `#34D399` reserved strictly for "goal met" — never decorative), Inter via `google_fonts`, dark-only (`themeMode: ThemeMode.dark` — a light theme nobody designed would just be guessing). Every existing screen restyled to match: custom routine tiles (circular checkbox, dimmed title when done) replacing `CheckboxListTile`, a steps progress ring (`CustomPainter`, not an image) on the summary card, flame-icon streak badge, icon-circle badge cards, filled rounded inputs and circular day chips on the add-routine form.
- **Steps/Séances/Nutrition detail screens**: each of the three stats on the home summary card now taps through to a history view — a 7-day bar chart + daily list for steps (`fl_chart`), a grouped chronological list of past workouts, and a macro breakdown + daily calorie history for nutrition. All three query Health Connect directly for the requested range rather than the local "today" cache in `health_snapshots` — past days' data already exists in Health Connect (recorded by the phone sensor / Lyfta / MyFitnessPal) whether or not Momentum was open to cache it.
- **Statut (weight)**: the piece of the original ask (wake → weigh-in → workout) that hadn't been wired yet. Adds `READ_WEIGHT` + `HealthDataType.WEIGHT`, a weigh-in history (one entry per day, latest reading wins), and a screen with current weight, a trend delta (green only trending down, neutral otherwise — deliberately not alarming either direction), and a 30-day line chart. Reachable from a new icon next to Badges in the home `AppBar`.

Branches: `feat/design-system`, `feat/health-history`, `feat/weight-tracking` (stacked in that order). `flutter analyze` clean and all tests passing after each; debug APK builds successfully. **Not yet verified on a physical device** — the phone was unavailable for this whole phase, so the Health Connect weight permission screen, the new history screens' real data, and the visual redesign have only been checked via `flutter analyze`/`flutter test`/build, not eyes-on. Do a real device pass before calling this phase done.

## Phase 6 — Onboarding and polish

- First-run flow: set step goal, calorie/macro goals, add initial routines from a couple of suggested templates (e.g. "weigh-in after waking", "5000 steps", "morning workout").
- Settings screen: edit goals, edit/delete routines, notification permission re-request if revoked.

## Phase 7 — Deferred, not started unless requirements change

- **iOS support** — architecturally possible (the `health` package abstracts HealthKit the same way), but untested until there's an iOS device available.
- **Social / leaderboard gamification** — would require a backend (auth, shared state across users). Explicitly out of scope while gamification stays solo.
- **Manual workout logging fallback** — only needed if Lyfta ever stops syncing to Health Connect; not built preemptively.
- **Multi-device sync** — only relevant if a second device enters the picture; local-only Drift storage is sufficient today.
