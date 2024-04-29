import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentMain extends ConsumerWidget {
  const StudentMain({required this.child, this.shellContext, super.key});
  final Widget child;
  final BuildContext? shellContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
    );
  }
}
