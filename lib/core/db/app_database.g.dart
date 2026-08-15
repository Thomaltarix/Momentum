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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $RoutineCompletionsTable routineCompletions =
      $RoutineCompletionsTable(this);
  late final $HealthSnapshotsTable healthSnapshots = $HealthSnapshotsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    routineCompletions,
    healthSnapshots,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$RoutineCompletionsTableTableManager get routineCompletions =>
      $$RoutineCompletionsTableTableManager(_db, _db.routineCompletions);
  $$HealthSnapshotsTableTableManager get healthSnapshots =>
      $$HealthSnapshotsTableTableManager(_db, _db.healthSnapshots);
}
