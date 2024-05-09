import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/features/home/views/components/app_bar.dart';

import '../../class/provider/classes_provider.dart';

class HomeMain extends ConsumerStatefulWidget {
  const HomeMain({required this.child, this.shellContext, super.key});
  final Widget child;
  final BuildContext? shellContext;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LectureMainState();
}

class _LectureMainState extends ConsumerState<HomeMain> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var classesStream = ref.watch(classesStreamProvider(
        user.id!=null?user.userType=='Lecturer'?user.id!:'All':'All'));
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: AppBar().preferredSize, child: const CustomAppBar()),
        body: classesStream.when(data: (data) {
          return widget.child;
        }, error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}
