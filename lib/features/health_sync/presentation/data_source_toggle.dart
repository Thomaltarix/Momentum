import 'package:flutter/material.dart';

import '../domain/data_source_mode.dart';

/// Shared by the Statut/Séances/Nutrition screens — each metric picks its
/// source independently (see claude/data-model.md).
class DataSourceToggle extends StatelessWidget {
  const DataSourceToggle({super.key, required this.mode, required this.onChanged});

  final DataSourceMode mode;
  final ValueChanged<DataSourceMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DataSourceMode>(
      segments: const [
        ButtonSegment(
          value: DataSourceMode.healthConnect,
          label: FittedBox(child: Text('Health Connect')),
        ),
        ButtonSegment(
          value: DataSourceMode.manual,
          label: FittedBox(child: Text('Manuel')),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
