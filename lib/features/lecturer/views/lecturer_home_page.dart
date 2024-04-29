import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LecturerHomePage extends ConsumerWidget {
  const LecturerHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: const Center(
        child: Text('Lecturer Home Page'),
      ),
      
    );
  }
}
