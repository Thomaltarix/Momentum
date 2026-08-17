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

Branches: `feat/design-system`, `feat/health-history`, `feat/weight-tracking` (stacked in that order). `flutter analyze` clean and all tests passing after each; debug APK builds successfully.

Verified on-device (Nothing Phone) once the phone became available: re-granting Health Connect permissions correctly listed all four categories including "Poids", and every screen showed real data — 7-day step history with correct goal-met checkmarks, an empty-but-honest state for Séances/Nutrition (no source app configured on this phone, shown as "—" rather than a fake zero), and a real weight entry on the Statut screen. One bug found and fixed this pass: the "Personnalisé" recurrence segment wrapped to two lines at that width — labels now wrapped in `FittedBox`. No crashes in logcat across the whole walkthrough.

## Phase 5.5 — Manual data entry (done)

Brought forward from Phase 7's "manual workout logging fallback" and widened to weight and nutrition too, prompted by the owner not knowing which app was writing their weight into Health Connect and wanting a way to enter it directly instead of guessing.

- `DataSourceMode` (`healthConnect` \| `manual`) per metric, stored in a new single-row `data_source_settings` table — independent per metric, so e.g. weight can be manual while workouts stay on Lyfta.
- Three new tables for typed-in entries: `weight_entries` and `nutrition_entries` (one row per day, upsert — re-entering a day overwrites it), `workout_entries` (auto-increment id, since several sessions can happen the same day). Schema bumped to v3.
- `HealthSyncRepository`'s read methods branch on the mode instead of merging both sources — deliberately not merged, to avoid double-counting a session/day that later also gets synced from Health Connect.
- Each of the three history screens (Statut/Séances/Nutrition) gained a `DataSourceToggle` (`SegmentedButton`, same widget reused across all three) and, in manual mode, an add button plus tap-to-edit on existing entries. Add/edit screens follow `add_routine_screen.dart`'s form style. Nutrition manual entry stays a raw daily total (kcal + optional macros), deliberately not a food diary — see root `CLAUDE.md`.

Branch: `feat/manual-data-entry`. `flutter analyze` and `flutter test` clean. Verified on-device (Nothing Phone, reinstalled over the existing app via `adb install -r`): the v2→v3 migration ran cleanly against real data, and the toggle/add/edit flow works on all three screens (Statut, Séances, Nutrition). One bug found and fixed this pass: the home screen's Séance/Calories rows kept showing the old Health-Connect-derived value (or "—") after switching a metric to manual and adding today's entry, because `refreshToday()` — which populates the cached snapshot that card reads — only ever pulled from Health Connect, regardless of the per-metric mode. Fixed by making `refreshToday()` mode-aware and triggering it automatically after any manual workout/nutrition write for today. Same pass also added `caloriesBurned` to the snapshot (summed from workouts) and a fuller home card (Séance/Dépensées/Consommées + macro bars), schema v4.

## Phase 5.6 — Configurable daily goals (done)

Pulled forward from Phase 6's "set goals" item — the home card's step/calorie/macro figures were being compared against numbers nobody had chosen (`defaultDailyStepGoal = 5000`, and 200/300/100g macro bar scales hardcoded in two places).

- `daily_goals` table (schema v5, single row like `data_source_settings`/`gamification_state`): `stepGoal`, `calorieGoal`, `proteinGoal`, `carbsGoal`, `fatGoal`, all with defaults matching the old hardcoded numbers so nothing jumps on upgrade before the user configures anything.
- New `GoalsScreen`, reachable from a flag icon on the home `AppBar`, pre-filled with the current values.
- Wired everywhere the old placeholders lived: the steps ring and goal-met checkmarks (home card, Pas screen), the macro bar scales (home card, Nutrition screen — extracted into a shared `MacroBar` widget along the way since Nutrition had its own private copy), the Consommées row's new "X / goal kcal" display, and — the one cross-feature catch — `gamification`'s streak "step goal met" check, which had its own independent `defaultDailyStepGoal` import that would otherwise have silently diverged from whatever the user configures.
- `step_goal.dart` deleted; nothing references the old constant anymore.

Branch: `feat/manual-data-entry`. `flutter analyze`/`flutter test` clean. Verified on-device: v4→v5 migration ran cleanly, the Goals form loads current values, edits, and saves without error.

