enum WorkoutCategory {
  running,
  walking,
  cycling,
  swimming,
  strength,
  yoga,
  hiking,
  rowing,
  cardio,
  other,
}

/// French display label — the single source of truth for manual entries.
/// Health Connect entries get their label straight from the activity type
/// instead (see HealthConnectClient._describeActivity).
extension WorkoutCategoryLabel on WorkoutCategory {
  String get label => switch (this) {
    WorkoutCategory.running => 'Course à pied',
    WorkoutCategory.walking => 'Marche',
    WorkoutCategory.cycling => 'Vélo',
    WorkoutCategory.swimming => 'Natation',
    WorkoutCategory.strength => 'Musculation',
    WorkoutCategory.yoga => 'Yoga',
    WorkoutCategory.hiking => 'Randonnée',
    WorkoutCategory.rowing => 'Aviron',
    WorkoutCategory.cardio => 'Cardio',
    WorkoutCategory.other => 'Séance',
  };
}
