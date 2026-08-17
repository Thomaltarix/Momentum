// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutinesTable extends Routines
    with TableInfo<$RoutinesTable, RoutineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RoutineTrigger, String> trigger =
      GeneratedColumn<String>(
        'trigger',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RoutineTrigger>($RoutinesTable.$convertertrigger);
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<String> scheduledTime = GeneratedColumn<String>(
    'scheduled_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RoutineRecurrence, String>
  recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<RoutineRecurrence>($RoutinesTable.$converterrecurrence);
  static const VerificationMeta _customDaysMeta = const VerificationMeta(
    'customDays',
  );
  @override
  late final GeneratedColumn<String> customDays = GeneratedColumn<String>(
    'custom_days',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    trigger,
    scheduledTime,
    recurrence,
    customDays,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    }
    if (data.containsKey('custom_days')) {
      context.handle(
        _customDaysMeta,
        customDays.isAcceptableOrUnknown(data['custom_days']!, _customDaysMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      trigger: $RoutinesTable.$convertertrigger.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}trigger'],
        )!,
      ),
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_time'],
      ),
      recurrence: $RoutinesTable.$converterrecurrence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recurrence'],
        )!,
      ),
      customDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_days'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RoutineTrigger, String, String> $convertertrigger =
      const EnumNameConverter<RoutineTrigger>(RoutineTrigger.values);
  static JsonTypeConverter2<RoutineRecurrence, String, String>
  $converterrecurrence = const EnumNameConverter<RoutineRecurrence>(
    RoutineRecurrence.values,
  );
}

class RoutineRow extends DataClass implements Insertable<RoutineRow> {
  final int id;
  final String title;
  final RoutineTrigger trigger;

  /// "HH:mm", only set when [trigger] is [RoutineTrigger.fixedTime].
  final String? scheduledTime;
  final RoutineRecurrence recurrence;

  /// Comma-separated weekday indices, only set when [recurrence] is
  /// [RoutineRecurrence.custom].
  final String? customDays;
  final DateTime createdAt;
  const RoutineRow({
    required this.id,
    required this.title,
    required this.trigger,
    this.scheduledTime,
    required this.recurrence,
    this.customDays,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    {
      map['trigger'] = Variable<String>(
        $RoutinesTable.$convertertrigger.toSql(trigger),
      );
    }
    if (!nullToAbsent || scheduledTime != null) {
      map['scheduled_time'] = Variable<String>(scheduledTime);
    }
    {
      map['recurrence'] = Variable<String>(
        $RoutinesTable.$converterrecurrence.toSql(recurrence),
      );
    }
    if (!nullToAbsent || customDays != null) {
      map['custom_days'] = Variable<String>(customDays);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      title: Value(title),
      trigger: Value(trigger),
      scheduledTime: scheduledTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledTime),
      recurrence: Value(recurrence),
      customDays: customDays == null && nullToAbsent
          ? const Value.absent()
          : Value(customDays),
      createdAt: Value(createdAt),
    );
  }

