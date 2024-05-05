import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';
import 'package:gps_student_attendance/features/home/views/components/class_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userStream = ref.watch(loginProviderStream);
    var classList = ref.watch(classProvider);
    return userStream.when(data: (data) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: classList.map((e) => ClassCard(e)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }, error: (error, stackTrace) {
      return Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(), Text('Loading Data...')],
          ),
        ),
      );
    });
  }
}
