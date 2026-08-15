# Data Model

Drift (SQLite), one local database, no remote sync. Tables grouped by the feature that owns them — a feature's DAO only touches its own tables.

## `routines` (feature: `routines`)

| Column | Type | Notes |
|---|---|---|
| `id` | int, PK | |
| `title` | text | |
| `trigger` | text (enum) | `fixedTime` \| `afterWake` \| `beforeSleep` — how the notification time is computed |
| `scheduledTime` | text (nullable) | only set when `trigger = fixedTime`, stored as `HH:mm` |
| `recurrence` | text (enum) | `daily` \| `weekdays` \| `custom` |
| `customDays` | text (nullable) | comma-separated weekday indices, only when `recurrence = custom` |
| `createdAt` | datetime | |

## `routine_completions` (feature: `routines`)

| Column | Type | Notes |
|---|---|---|
| `id` | int, PK | |
| `routineId` | int, FK → `routines.id` | |
| `completedAt` | date | date only, not datetime — a routine is done-for-the-day, not timestamped to the minute |

One row per routine per day it was completed. Streak math in `routines/domain` reads this table; it never stores a precomputed streak count.

## `health_snapshots` (feature: `health_sync`)

| Column | Type | Notes |
|---|---|---|
| `date` | date, PK | one row per day |
| `steps` | int | from Health Connect (phone sensor) |
| `caloriesConsumed` | int (nullable) | from Health Connect (MyFitnessPal) |
| `proteinGrams` / `carbsGrams` / `fatGrams` | real (nullable) | from Health Connect, when the source app provides macro breakdown |
| `workoutsCompleted` | int | count of workout sessions that day, from Health Connect (Lyfta) |
| `syncedAt` | datetime | when this row was last refreshed from the platform API |

Refreshed on app foreground and after an explicit pull-to-refresh — not on a background schedule, to keep permission usage predictable and avoid battery complaints.

## `gamification_state` (feature: `gamification`)

Single-row table (`id` always `1`) — there's only ever one user.

| Column | Type | Notes |
|---|---|---|
| `currentXp` | int | |
| `currentLevel` | int | derived from `currentXp` via a pure function in `gamification/domain`, but cached here to avoid recomputing on every read |
| `currentStreak` | int | consecutive days all of that day's routines + health goals were met |
| `longestStreak` | int | |
| `lastEvaluatedDate` | date | last day the streak/XP engine ran, so a missed day is detected on next app open rather than requiring a background job |

## `badges` (feature: `gamification`)

| Column | Type | Notes |
|---|---|---|
| `id` | int, PK | |
| `code` | text, unique | e.g. `first_streak_7`, `steps_goal_30_days` — matched against a fixed list of badge definitions in code, not user-editable |
| `unlockedAt` | datetime | |

Badge *definitions* (condition, name, description) live as a plain Dart list/const in `gamification/domain`, not in the database — only the fact that one was *unlocked* is persisted.

## Migration policy

Never edit a previous Drift migration. Every schema change is a new migration step, even during early development, so the migration history stays trustworthy once the app has real user data on-device.