  factory RoutineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      trigger: $RoutinesTable.$convertertrigger.fromJson(
        serializer.fromJson<String>(json['trigger']),
      ),
      scheduledTime: serializer.fromJson<String?>(json['scheduledTime']),
      recurrence: $RoutinesTable.$converterrecurrence.fromJson(
        serializer.fromJson<String>(json['recurrence']),
      ),
      customDays: serializer.fromJson<String?>(json['customDays']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'trigger': serializer.toJson<String>(
        $RoutinesTable.$convertertrigger.toJson(trigger),
      ),
      'scheduledTime': serializer.toJson<String?>(scheduledTime),
      'recurrence': serializer.toJson<String>(
        $RoutinesTable.$converterrecurrence.toJson(recurrence),
      ),
      'customDays': serializer.toJson<String?>(customDays),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RoutineRow copyWith({
    int? id,
    String? title,
    RoutineTrigger? trigger,
    Value<String?> scheduledTime = const Value.absent(),
    RoutineRecurrence? recurrence,
    Value<String?> customDays = const Value.absent(),
    DateTime? createdAt,
  }) => RoutineRow(
    id: id ?? this.id,
    title: title ?? this.title,
    trigger: trigger ?? this.trigger,
    scheduledTime: scheduledTime.present
        ? scheduledTime.value
        : this.scheduledTime,
    recurrence: recurrence ?? this.recurrence,
    customDays: customDays.present ? customDays.value : this.customDays,
    createdAt: createdAt ?? this.createdAt,
  );
  RoutineRow copyWithCompanion(RoutinesCompanion data) {
    return RoutineRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      customDays: data.customDays.present
          ? data.customDays.value
          : this.customDays,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('trigger: $trigger, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('recurrence: $recurrence, ')
          ..write('customDays: $customDays, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    trigger,
    scheduledTime,
    recurrence,
    customDays,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.trigger == this.trigger &&
          other.scheduledTime == this.scheduledTime &&
          other.recurrence == this.recurrence &&
          other.customDays == this.customDays &&
          other.createdAt == this.createdAt);
}

class RoutinesCompanion extends UpdateCompanion<RoutineRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<RoutineTrigger> trigger;
  final Value<String?> scheduledTime;
  final Value<RoutineRecurrence> recurrence;
  final Value<String?> customDays;
  final Value<DateTime> createdAt;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.trigger = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.customDays = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required RoutineTrigger trigger,
    this.scheduledTime = const Value.absent(),
    required RoutineRecurrence recurrence,
    this.customDays = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       trigger = Value(trigger),
       recurrence = Value(recurrence);
  static Insertable<RoutineRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? trigger,
    Expression<String>? scheduledTime,
    Expression<String>? recurrence,
    Expression<String>? customDays,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (trigger != null) 'trigger': trigger,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (recurrence != null) 'recurrence': recurrence,
      if (customDays != null) 'custom_days': customDays,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RoutinesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<RoutineTrigger>? trigger,
    Value<String?>? scheduledTime,
    Value<RoutineRecurrence>? recurrence,
    Value<String?>? customDays,
    Value<DateTime>? createdAt,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      trigger: trigger ?? this.trigger,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      recurrence: recurrence ?? this.recurrence,
      customDays: customDays ?? this.customDays,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (trigger.present) {
      map['trigger'] = Variable<String>(
        $RoutinesTable.$convertertrigger.toSql(trigger.value),
      );
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<String>(scheduledTime.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(
        $RoutinesTable.$converterrecurrence.toSql(recurrence.value),
      );
    }
    if (customDays.present) {
      map['custom_days'] = Variable<String>(customDays.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('trigger: $trigger, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('recurrence: $recurrence, ')
          ..write('customDays: $customDays, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RoutineCompletionsTable extends RoutineCompletions
    with TableInfo<$RoutineCompletionsTable, RoutineCompletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, routineId, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineCompletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineCompletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineCompletionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $RoutineCompletionsTable createAlias(String alias) {
    return $RoutineCompletionsTable(attachedDatabase, alias);
  }
}

class RoutineCompletionRow extends DataClass
    implements Insertable<RoutineCompletionRow> {
  final int id;
  final int routineId;

  /// Date only (normalized to midnight) — a routine is done-for-the-day,
  /// not timestamped to the minute.
  final DateTime completedAt;
  const RoutineCompletionRow({
    required this.id,
    required this.routineId,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_id'] = Variable<int>(routineId);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  RoutineCompletionsCompanion toCompanion(bool nullToAbsent) {
    return RoutineCompletionsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      completedAt: Value(completedAt),
    );
  }

  factory RoutineCompletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineCompletionRow(
      id: serializer.fromJson<int>(json['id']),
      routineId: serializer.fromJson<int>(json['routineId']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineId': serializer.toJson<int>(routineId),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  RoutineCompletionRow copyWith({
    int? id,
    int? routineId,
    DateTime? completedAt,
  }) => RoutineCompletionRow(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    completedAt: completedAt ?? this.completedAt,
  );
  RoutineCompletionRow copyWithCompanion(RoutineCompletionsCompanion data) {
    return RoutineCompletionRow(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCompletionRow(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineId, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineCompletionRow &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.completedAt == this.completedAt);
}

class RoutineCompletionsCompanion
    extends UpdateCompanion<RoutineCompletionRow> {
  final Value<int> id;
  final Value<int> routineId;
  final Value<DateTime> completedAt;
  const RoutineCompletionsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  RoutineCompletionsCompanion.insert({
    this.id = const Value.absent(),
    required int routineId,
    required DateTime completedAt,
  }) : routineId = Value(routineId),
       completedAt = Value(completedAt);
  static Insertable<RoutineCompletionRow> custom({
    Expression<int>? id,
    Expression<int>? routineId,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  RoutineCompletionsCompanion copyWith({
    Value<int>? id,
    Value<int>? routineId,
    Value<DateTime>? completedAt,
  }) {
    return RoutineCompletionsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $HealthSnapshotsTable extends HealthSnapshots
    with TableInfo<$HealthSnapshotsTable, HealthSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _workoutsCompletedMeta = const VerificationMeta(
    'workoutsCompleted',
  );
  @override
  late final GeneratedColumn<int> workoutsCompleted = GeneratedColumn<int>(
    'workouts_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesConsumedMeta = const VerificationMeta(
    'caloriesConsumed',
  );
  @override
  late final GeneratedColumn<int> caloriesConsumed = GeneratedColumn<int>(
    'calories_consumed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinGramsMeta = const VerificationMeta(
    'proteinGrams',
  );
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
    'protein_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsGramsMeta = const VerificationMeta(
    'carbsGrams',
  );
  @override
  late final GeneratedColumn<double> carbsGrams = GeneratedColumn<double>(
    'carbs_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatGramsMeta = const VerificationMeta(
    'fatGrams',
  );
  @override
  late final GeneratedColumn<double> fatGrams = GeneratedColumn<double>(
    'fat_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    steps,
    workoutsCompleted,
    syncedAt,
    caloriesConsumed,
    proteinGrams,
    carbsGrams,
    fatGrams,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('workouts_completed')) {
      context.handle(
        _workoutsCompletedMeta,
        workoutsCompleted.isAcceptableOrUnknown(
          data['workouts_completed']!,
          _workoutsCompletedMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    if (data.containsKey('calories_consumed')) {
      context.handle(
        _caloriesConsumedMeta,
        caloriesConsumed.isAcceptableOrUnknown(
          data['calories_consumed']!,
          _caloriesConsumedMeta,
        ),
      );
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
        _proteinGramsMeta,
        proteinGrams.isAcceptableOrUnknown(
          data['protein_grams']!,
          _proteinGramsMeta,
        ),
      );
    }
    if (data.containsKey('carbs_grams')) {
      context.handle(
        _carbsGramsMeta,
        carbsGrams.isAcceptableOrUnknown(data['carbs_grams']!, _carbsGramsMeta),
      );
    }
    if (data.containsKey('fat_grams')) {
      context.handle(
        _fatGramsMeta,
        fatGrams.isAcceptableOrUnknown(data['fat_grams']!, _fatGramsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  HealthSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthSnapshotRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      )!,
      workoutsCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workouts_completed'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
      caloriesConsumed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories_consumed'],
      ),
      proteinGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_grams'],
      ),
      carbsGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_grams'],
      ),
      fatGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_grams'],
      ),
    );
  }

  @override
  $HealthSnapshotsTable createAlias(String alias) {
    return $HealthSnapshotsTable(attachedDatabase, alias);
  }
}

class HealthSnapshotRow extends DataClass
    implements Insertable<HealthSnapshotRow> {
  final DateTime date;
  final int steps;
  final int workoutsCompleted;
  final DateTime syncedAt;
  final int? caloriesConsumed;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
  const HealthSnapshotRow({
    required this.date,
    required this.steps,
    required this.workoutsCompleted,
    required this.syncedAt,
    this.caloriesConsumed,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['steps'] = Variable<int>(steps);
    map['workouts_completed'] = Variable<int>(workoutsCompleted);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    if (!nullToAbsent || caloriesConsumed != null) {
      map['calories_consumed'] = Variable<int>(caloriesConsumed);
    }
    if (!nullToAbsent || proteinGrams != null) {
      map['protein_grams'] = Variable<double>(proteinGrams);
    }
    if (!nullToAbsent || carbsGrams != null) {
      map['carbs_grams'] = Variable<double>(carbsGrams);
    }
    if (!nullToAbsent || fatGrams != null) {
      map['fat_grams'] = Variable<double>(fatGrams);
    }
    return map;
  }

  HealthSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return HealthSnapshotsCompanion(
      date: Value(date),
      steps: Value(steps),
      workoutsCompleted: Value(workoutsCompleted),
      syncedAt: Value(syncedAt),
      caloriesConsumed: caloriesConsumed == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesConsumed),
      proteinGrams: proteinGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinGrams),
      carbsGrams: carbsGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsGrams),
      fatGrams: fatGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(fatGrams),
    );
  }

  factory HealthSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthSnapshotRow(
      date: serializer.fromJson<DateTime>(json['date']),
      steps: serializer.fromJson<int>(json['steps']),
      workoutsCompleted: serializer.fromJson<int>(json['workoutsCompleted']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
      caloriesConsumed: serializer.fromJson<int?>(json['caloriesConsumed']),
      proteinGrams: serializer.fromJson<double?>(json['proteinGrams']),
      carbsGrams: serializer.fromJson<double?>(json['carbsGrams']),
      fatGrams: serializer.fromJson<double?>(json['fatGrams']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'steps': serializer.toJson<int>(steps),
      'workoutsCompleted': serializer.toJson<int>(workoutsCompleted),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
      'caloriesConsumed': serializer.toJson<int?>(caloriesConsumed),
      'proteinGrams': serializer.toJson<double?>(proteinGrams),
      'carbsGrams': serializer.toJson<double?>(carbsGrams),
      'fatGrams': serializer.toJson<double?>(fatGrams),
    };
  }

  HealthSnapshotRow copyWith({
    DateTime? date,
    int? steps,
    int? workoutsCompleted,
    DateTime? syncedAt,
    Value<int?> caloriesConsumed = const Value.absent(),
    Value<double?> proteinGrams = const Value.absent(),
    Value<double?> carbsGrams = const Value.absent(),
    Value<double?> fatGrams = const Value.absent(),
  }) => HealthSnapshotRow(
    date: date ?? this.date,
    steps: steps ?? this.steps,
    workoutsCompleted: workoutsCompleted ?? this.workoutsCompleted,
    syncedAt: syncedAt ?? this.syncedAt,
    caloriesConsumed: caloriesConsumed.present
        ? caloriesConsumed.value
        : this.caloriesConsumed,
    proteinGrams: proteinGrams.present ? proteinGrams.value : this.proteinGrams,
    carbsGrams: carbsGrams.present ? carbsGrams.value : this.carbsGrams,
    fatGrams: fatGrams.present ? fatGrams.value : this.fatGrams,
  );
  HealthSnapshotRow copyWithCompanion(HealthSnapshotsCompanion data) {
    return HealthSnapshotRow(
      date: data.date.present ? data.date.value : this.date,
      steps: data.steps.present ? data.steps.value : this.steps,
      workoutsCompleted: data.workoutsCompleted.present
          ? data.workoutsCompleted.value
          : this.workoutsCompleted,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      caloriesConsumed: data.caloriesConsumed.present
          ? data.caloriesConsumed.value
          : this.caloriesConsumed,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      carbsGrams: data.carbsGrams.present
          ? data.carbsGrams.value
          : this.carbsGrams,
      fatGrams: data.fatGrams.present ? data.fatGrams.value : this.fatGrams,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthSnapshotRow(')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('workoutsCompleted: $workoutsCompleted, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('caloriesConsumed: $caloriesConsumed, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    steps,
    workoutsCompleted,
    syncedAt,
    caloriesConsumed,
    proteinGrams,
    carbsGrams,
    fatGrams,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthSnapshotRow &&
          other.date == this.date &&
          other.steps == this.steps &&
          other.workoutsCompleted == this.workoutsCompleted &&
          other.syncedAt == this.syncedAt &&
          other.caloriesConsumed == this.caloriesConsumed &&
          other.proteinGrams == this.proteinGrams &&
          other.carbsGrams == this.carbsGrams &&
          other.fatGrams == this.fatGrams);
}

class HealthSnapshotsCompanion extends UpdateCompanion<HealthSnapshotRow> {
  final Value<DateTime> date;
  final Value<int> steps;
  final Value<int> workoutsCompleted;
  final Value<DateTime> syncedAt;
  final Value<int?> caloriesConsumed;
  final Value<double?> proteinGrams;
  final Value<double?> carbsGrams;
  final Value<double?> fatGrams;
  final Value<int> rowid;
  const HealthSnapshotsCompanion({
    this.date = const Value.absent(),
    this.steps = const Value.absent(),
    this.workoutsCompleted = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.caloriesConsumed = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthSnapshotsCompanion.insert({
    required DateTime date,
    this.steps = const Value.absent(),
    this.workoutsCompleted = const Value.absent(),
    required DateTime syncedAt,
    this.caloriesConsumed = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       syncedAt = Value(syncedAt);
  static Insertable<HealthSnapshotRow> custom({
    Expression<DateTime>? date,
    Expression<int>? steps,
    Expression<int>? workoutsCompleted,
    Expression<DateTime>? syncedAt,
    Expression<int>? caloriesConsumed,
    Expression<double>? proteinGrams,
    Expression<double>? carbsGrams,
    Expression<double>? fatGrams,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (steps != null) 'steps': steps,
      if (workoutsCompleted != null) 'workouts_completed': workoutsCompleted,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (caloriesConsumed != null) 'calories_consumed': caloriesConsumed,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (carbsGrams != null) 'carbs_grams': carbsGrams,
      if (fatGrams != null) 'fat_grams': fatGrams,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthSnapshotsCompanion copyWith({
    Value<DateTime>? date,
    Value<int>? steps,
    Value<int>? workoutsCompleted,
    Value<DateTime>? syncedAt,
    Value<int?>? caloriesConsumed,
    Value<double?>? proteinGrams,
    Value<double?>? carbsGrams,
    Value<double?>? fatGrams,
    Value<int>? rowid,
  }) {
    return HealthSnapshotsCompanion(
      date: date ?? this.date,
      steps: steps ?? this.steps,
      workoutsCompleted: workoutsCompleted ?? this.workoutsCompleted,
      syncedAt: syncedAt ?? this.syncedAt,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (workoutsCompleted.present) {
      map['workouts_completed'] = Variable<int>(workoutsCompleted.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (caloriesConsumed.present) {
      map['calories_consumed'] = Variable<int>(caloriesConsumed.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (carbsGrams.present) {
      map['carbs_grams'] = Variable<double>(carbsGrams.value);
    }
    if (fatGrams.present) {
      map['fat_grams'] = Variable<double>(fatGrams.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthSnapshotsCompanion(')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('workoutsCompleted: $workoutsCompleted, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('caloriesConsumed: $caloriesConsumed, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamificationStatesTable extends GamificationStates
    with TableInfo<$GamificationStatesTable, GamificationStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamificationStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentXpMeta = const VerificationMeta(
    'currentXp',
  );
  @override
  late final GeneratedColumn<int> currentXp = GeneratedColumn<int>(
    'current_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentLevelMeta = const VerificationMeta(
    'currentLevel',
  );
  @override
  late final GeneratedColumn<int> currentLevel = GeneratedColumn<int>(
    'current_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastEvaluatedDateMeta = const VerificationMeta(
    'lastEvaluatedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastEvaluatedDate =
      GeneratedColumn<DateTime>(
        'last_evaluated_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currentXp,
    currentLevel,
    currentStreak,
    longestStreak,
    lastEvaluatedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gamification_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamificationStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_xp')) {
      context.handle(
        _currentXpMeta,
        currentXp.isAcceptableOrUnknown(data['current_xp']!, _currentXpMeta),
      );
    }
    if (data.containsKey('current_level')) {
      context.handle(
        _currentLevelMeta,
        currentLevel.isAcceptableOrUnknown(
          data['current_level']!,
          _currentLevelMeta,
        ),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('last_evaluated_date')) {
      context.handle(
        _lastEvaluatedDateMeta,
        lastEvaluatedDate.isAcceptableOrUnknown(
          data['last_evaluated_date']!,
          _lastEvaluatedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastEvaluatedDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GamificationStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamificationStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_xp'],
      )!,
      currentLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_level'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      lastEvaluatedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_evaluated_date'],
      )!,
    );
  }

  @override
  $GamificationStatesTable createAlias(String alias) {
    return $GamificationStatesTable(attachedDatabase, alias);
  }
}

class GamificationStateRow extends DataClass
    implements Insertable<GamificationStateRow> {
  final int id;
  final int currentXp;
  final int currentLevel;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastEvaluatedDate;
  const GamificationStateRow({
    required this.id,
    required this.currentXp,
    required this.currentLevel,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastEvaluatedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_xp'] = Variable<int>(currentXp);
    map['current_level'] = Variable<int>(currentLevel);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['last_evaluated_date'] = Variable<DateTime>(lastEvaluatedDate);
    return map;
  }

  GamificationStatesCompanion toCompanion(bool nullToAbsent) {
    return GamificationStatesCompanion(
      id: Value(id),
      currentXp: Value(currentXp),
      currentLevel: Value(currentLevel),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastEvaluatedDate: Value(lastEvaluatedDate),
    );
  }

  factory GamificationStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamificationStateRow(
      id: serializer.fromJson<int>(json['id']),
      currentXp: serializer.fromJson<int>(json['currentXp']),
      currentLevel: serializer.fromJson<int>(json['currentLevel']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastEvaluatedDate: serializer.fromJson<DateTime>(
        json['lastEvaluatedDate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentXp': serializer.toJson<int>(currentXp),
      'currentLevel': serializer.toJson<int>(currentLevel),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastEvaluatedDate': serializer.toJson<DateTime>(lastEvaluatedDate),
    };
  }

  GamificationStateRow copyWith({
    int? id,
    int? currentXp,
    int? currentLevel,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastEvaluatedDate,
  }) => GamificationStateRow(
    id: id ?? this.id,
    currentXp: currentXp ?? this.currentXp,
    currentLevel: currentLevel ?? this.currentLevel,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    lastEvaluatedDate: lastEvaluatedDate ?? this.lastEvaluatedDate,
  );
  GamificationStateRow copyWithCompanion(GamificationStatesCompanion data) {
    return GamificationStateRow(
      id: data.id.present ? data.id.value : this.id,
      currentXp: data.currentXp.present ? data.currentXp.value : this.currentXp,
      currentLevel: data.currentLevel.present
          ? data.currentLevel.value
          : this.currentLevel,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastEvaluatedDate: data.lastEvaluatedDate.present
          ? data.lastEvaluatedDate.value
          : this.lastEvaluatedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamificationStateRow(')
          ..write('id: $id, ')
          ..write('currentXp: $currentXp, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastEvaluatedDate: $lastEvaluatedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    currentXp,
    currentLevel,
    currentStreak,
    longestStreak,
    lastEvaluatedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamificationStateRow &&
          other.id == this.id &&
          other.currentXp == this.currentXp &&
          other.currentLevel == this.currentLevel &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastEvaluatedDate == this.lastEvaluatedDate);
}

class GamificationStatesCompanion
    extends UpdateCompanion<GamificationStateRow> {
  final Value<int> id;
  final Value<int> currentXp;
  final Value<int> currentLevel;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime> lastEvaluatedDate;
  const GamificationStatesCompanion({
    this.id = const Value.absent(),
    this.currentXp = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastEvaluatedDate = const Value.absent(),
  });
  GamificationStatesCompanion.insert({
    this.id = const Value.absent(),
    this.currentXp = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    required DateTime lastEvaluatedDate,
  }) : lastEvaluatedDate = Value(lastEvaluatedDate);
  static Insertable<GamificationStateRow> custom({
    Expression<int>? id,
    Expression<int>? currentXp,
    Expression<int>? currentLevel,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastEvaluatedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentXp != null) 'current_xp': currentXp,
      if (currentLevel != null) 'current_level': currentLevel,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastEvaluatedDate != null) 'last_evaluated_date': lastEvaluatedDate,
    });
  }

  GamificationStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? currentXp,
    Value<int>? currentLevel,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<DateTime>? lastEvaluatedDate,
  }) {
    return GamificationStatesCompanion(
      id: id ?? this.id,
      currentXp: currentXp ?? this.currentXp,
      currentLevel: currentLevel ?? this.currentLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastEvaluatedDate: lastEvaluatedDate ?? this.lastEvaluatedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentXp.present) {
      map['current_xp'] = Variable<int>(currentXp.value);
    }
    if (currentLevel.present) {
      map['current_level'] = Variable<int>(currentLevel.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastEvaluatedDate.present) {
      map['last_evaluated_date'] = Variable<DateTime>(lastEvaluatedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamificationStatesCompanion(')
          ..write('id: $id, ')
          ..write('currentXp: $currentXp, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastEvaluatedDate: $lastEvaluatedDate')
          ..write(')'))
        .toString();
  }
}

class $BadgesTable extends Badges with TableInfo<$BadgesTable, BadgeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<BadgeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BadgeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BadgeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $BadgesTable createAlias(String alias) {
    return $BadgesTable(attachedDatabase, alias);
  }
}

class BadgeRow extends DataClass implements Insertable<BadgeRow> {
  final int id;
  final String code;
  final DateTime unlockedAt;
  const BadgeRow({
    required this.id,
    required this.code,
    required this.unlockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  BadgesCompanion toCompanion(bool nullToAbsent) {
    return BadgesCompanion(
      id: Value(id),
      code: Value(code),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory BadgeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BadgeRow(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  BadgeRow copyWith({int? id, String? code, DateTime? unlockedAt}) => BadgeRow(
    id: id ?? this.id,
    code: code ?? this.code,
    unlockedAt: unlockedAt ?? this.unlockedAt,
  );
  BadgeRow copyWithCompanion(BadgesCompanion data) {
    return BadgeRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BadgeRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BadgeRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.unlockedAt == this.unlockedAt);
}

class BadgesCompanion extends UpdateCompanion<BadgeRow> {
  final Value<int> id;
  final Value<String> code;
  final Value<DateTime> unlockedAt;
  const BadgesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.unlockedAt = const Value.absent(),
  });
  BadgesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required DateTime unlockedAt,
  }) : code = Value(code),
       unlockedAt = Value(unlockedAt);
  static Insertable<BadgeRow> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<DateTime>? unlockedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
    });
  }

  BadgesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<DateTime>? unlockedAt,
  }) {
    return BadgesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }
}

class $DataSourceSettingsTable extends DataSourceSettings
    with TableInfo<$DataSourceSettingsTable, DataSourceSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DataSourceSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _weightSourceMeta = const VerificationMeta(
    'weightSource',
  );
  @override
  late final GeneratedColumn<String> weightSource = GeneratedColumn<String>(
    'weight_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('healthConnect'),
  );
  static const VerificationMeta _workoutSourceMeta = const VerificationMeta(
    'workoutSource',
  );
  @override
  late final GeneratedColumn<String> workoutSource = GeneratedColumn<String>(
    'workout_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('healthConnect'),
  );
  static const VerificationMeta _nutritionSourceMeta = const VerificationMeta(
    'nutritionSource',
  );
  @override
  late final GeneratedColumn<String> nutritionSource = GeneratedColumn<String>(
    'nutrition_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('healthConnect'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weightSource,
    workoutSource,
    nutritionSource,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'data_source_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<DataSourceSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weight_source')) {
      context.handle(
        _weightSourceMeta,
        weightSource.isAcceptableOrUnknown(
          data['weight_source']!,
          _weightSourceMeta,
        ),
      );
    }
    if (data.containsKey('workout_source')) {
      context.handle(
        _workoutSourceMeta,
        workoutSource.isAcceptableOrUnknown(
          data['workout_source']!,
          _workoutSourceMeta,
        ),
      );
    }
    if (data.containsKey('nutrition_source')) {
      context.handle(
        _nutritionSourceMeta,
        nutritionSource.isAcceptableOrUnknown(
          data['nutrition_source']!,
          _nutritionSourceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DataSourceSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DataSourceSettingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weightSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_source'],
      )!,
      workoutSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_source'],
      )!,
      nutritionSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutrition_source'],
      )!,
    );
  }

  @override
  $DataSourceSettingsTable createAlias(String alias) {
    return $DataSourceSettingsTable(attachedDatabase, alias);
  }
}

class DataSourceSettingRow extends DataClass
    implements Insertable<DataSourceSettingRow> {
  final int id;
  final String weightSource;
  final String workoutSource;
  final String nutritionSource;
  const DataSourceSettingRow({
    required this.id,
    required this.weightSource,
    required this.workoutSource,
    required this.nutritionSource,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weight_source'] = Variable<String>(weightSource);
    map['workout_source'] = Variable<String>(workoutSource);
    map['nutrition_source'] = Variable<String>(nutritionSource);
    return map;
  }

  DataSourceSettingsCompanion toCompanion(bool nullToAbsent) {
    return DataSourceSettingsCompanion(
      id: Value(id),
      weightSource: Value(weightSource),
      workoutSource: Value(workoutSource),
      nutritionSource: Value(nutritionSource),
    );
  }

  factory DataSourceSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DataSourceSettingRow(
      id: serializer.fromJson<int>(json['id']),
      weightSource: serializer.fromJson<String>(json['weightSource']),
      workoutSource: serializer.fromJson<String>(json['workoutSource']),
      nutritionSource: serializer.fromJson<String>(json['nutritionSource']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weightSource': serializer.toJson<String>(weightSource),
      'workoutSource': serializer.toJson<String>(workoutSource),
      'nutritionSource': serializer.toJson<String>(nutritionSource),
    };
  }

  DataSourceSettingRow copyWith({
    int? id,
    String? weightSource,
    String? workoutSource,
    String? nutritionSource,
  }) => DataSourceSettingRow(
    id: id ?? this.id,
    weightSource: weightSource ?? this.weightSource,
    workoutSource: workoutSource ?? this.workoutSource,
    nutritionSource: nutritionSource ?? this.nutritionSource,
  );
  DataSourceSettingRow copyWithCompanion(DataSourceSettingsCompanion data) {
    return DataSourceSettingRow(
      id: data.id.present ? data.id.value : this.id,
      weightSource: data.weightSource.present
          ? data.weightSource.value
          : this.weightSource,
      workoutSource: data.workoutSource.present
          ? data.workoutSource.value
          : this.workoutSource,
      nutritionSource: data.nutritionSource.present
          ? data.nutritionSource.value
          : this.nutritionSource,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DataSourceSettingRow(')
          ..write('id: $id, ')
          ..write('weightSource: $weightSource, ')
          ..write('workoutSource: $workoutSource, ')
          ..write('nutritionSource: $nutritionSource')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, weightSource, workoutSource, nutritionSource);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataSourceSettingRow &&
          other.id == this.id &&
          other.weightSource == this.weightSource &&
          other.workoutSource == this.workoutSource &&
          other.nutritionSource == this.nutritionSource);
}

class DataSourceSettingsCompanion
    extends UpdateCompanion<DataSourceSettingRow> {
  final Value<int> id;
  final Value<String> weightSource;
  final Value<String> workoutSource;
  final Value<String> nutritionSource;
  const DataSourceSettingsCompanion({
    this.id = const Value.absent(),
    this.weightSource = const Value.absent(),
    this.workoutSource = const Value.absent(),
    this.nutritionSource = const Value.absent(),
  });
  DataSourceSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.weightSource = const Value.absent(),
    this.workoutSource = const Value.absent(),
    this.nutritionSource = const Value.absent(),
  });
  static Insertable<DataSourceSettingRow> custom({
    Expression<int>? id,
    Expression<String>? weightSource,
    Expression<String>? workoutSource,
    Expression<String>? nutritionSource,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weightSource != null) 'weight_source': weightSource,
      if (workoutSource != null) 'workout_source': workoutSource,
      if (nutritionSource != null) 'nutrition_source': nutritionSource,
    });
  }

  DataSourceSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? weightSource,
    Value<String>? workoutSource,
    Value<String>? nutritionSource,
  }) {
    return DataSourceSettingsCompanion(
      id: id ?? this.id,
      weightSource: weightSource ?? this.weightSource,
      workoutSource: workoutSource ?? this.workoutSource,
      nutritionSource: nutritionSource ?? this.nutritionSource,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weightSource.present) {
      map['weight_source'] = Variable<String>(weightSource.value);
    }
    if (workoutSource.present) {
      map['workout_source'] = Variable<String>(workoutSource.value);
    }
    if (nutritionSource.present) {
      map['nutrition_source'] = Variable<String>(nutritionSource.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DataSourceSettingsCompanion(')
          ..write('id: $id, ')
          ..write('weightSource: $weightSource, ')
          ..write('workoutSource: $workoutSource, ')
          ..write('nutritionSource: $nutritionSource')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries
    with TableInfo<$WeightEntriesTable, WeightEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kilogramsMeta = const VerificationMeta(
    'kilograms',
  );
  @override
  late final GeneratedColumn<double> kilograms = GeneratedColumn<double>(
    'kilograms',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [date, kilograms];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('kilograms')) {
      context.handle(
        _kilogramsMeta,
        kilograms.isAcceptableOrUnknown(data['kilograms']!, _kilogramsMeta),
      );
    } else if (isInserting) {
      context.missing(_kilogramsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  WeightEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightEntryRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      kilograms: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kilograms'],
      )!,
    );
  }

  @override
  $WeightEntriesTable createAlias(String alias) {
    return $WeightEntriesTable(attachedDatabase, alias);
  }
}

class WeightEntryRow extends DataClass implements Insertable<WeightEntryRow> {
  final DateTime date;
  final double kilograms;
  const WeightEntryRow({required this.date, required this.kilograms});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['kilograms'] = Variable<double>(kilograms);
    return map;
  }

  WeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightEntriesCompanion(
      date: Value(date),
      kilograms: Value(kilograms),
    );
  }

  factory WeightEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightEntryRow(
      date: serializer.fromJson<DateTime>(json['date']),
      kilograms: serializer.fromJson<double>(json['kilograms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'kilograms': serializer.toJson<double>(kilograms),
    };
  }

  WeightEntryRow copyWith({DateTime? date, double? kilograms}) =>
      WeightEntryRow(
        date: date ?? this.date,
        kilograms: kilograms ?? this.kilograms,
      );
  WeightEntryRow copyWithCompanion(WeightEntriesCompanion data) {
    return WeightEntryRow(
      date: data.date.present ? data.date.value : this.date,
      kilograms: data.kilograms.present ? data.kilograms.value : this.kilograms,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntryRow(')
          ..write('date: $date, ')
          ..write('kilograms: $kilograms')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, kilograms);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightEntryRow &&
          other.date == this.date &&
          other.kilograms == this.kilograms);
}

class WeightEntriesCompanion extends UpdateCompanion<WeightEntryRow> {
  final Value<DateTime> date;
  final Value<double> kilograms;
  final Value<int> rowid;
  const WeightEntriesCompanion({
    this.date = const Value.absent(),
    this.kilograms = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightEntriesCompanion.insert({
    required DateTime date,
    required double kilograms,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       kilograms = Value(kilograms);
  static Insertable<WeightEntryRow> custom({
    Expression<DateTime>? date,
    Expression<double>? kilograms,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (kilograms != null) 'kilograms': kilograms,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightEntriesCompanion copyWith({
    Value<DateTime>? date,
    Value<double>? kilograms,
    Value<int>? rowid,
  }) {
    return WeightEntriesCompanion(
      date: date ?? this.date,
      kilograms: kilograms ?? this.kilograms,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (kilograms.present) {
      map['kilograms'] = Variable<double>(kilograms.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntriesCompanion(')
          ..write('date: $date, ')
          ..write('kilograms: $kilograms, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutritionEntriesTable extends NutritionEntries
    with TableInfo<$NutritionEntriesTable, NutritionEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGramsMeta = const VerificationMeta(
    'proteinGrams',
  );
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
    'protein_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsGramsMeta = const VerificationMeta(
    'carbsGrams',
  );
  @override
  late final GeneratedColumn<double> carbsGrams = GeneratedColumn<double>(
    'carbs_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatGramsMeta = const VerificationMeta(
    'fatGrams',
  );
  @override
  late final GeneratedColumn<double> fatGrams = GeneratedColumn<double>(
    'fat_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    calories,
    proteinGrams,
    carbsGrams,
    fatGrams,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<NutritionEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
        _proteinGramsMeta,
        proteinGrams.isAcceptableOrUnknown(
          data['protein_grams']!,
          _proteinGramsMeta,
        ),
      );
    }
    if (data.containsKey('carbs_grams')) {
      context.handle(
        _carbsGramsMeta,
        carbsGrams.isAcceptableOrUnknown(data['carbs_grams']!, _carbsGramsMeta),
      );
    }
    if (data.containsKey('fat_grams')) {
      context.handle(
        _fatGramsMeta,
        fatGrams.isAcceptableOrUnknown(data['fat_grams']!, _fatGramsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  NutritionEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionEntryRow(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      proteinGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_grams'],
      ),
      carbsGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_grams'],
      ),
      fatGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_grams'],
      ),
    );
  }

  @override
  $NutritionEntriesTable createAlias(String alias) {
    return $NutritionEntriesTable(attachedDatabase, alias);
  }
}

class NutritionEntryRow extends DataClass
    implements Insertable<NutritionEntryRow> {
  final DateTime date;
  final int calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
  const NutritionEntryRow({
    required this.date,
    required this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['calories'] = Variable<int>(calories);
    if (!nullToAbsent || proteinGrams != null) {
      map['protein_grams'] = Variable<double>(proteinGrams);
    }
    if (!nullToAbsent || carbsGrams != null) {
      map['carbs_grams'] = Variable<double>(carbsGrams);
    }
    if (!nullToAbsent || fatGrams != null) {
      map['fat_grams'] = Variable<double>(fatGrams);
    }
    return map;
  }

  NutritionEntriesCompanion toCompanion(bool nullToAbsent) {
    return NutritionEntriesCompanion(
      date: Value(date),
      calories: Value(calories),
      proteinGrams: proteinGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinGrams),
      carbsGrams: carbsGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsGrams),
      fatGrams: fatGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(fatGrams),
    );
  }

  factory NutritionEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionEntryRow(
      date: serializer.fromJson<DateTime>(json['date']),
      calories: serializer.fromJson<int>(json['calories']),
      proteinGrams: serializer.fromJson<double?>(json['proteinGrams']),
      carbsGrams: serializer.fromJson<double?>(json['carbsGrams']),
      fatGrams: serializer.fromJson<double?>(json['fatGrams']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'calories': serializer.toJson<int>(calories),
      'proteinGrams': serializer.toJson<double?>(proteinGrams),
      'carbsGrams': serializer.toJson<double?>(carbsGrams),
      'fatGrams': serializer.toJson<double?>(fatGrams),
    };
  }

  NutritionEntryRow copyWith({
    DateTime? date,
    int? calories,
    Value<double?> proteinGrams = const Value.absent(),
    Value<double?> carbsGrams = const Value.absent(),
    Value<double?> fatGrams = const Value.absent(),
  }) => NutritionEntryRow(
    date: date ?? this.date,
    calories: calories ?? this.calories,
    proteinGrams: proteinGrams.present ? proteinGrams.value : this.proteinGrams,
    carbsGrams: carbsGrams.present ? carbsGrams.value : this.carbsGrams,
    fatGrams: fatGrams.present ? fatGrams.value : this.fatGrams,
  );
  NutritionEntryRow copyWithCompanion(NutritionEntriesCompanion data) {
    return NutritionEntryRow(
      date: data.date.present ? data.date.value : this.date,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      carbsGrams: data.carbsGrams.present
          ? data.carbsGrams.value
          : this.carbsGrams,
      fatGrams: data.fatGrams.present ? data.fatGrams.value : this.fatGrams,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionEntryRow(')
          ..write('date: $date, ')
          ..write('calories: $calories, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, calories, proteinGrams, carbsGrams, fatGrams);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionEntryRow &&
          other.date == this.date &&
          other.calories == this.calories &&
          other.proteinGrams == this.proteinGrams &&
          other.carbsGrams == this.carbsGrams &&
          other.fatGrams == this.fatGrams);
}

class NutritionEntriesCompanion extends UpdateCompanion<NutritionEntryRow> {
  final Value<DateTime> date;
  final Value<int> calories;
  final Value<double?> proteinGrams;
  final Value<double?> carbsGrams;
  final Value<double?> fatGrams;
  final Value<int> rowid;
  const NutritionEntriesCompanion({
    this.date = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionEntriesCompanion.insert({
    required DateTime date,
    required int calories,
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       calories = Value(calories);
  static Insertable<NutritionEntryRow> custom({
    Expression<DateTime>? date,
    Expression<int>? calories,
    Expression<double>? proteinGrams,
    Expression<double>? carbsGrams,
    Expression<double>? fatGrams,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (calories != null) 'calories': calories,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (carbsGrams != null) 'carbs_grams': carbsGrams,
      if (fatGrams != null) 'fat_grams': fatGrams,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionEntriesCompanion copyWith({
    Value<DateTime>? date,
    Value<int>? calories,
    Value<double?>? proteinGrams,
    Value<double?>? carbsGrams,
    Value<double?>? fatGrams,
    Value<int>? rowid,
  }) {
    return NutritionEntriesCompanion(
      date: date ?? this.date,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (carbsGrams.present) {
      map['carbs_grams'] = Variable<double>(carbsGrams.value);
    }
    if (fatGrams.present) {
      map['fat_grams'] = Variable<double>(fatGrams.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionEntriesCompanion(')
          ..write('date: $date, ')
          ..write('calories: $calories, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutEntriesTable extends WorkoutEntries
    with TableInfo<$WorkoutEntriesTable, WorkoutEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<WorkoutCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<WorkoutCategory>($WorkoutEntriesTable.$convertercategory);
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
    'end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesBurnedMeta = const VerificationMeta(
    'caloriesBurned',
  );
  @override
  late final GeneratedColumn<int> caloriesBurned = GeneratedColumn<int>(
    'calories_burned',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    start,
    end,
    caloriesBurned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('calories_burned')) {
      context.handle(
        _caloriesBurnedMeta,
        caloriesBurned.isAcceptableOrUnknown(
          data['calories_burned']!,
          _caloriesBurnedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: $WorkoutEntriesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      )!,
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end'],
      )!,
      caloriesBurned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories_burned'],
      ),
    );
  }

  @override
  $WorkoutEntriesTable createAlias(String alias) {
    return $WorkoutEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WorkoutCategory, String, String>
  $convertercategory = const EnumNameConverter<WorkoutCategory>(
    WorkoutCategory.values,
  );
}

class WorkoutEntryRow extends DataClass implements Insertable<WorkoutEntryRow> {
  final int id;
  final WorkoutCategory category;
  final DateTime start;
  final DateTime end;
  final int? caloriesBurned;
  const WorkoutEntryRow({
    required this.id,
    required this.category,
    required this.start,
    required this.end,
    this.caloriesBurned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['category'] = Variable<String>(
        $WorkoutEntriesTable.$convertercategory.toSql(category),
      );
    }
    map['start'] = Variable<DateTime>(start);
    map['end'] = Variable<DateTime>(end);
    if (!nullToAbsent || caloriesBurned != null) {
      map['calories_burned'] = Variable<int>(caloriesBurned);
    }
    return map;
  }

  WorkoutEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutEntriesCompanion(
      id: Value(id),
      category: Value(category),
      start: Value(start),
      end: Value(end),
      caloriesBurned: caloriesBurned == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesBurned),
    );
  }

  factory WorkoutEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutEntryRow(
      id: serializer.fromJson<int>(json['id']),
      category: $WorkoutEntriesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      caloriesBurned: serializer.fromJson<int?>(json['caloriesBurned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(
        $WorkoutEntriesTable.$convertercategory.toJson(category),
      ),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'caloriesBurned': serializer.toJson<int?>(caloriesBurned),
    };
  }

  WorkoutEntryRow copyWith({
    int? id,
    WorkoutCategory? category,
    DateTime? start,
    DateTime? end,
    Value<int?> caloriesBurned = const Value.absent(),
  }) => WorkoutEntryRow(
    id: id ?? this.id,
    category: category ?? this.category,
    start: start ?? this.start,
    end: end ?? this.end,
    caloriesBurned: caloriesBurned.present
        ? caloriesBurned.value
        : this.caloriesBurned,
  );
  WorkoutEntryRow copyWithCompanion(WorkoutEntriesCompanion data) {
    return WorkoutEntryRow(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      caloriesBurned: data.caloriesBurned.present
          ? data.caloriesBurned.value
          : this.caloriesBurned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutEntryRow(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('caloriesBurned: $caloriesBurned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, start, end, caloriesBurned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutEntryRow &&
          other.id == this.id &&
          other.category == this.category &&
          other.start == this.start &&
          other.end == this.end &&
          other.caloriesBurned == this.caloriesBurned);
}

class WorkoutEntriesCompanion extends UpdateCompanion<WorkoutEntryRow> {
  final Value<int> id;
  final Value<WorkoutCategory> category;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<int?> caloriesBurned;
  const WorkoutEntriesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.caloriesBurned = const Value.absent(),
  });
  WorkoutEntriesCompanion.insert({
    this.id = const Value.absent(),
    required WorkoutCategory category,
    required DateTime start,
    required DateTime end,
    this.caloriesBurned = const Value.absent(),
  }) : category = Value(category),
       start = Value(start),
       end = Value(end);
  static Insertable<WorkoutEntryRow> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<int>? caloriesBurned,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (caloriesBurned != null) 'calories_burned': caloriesBurned,
    });
  }

  WorkoutEntriesCompanion copyWith({
    Value<int>? id,
    Value<WorkoutCategory>? category,
    Value<DateTime>? start,
    Value<DateTime>? end,
    Value<int?>? caloriesBurned,
  }) {
    return WorkoutEntriesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      start: start ?? this.start,
      end: end ?? this.end,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $WorkoutEntriesTable.$convertercategory.toSql(category.value),
      );
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (caloriesBurned.present) {
      map['calories_burned'] = Variable<int>(caloriesBurned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutEntriesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('caloriesBurned: $caloriesBurned')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $RoutineCompletionsTable routineCompletions =
      $RoutineCompletionsTable(this);
  late final $HealthSnapshotsTable healthSnapshots = $HealthSnapshotsTable(
    this,
  );
  late final $GamificationStatesTable gamificationStates =
      $GamificationStatesTable(this);
  late final $BadgesTable badges = $BadgesTable(this);
  late final $DataSourceSettingsTable dataSourceSettings =
      $DataSourceSettingsTable(this);
  late final $WeightEntriesTable weightEntries = $WeightEntriesTable(this);
  late final $NutritionEntriesTable nutritionEntries = $NutritionEntriesTable(
    this,
  );
  late final $WorkoutEntriesTable workoutEntries = $WorkoutEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    routineCompletions,
    healthSnapshots,
    gamificationStates,
    badges,
    dataSourceSettings,
    weightEntries,
    nutritionEntries,
    workoutEntries,
  ];
}

typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  required String title,
  required RoutineTrigger trigger,
  Value<String?> scheduledTime,
  required RoutineRecurrence recurrence,
  Value<String?> customDays,
  Value<DateTime> createdAt,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<RoutineTrigger> trigger,
  Value<String?> scheduledTime,
  Value<RoutineRecurrence> recurrence,
  Value<String?> customDays,
  Value<DateTime> createdAt,
});

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, RoutineRow> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $RoutineCompletionsTable,
    List<RoutineCompletionRow>
  >
  _routineCompletionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineCompletions,
        aliasName: 'routines__id__routine_completions__routine_id',
      );

  $$RoutineCompletionsTableProcessedTableManager get routineCompletionsRefs {
    final manager = $$RoutineCompletionsTableTableManager(
      $_db,
      $_db.routineCompletions,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RoutineTrigger, RoutineTrigger, String>
  get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RoutineRecurrence, RoutineRecurrence, String>
  get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get customDays => $composableBuilder(
    column: $table.customDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineCompletionsRefs(
    Expression<bool> Function($$RoutineCompletionsTableFilterComposer f) f,
  ) {
    final $$RoutineCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineCompletions,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.routineCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customDays => $composableBuilder(
    column: $table.customDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RoutineTrigger, String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RoutineRecurrence, String> get recurrence =>
      $composableBuilder(
        column: $table.recurrence,
        builder: (column) => column,
      );

  GeneratedColumn<String> get customDays => $composableBuilder(
    column: $table.customDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> routineCompletionsRefs<T extends Object>(
    Expression<T> Function($$RoutineCompletionsTableAnnotationComposer a) f,
  ) {
    final $$RoutineCompletionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineCompletions,
          getReferencedColumn: (t) => t.routineId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineCompletionsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineCompletions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          RoutineRow,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (RoutineRow, $$RoutinesTableReferences),
          RoutineRow,
          PrefetchHooks Function({bool routineCompletionsRefs})
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<RoutineTrigger> trigger = const Value.absent(),
                Value<String?> scheduledTime = const Value.absent(),
                Value<RoutineRecurrence> recurrence = const Value.absent(),
                Value<String?> customDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                title: title,
                trigger: trigger,
                scheduledTime: scheduledTime,
                recurrence: recurrence,
                customDays: customDays,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required RoutineTrigger trigger,
                Value<String?> scheduledTime = const Value.absent(),
                required RoutineRecurrence recurrence,
                Value<String?> customDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                title: title,
                trigger: trigger,
                scheduledTime: scheduledTime,
                recurrence: recurrence,
                customDays: customDays,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineCompletionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineCompletionsRefs) db.routineCompletions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineCompletionsRefs)
                    await $_getPrefetchedData<
                      RoutineRow,
                      $RoutinesTable,
                      RoutineCompletionRow
                    >(
                      currentTable: table,
                      referencedTable: $$RoutinesTableReferences
                          ._routineCompletionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$RoutinesTableReferences(
                        db,
                        table,
                        p0,
                      ).routineCompletionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.routineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      RoutineRow,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (RoutineRow, $$RoutinesTableReferences),
      RoutineRow,
      PrefetchHooks Function({bool routineCompletionsRefs})
    >;
typedef $$RoutineCompletionsTableCreateCompanionBuilder =
    RoutineCompletionsCompanion Function({
      Value<int> id,
      required int routineId,
      required DateTime completedAt,
    });
typedef $$RoutineCompletionsTableUpdateCompanionBuilder =
    RoutineCompletionsCompanion Function({
      Value<int> id,
      Value<int> routineId,
      Value<DateTime> completedAt,
    });

final class $$RoutineCompletionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RoutineCompletionsTable,
          RoutineCompletionRow
        > {
  $$RoutineCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_completions__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineCompletionsTable,
          RoutineCompletionRow,
          $$RoutineCompletionsTableFilterComposer,
          $$RoutineCompletionsTableOrderingComposer,
          $$RoutineCompletionsTableAnnotationComposer,
          $$RoutineCompletionsTableCreateCompanionBuilder,
          $$RoutineCompletionsTableUpdateCompanionBuilder,
          (RoutineCompletionRow, $$RoutineCompletionsTableReferences),
          RoutineCompletionRow,
          PrefetchHooks Function({bool routineId})
        > {
  $$RoutineCompletionsTableTableManager(
    _$AppDatabase db,
    $RoutineCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineCompletionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> routineId = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => RoutineCompletionsCompanion(
                id: id,
                routineId: routineId,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int routineId,
                required DateTime completedAt,
              }) => RoutineCompletionsCompanion.insert(
                id: id,
                routineId: routineId,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.routineId,
                        referencedTable: $$RoutineCompletionsTableReferences
                            ._routineIdTable(db),
                        referencedColumn: $$RoutineCompletionsTableReferences
                            ._routineIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutineCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineCompletionsTable,
      RoutineCompletionRow,
      $$RoutineCompletionsTableFilterComposer,
      $$RoutineCompletionsTableOrderingComposer,
      $$RoutineCompletionsTableAnnotationComposer,
      $$RoutineCompletionsTableCreateCompanionBuilder,
      $$RoutineCompletionsTableUpdateCompanionBuilder,
      (RoutineCompletionRow, $$RoutineCompletionsTableReferences),
      RoutineCompletionRow,
      PrefetchHooks Function({bool routineId})
    >;
typedef $$HealthSnapshotsTableCreateCompanionBuilder =
    HealthSnapshotsCompanion Function({
      required DateTime date,
      Value<int> steps,
      Value<int> workoutsCompleted,
      required DateTime syncedAt,
      Value<int?> caloriesConsumed,
      Value<double?> proteinGrams,
      Value<double?> carbsGrams,
      Value<double?> fatGrams,
      Value<int> rowid,
    });
typedef $$HealthSnapshotsTableUpdateCompanionBuilder =
    HealthSnapshotsCompanion Function({
      Value<DateTime> date,
      Value<int> steps,
      Value<int> workoutsCompleted,
      Value<DateTime> syncedAt,
      Value<int?> caloriesConsumed,
      Value<double?> proteinGrams,
      Value<double?> carbsGrams,
      Value<double?> fatGrams,
      Value<int> rowid,
    });

class $$HealthSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthSnapshotsTable> {
  $$HealthSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workoutsCompleted => $composableBuilder(
    column: $table.workoutsCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caloriesConsumed => $composableBuilder(
    column: $table.caloriesConsumed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthSnapshotsTable> {
  $$HealthSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workoutsCompleted => $composableBuilder(
    column: $table.workoutsCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caloriesConsumed => $composableBuilder(
    column: $table.caloriesConsumed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthSnapshotsTable> {
  $$HealthSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get workoutsCompleted => $composableBuilder(
    column: $table.workoutsCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<int> get caloriesConsumed => $composableBuilder(
    column: $table.caloriesConsumed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatGrams =>
      $composableBuilder(column: $table.fatGrams, builder: (column) => column);
}

class $$HealthSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthSnapshotsTable,
          HealthSnapshotRow,
          $$HealthSnapshotsTableFilterComposer,
          $$HealthSnapshotsTableOrderingComposer,
          $$HealthSnapshotsTableAnnotationComposer,
          $$HealthSnapshotsTableCreateCompanionBuilder,
          $$HealthSnapshotsTableUpdateCompanionBuilder,
          (
            HealthSnapshotRow,
            BaseReferences<
              _$AppDatabase,
              $HealthSnapshotsTable,
              HealthSnapshotRow
            >,
          ),
          HealthSnapshotRow,
          PrefetchHooks Function()
        > {
  $$HealthSnapshotsTableTableManager(
    _$AppDatabase db,
    $HealthSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<int> workoutsCompleted = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
                Value<int?> caloriesConsumed = const Value.absent(),
                Value<double?> proteinGrams = const Value.absent(),
                Value<double?> carbsGrams = const Value.absent(),
                Value<double?> fatGrams = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthSnapshotsCompanion(
                date: date,
                steps: steps,
                workoutsCompleted: workoutsCompleted,
                syncedAt: syncedAt,
                caloriesConsumed: caloriesConsumed,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                Value<int> steps = const Value.absent(),
                Value<int> workoutsCompleted = const Value.absent(),
                required DateTime syncedAt,
                Value<int?> caloriesConsumed = const Value.absent(),
                Value<double?> proteinGrams = const Value.absent(),
                Value<double?> carbsGrams = const Value.absent(),
                Value<double?> fatGrams = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthSnapshotsCompanion.insert(
                date: date,
                steps: steps,
                workoutsCompleted: workoutsCompleted,
                syncedAt: syncedAt,
                caloriesConsumed: caloriesConsumed,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthSnapshotsTable,
      HealthSnapshotRow,
      $$HealthSnapshotsTableFilterComposer,
      $$HealthSnapshotsTableOrderingComposer,
      $$HealthSnapshotsTableAnnotationComposer,
      $$HealthSnapshotsTableCreateCompanionBuilder,
      $$HealthSnapshotsTableUpdateCompanionBuilder,
      (
        HealthSnapshotRow,
        BaseReferences<_$AppDatabase, $HealthSnapshotsTable, HealthSnapshotRow>,
      ),
      HealthSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$GamificationStatesTableCreateCompanionBuilder =
    GamificationStatesCompanion Function({
      Value<int> id,
      Value<int> currentXp,
      Value<int> currentLevel,
      Value<int> currentStreak,
      Value<int> longestStreak,
      required DateTime lastEvaluatedDate,
    });
typedef $$GamificationStatesTableUpdateCompanionBuilder =
    GamificationStatesCompanion Function({
      Value<int> id,
      Value<int> currentXp,
      Value<int> currentLevel,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<DateTime> lastEvaluatedDate,
    });

class $$GamificationStatesTableFilterComposer
    extends Composer<_$AppDatabase, $GamificationStatesTable> {
  $$GamificationStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentXp => $composableBuilder(
    column: $table.currentXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastEvaluatedDate => $composableBuilder(
    column: $table.lastEvaluatedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GamificationStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamificationStatesTable> {
  $$GamificationStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentXp => $composableBuilder(
    column: $table.currentXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastEvaluatedDate => $composableBuilder(
    column: $table.lastEvaluatedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamificationStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamificationStatesTable> {
  $$GamificationStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentXp =>
      $composableBuilder(column: $table.currentXp, builder: (column) => column);

  GeneratedColumn<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastEvaluatedDate => $composableBuilder(
    column: $table.lastEvaluatedDate,
    builder: (column) => column,
  );
}

class $$GamificationStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamificationStatesTable,
          GamificationStateRow,
          $$GamificationStatesTableFilterComposer,
          $$GamificationStatesTableOrderingComposer,
          $$GamificationStatesTableAnnotationComposer,
          $$GamificationStatesTableCreateCompanionBuilder,
          $$GamificationStatesTableUpdateCompanionBuilder,
          (
            GamificationStateRow,
            BaseReferences<
              _$AppDatabase,
              $GamificationStatesTable,
              GamificationStateRow
            >,
          ),
          GamificationStateRow,
          PrefetchHooks Function()
        > {
  $$GamificationStatesTableTableManager(
    _$AppDatabase db,
    $GamificationStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamificationStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamificationStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamificationStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentXp = const Value.absent(),
                Value<int> currentLevel = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<DateTime> lastEvaluatedDate = const Value.absent(),
              }) => GamificationStatesCompanion(
                id: id,
                currentXp: currentXp,
                currentLevel: currentLevel,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastEvaluatedDate: lastEvaluatedDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentXp = const Value.absent(),
                Value<int> currentLevel = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                required DateTime lastEvaluatedDate,
              }) => GamificationStatesCompanion.insert(
                id: id,
                currentXp: currentXp,
                currentLevel: currentLevel,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastEvaluatedDate: lastEvaluatedDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GamificationStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamificationStatesTable,
      GamificationStateRow,
      $$GamificationStatesTableFilterComposer,
      $$GamificationStatesTableOrderingComposer,
      $$GamificationStatesTableAnnotationComposer,
      $$GamificationStatesTableCreateCompanionBuilder,
      $$GamificationStatesTableUpdateCompanionBuilder,
      (
        GamificationStateRow,
        BaseReferences<
          _$AppDatabase,
          $GamificationStatesTable,
          GamificationStateRow
        >,
      ),
      GamificationStateRow,
      PrefetchHooks Function()
    >;
typedef $$BadgesTableCreateCompanionBuilder = BadgesCompanion Function({
  Value<int> id,
  required String code,
  required DateTime unlockedAt,
});
typedef $$BadgesTableUpdateCompanionBuilder = BadgesCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<DateTime> unlockedAt,
});

class $$BadgesTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$BadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTable,
          BadgeRow,
          $$BadgesTableFilterComposer,
          $$BadgesTableOrderingComposer,
          $$BadgesTableAnnotationComposer,
          $$BadgesTableCreateCompanionBuilder,
          $$BadgesTableUpdateCompanionBuilder,
          (BadgeRow, BaseReferences<_$AppDatabase, $BadgesTable, BadgeRow>),
          BadgeRow,
          PrefetchHooks Function()
        > {
  $$BadgesTableTableManager(_$AppDatabase db, $BadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
          }) => BadgesCompanion(id: id, code: code, unlockedAt: unlockedAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required DateTime unlockedAt,
              }) => BadgesCompanion.insert(
                id: id,
                code: code,
                unlockedAt: unlockedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTable,
      BadgeRow,
      $$BadgesTableFilterComposer,
      $$BadgesTableOrderingComposer,
      $$BadgesTableAnnotationComposer,
      $$BadgesTableCreateCompanionBuilder,
      $$BadgesTableUpdateCompanionBuilder,
      (BadgeRow, BaseReferences<_$AppDatabase, $BadgesTable, BadgeRow>),
      BadgeRow,
      PrefetchHooks Function()
    >;
typedef $$DataSourceSettingsTableCreateCompanionBuilder =
    DataSourceSettingsCompanion Function({
      Value<int> id,
      Value<String> weightSource,
      Value<String> workoutSource,
      Value<String> nutritionSource,
    });
typedef $$DataSourceSettingsTableUpdateCompanionBuilder =
    DataSourceSettingsCompanion Function({
      Value<int> id,
      Value<String> weightSource,
      Value<String> workoutSource,
      Value<String> nutritionSource,
    });

class $$DataSourceSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $DataSourceSettingsTable> {
  $$DataSourceSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightSource => $composableBuilder(
    column: $table.weightSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutSource => $composableBuilder(
    column: $table.workoutSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutritionSource => $composableBuilder(
    column: $table.nutritionSource,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DataSourceSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $DataSourceSettingsTable> {
  $$DataSourceSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightSource => $composableBuilder(
    column: $table.weightSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutSource => $composableBuilder(
    column: $table.workoutSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutritionSource => $composableBuilder(
    column: $table.nutritionSource,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DataSourceSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DataSourceSettingsTable> {
  $$DataSourceSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get weightSource => $composableBuilder(
    column: $table.weightSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workoutSource => $composableBuilder(
    column: $table.workoutSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nutritionSource => $composableBuilder(
    column: $table.nutritionSource,
    builder: (column) => column,
  );
}

class $$DataSourceSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DataSourceSettingsTable,
          DataSourceSettingRow,
          $$DataSourceSettingsTableFilterComposer,
          $$DataSourceSettingsTableOrderingComposer,
          $$DataSourceSettingsTableAnnotationComposer,
          $$DataSourceSettingsTableCreateCompanionBuilder,
          $$DataSourceSettingsTableUpdateCompanionBuilder,
          (
            DataSourceSettingRow,
            BaseReferences<
              _$AppDatabase,
              $DataSourceSettingsTable,
              DataSourceSettingRow
            >,
          ),
          DataSourceSettingRow,
          PrefetchHooks Function()
        > {
  $$DataSourceSettingsTableTableManager(
    _$AppDatabase db,
    $DataSourceSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DataSourceSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DataSourceSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DataSourceSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> weightSource = const Value.absent(),
                Value<String> workoutSource = const Value.absent(),
                Value<String> nutritionSource = const Value.absent(),
              }) => DataSourceSettingsCompanion(
                id: id,
                weightSource: weightSource,
                workoutSource: workoutSource,
                nutritionSource: nutritionSource,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> weightSource = const Value.absent(),
                Value<String> workoutSource = const Value.absent(),
                Value<String> nutritionSource = const Value.absent(),
              }) => DataSourceSettingsCompanion.insert(
                id: id,
                weightSource: weightSource,
                workoutSource: workoutSource,
                nutritionSource: nutritionSource,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DataSourceSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DataSourceSettingsTable,
      DataSourceSettingRow,
      $$DataSourceSettingsTableFilterComposer,
      $$DataSourceSettingsTableOrderingComposer,
      $$DataSourceSettingsTableAnnotationComposer,
      $$DataSourceSettingsTableCreateCompanionBuilder,
      $$DataSourceSettingsTableUpdateCompanionBuilder,
      (
        DataSourceSettingRow,
        BaseReferences<
          _$AppDatabase,
          $DataSourceSettingsTable,
          DataSourceSettingRow
        >,
      ),
      DataSourceSettingRow,
      PrefetchHooks Function()
    >;
typedef $$WeightEntriesTableCreateCompanionBuilder =
    WeightEntriesCompanion Function({
      required DateTime date,
      required double kilograms,
      Value<int> rowid,
    });
typedef $$WeightEntriesTableUpdateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<DateTime> date,
      Value<double> kilograms,
      Value<int> rowid,
    });

class $$WeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kilograms => $composableBuilder(
    column: $table.kilograms,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kilograms => $composableBuilder(
    column: $table.kilograms,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get kilograms =>
      $composableBuilder(column: $table.kilograms, builder: (column) => column);
}

class $$WeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightEntriesTable,
          WeightEntryRow,
          $$WeightEntriesTableFilterComposer,
          $$WeightEntriesTableOrderingComposer,
          $$WeightEntriesTableAnnotationComposer,
          $$WeightEntriesTableCreateCompanionBuilder,
          $$WeightEntriesTableUpdateCompanionBuilder,
          (
            WeightEntryRow,
            BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntryRow>,
          ),
          WeightEntryRow,
          PrefetchHooks Function()
        > {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<double> kilograms = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightEntriesCompanion(
                date: date,
                kilograms: kilograms,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                required double kilograms,
                Value<int> rowid = const Value.absent(),
              }) => WeightEntriesCompanion.insert(
                date: date,
                kilograms: kilograms,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightEntriesTable,
      WeightEntryRow,
      $$WeightEntriesTableFilterComposer,
      $$WeightEntriesTableOrderingComposer,
      $$WeightEntriesTableAnnotationComposer,
      $$WeightEntriesTableCreateCompanionBuilder,
      $$WeightEntriesTableUpdateCompanionBuilder,
      (
        WeightEntryRow,
        BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntryRow>,
      ),
      WeightEntryRow,
      PrefetchHooks Function()
    >;
typedef $$NutritionEntriesTableCreateCompanionBuilder =
    NutritionEntriesCompanion Function({
      required DateTime date,
      required int calories,
      Value<double?> proteinGrams,
      Value<double?> carbsGrams,
      Value<double?> fatGrams,
      Value<int> rowid,
    });
typedef $$NutritionEntriesTableUpdateCompanionBuilder =
    NutritionEntriesCompanion Function({
      Value<DateTime> date,
      Value<int> calories,
      Value<double?> proteinGrams,
      Value<double?> carbsGrams,
      Value<double?> fatGrams,
      Value<int> rowid,
    });

class $$NutritionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NutritionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NutritionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatGrams =>
      $composableBuilder(column: $table.fatGrams, builder: (column) => column);
}

class $$NutritionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NutritionEntriesTable,
          NutritionEntryRow,
          $$NutritionEntriesTableFilterComposer,
          $$NutritionEntriesTableOrderingComposer,
          $$NutritionEntriesTableAnnotationComposer,
          $$NutritionEntriesTableCreateCompanionBuilder,
          $$NutritionEntriesTableUpdateCompanionBuilder,
          (
            NutritionEntryRow,
            BaseReferences<
              _$AppDatabase,
              $NutritionEntriesTable,
              NutritionEntryRow
            >,
          ),
          NutritionEntryRow,
          PrefetchHooks Function()
        > {
  $$NutritionEntriesTableTableManager(
    _$AppDatabase db,
    $NutritionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<double?> proteinGrams = const Value.absent(),
                Value<double?> carbsGrams = const Value.absent(),
                Value<double?> fatGrams = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NutritionEntriesCompanion(
                date: date,
                calories: calories,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                required int calories,
                Value<double?> proteinGrams = const Value.absent(),
                Value<double?> carbsGrams = const Value.absent(),
                Value<double?> fatGrams = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NutritionEntriesCompanion.insert(
                date: date,
                calories: calories,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NutritionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NutritionEntriesTable,
      NutritionEntryRow,
      $$NutritionEntriesTableFilterComposer,
      $$NutritionEntriesTableOrderingComposer,
      $$NutritionEntriesTableAnnotationComposer,
      $$NutritionEntriesTableCreateCompanionBuilder,
      $$NutritionEntriesTableUpdateCompanionBuilder,
      (
        NutritionEntryRow,
        BaseReferences<
          _$AppDatabase,
          $NutritionEntriesTable,
          NutritionEntryRow
        >,
      ),
      NutritionEntryRow,
      PrefetchHooks Function()
    >;
typedef $$WorkoutEntriesTableCreateCompanionBuilder =
    WorkoutEntriesCompanion Function({
      Value<int> id,
      required WorkoutCategory category,
      required DateTime start,
      required DateTime end,
      Value<int?> caloriesBurned,
    });
typedef $$WorkoutEntriesTableUpdateCompanionBuilder =
    WorkoutEntriesCompanion Function({
      Value<int> id,
      Value<WorkoutCategory> category,
      Value<DateTime> start,
      Value<DateTime> end,
      Value<int?> caloriesBurned,
    });

class $$WorkoutEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutEntriesTable> {
  $$WorkoutEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WorkoutCategory, WorkoutCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutEntriesTable> {
  $$WorkoutEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutEntriesTable> {
  $$WorkoutEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WorkoutCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => column,
  );
}

class $$WorkoutEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutEntriesTable,
          WorkoutEntryRow,
          $$WorkoutEntriesTableFilterComposer,
          $$WorkoutEntriesTableOrderingComposer,
          $$WorkoutEntriesTableAnnotationComposer,
          $$WorkoutEntriesTableCreateCompanionBuilder,
          $$WorkoutEntriesTableUpdateCompanionBuilder,
          (
            WorkoutEntryRow,
            BaseReferences<
              _$AppDatabase,
              $WorkoutEntriesTable,
              WorkoutEntryRow
            >,
          ),
          WorkoutEntryRow,
          PrefetchHooks Function()
        > {
  $$WorkoutEntriesTableTableManager(
    _$AppDatabase db,
    $WorkoutEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<WorkoutCategory> category = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<DateTime> end = const Value.absent(),
                Value<int?> caloriesBurned = const Value.absent(),
              }) => WorkoutEntriesCompanion(
                id: id,
                category: category,
                start: start,
                end: end,
                caloriesBurned: caloriesBurned,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required WorkoutCategory category,
                required DateTime start,
                required DateTime end,
                Value<int?> caloriesBurned = const Value.absent(),
              }) => WorkoutEntriesCompanion.insert(
                id: id,
                category: category,
                start: start,
                end: end,
                caloriesBurned: caloriesBurned,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutEntriesTable,
      WorkoutEntryRow,
      $$WorkoutEntriesTableFilterComposer,
      $$WorkoutEntriesTableOrderingComposer,
      $$WorkoutEntriesTableAnnotationComposer,
      $$WorkoutEntriesTableCreateCompanionBuilder,
      $$WorkoutEntriesTableUpdateCompanionBuilder,
      (
        WorkoutEntryRow,
        BaseReferences<_$AppDatabase, $WorkoutEntriesTable, WorkoutEntryRow>,
      ),
      WorkoutEntryRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$RoutineCompletionsTableTableManager get routineCompletions =>
      $$RoutineCompletionsTableTableManager(_db, _db.routineCompletions);
  $$HealthSnapshotsTableTableManager get healthSnapshots =>
      $$HealthSnapshotsTableTableManager(_db, _db.healthSnapshots);
  $$GamificationStatesTableTableManager get gamificationStates =>
      $$GamificationStatesTableTableManager(_db, _db.gamificationStates);
  $$BadgesTableTableManager get badges =>
      $$BadgesTableTableManager(_db, _db.badges);
  $$DataSourceSettingsTableTableManager get dataSourceSettings =>
      $$DataSourceSettingsTableTableManager(_db, _db.dataSourceSettings);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db, _db.weightEntries);
  $$NutritionEntriesTableTableManager get nutritionEntries =>
      $$NutritionEntriesTableTableManager(_db, _db.nutritionEntries);
  $$WorkoutEntriesTableTableManager get workoutEntries =>
      $$WorkoutEntriesTableTableManager(_db, _db.workoutEntries);
}
