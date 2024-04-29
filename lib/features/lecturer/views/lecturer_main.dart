import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LectureMain extends ConsumerStatefulWidget {
  const LectureMain({required this.child, this.shellContext, super.key});
  final Widget child;
  final BuildContext? shellContext;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LectureMainState();
}

class _LectureMainState extends ConsumerState<LectureMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
    );
  }
}
