import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Student Home Page'),
      ),
    );
  }
}
