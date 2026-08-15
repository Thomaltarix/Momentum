import 'package:flutter/material.dart';

// Temporary — replaced by the routines feature's home screen in Phase 2
// (see claude/roadmap.md). Exists only to prove the app shell runs end-to-end.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Momentum')),
      body: const Center(child: Text('Scaffold running.')),
    );
  }
}