## Phase 5.7 — Macro calculator (done)

Manually typing calorie/macro targets works, but most people don't know what number to type — this computes one from body parameters instead of leaving `GoalsScreen` asking for a figure out of thin air.

- `computeMacroTargets()` (`health_sync/domain/macro_calculator.dart`): Mifflin-St Jeor BMR → TDEE (activity multiplier) → goal-adjusted calories (±500/0/+300 kcal for lose/maintain/gain) → protein 2.0 g/kg + fat 0.9 g/kg, carbs fill whatever calories remain (floored at 0). Pure function, unit tested (`test/features/health_sync/domain/macro_calculator_test.dart`) — both sexes, all activity levels, all objectives, and the carbs-can't-go-negative edge case for a small/older/sedentary/cutting profile.
- `MacroCalculatorScreen`, reachable from a new row at the top of `GoalsScreen`. Sex/age/height/activity/objective are remembered between visits in a new single-row `macro_calculator_inputs` table (schema v6); weight is deliberately *not* stored there — it's read live from whichever weight source is active, so the calculator always reflects the real tracked weight instead of a copy that can go stale.
- Recomputes on every field change (no separate "calculate" step) and "Appliquer aux objectifs" writes the result straight onto `DailyGoals`, overwriting calorie/macro goals but leaving `stepGoal` alone — the calculator has no opinion on steps.
- The result itself lives in editable fields, not a read-only card — the formula is a starting point, not the final word. Editing a result field freezes it against further profile-driven recomputation (a `_resultsEdited` flag); a "Reprendre la suggestion" button resyncs on demand. Applying saves whatever's in the fields, which may no longer be the raw formula output.

Branch: `feat/manual-data-entry`. `flutter analyze`/`flutter test` clean (6 new unit tests). Verified on-device: v5→v6 migration ran cleanly, weight pre-filled correctly from a real tracked entry (58.5 kg), the displayed result matched the formula computed by hand, editing a result field worked and surfaced the reset button, and applying updated both `GoalsScreen` and the home card immediately.

## Phase 6 — Onboarding and polish (done)

- `RoutinesScreen`'s empty state now distinguishes "no routines exist at all" from "none due today" (the latter keeps the old plain message — a custom-recurrence routine just not scheduled for today isn't a first-run situation). The former shows three tappable suggestion cards (weigh-in on waking, workout, evening stretch) that open the same add form pre-filled — not a silent instant-add, so the user still reviews/adjusts the time before it's real. Reuses `AddRoutineScreen` via a new named constructor (`.suggested`) rather than a separate onboarding form.
- `AddRoutineScreen` also gained `.edit(routine)`, prefilling every field and saving through a new `RoutinesRepository.updateRoutine` (same reschedule path as create — cancel then re-schedule, so a time/recurrence change actually moves the notification) instead of insert. One widget now serves add, edit, and prefilled-suggestion, rather than three near-duplicate forms.
- New `SettingsScreen` (gear icon in the home `AppBar`, after Badges): a notification-status row (`NotificationService.hasPermission()`, a new check-only method alongside the existing request-only one) with a "Réactiver" action when disabled, and the full routine list (not just today's) with tap-to-edit and swipe-to-delete.

Branch: `feat/onboarding-and-settings`. `flutter analyze`/`flutter test` clean. Verified on-device: tapping a suggestion pre-filled correctly and saved a real, working routine; editing a routine's title from Settings persisted and showed immediately in both Settings and the list; swipe-to-delete from Settings worked; notification status correctly read "activées" with the real OS permission state. No crashes in logcat across the session.

This closes every phase originally planned when this app was scoped (Phase 0 through 6) — see Phase 7 below for what's intentionally not being built next.

## Phase 7 — Deferred, not started unless requirements change

- **iOS support** — architecturally possible (the `health` package abstracts HealthKit the same way), but untested until there's an iOS device available.
- **Social / leaderboard gamification** — would require a backend (auth, shared state across users). Explicitly out of scope while gamification stays solo.
- ~~**Manual workout logging fallback**~~ — done in Phase 5.5, widened to weight and nutrition too.
- **Multi-device sync** — only relevant if a second device enters the picture; local-only Drift storage is sufficient today.
