import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gps_student_attendance/config/router/router.dart';
import 'package:gps_student_attendance/firebase_options.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:hive/hive.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_strategy/url_strategy.dart';

import 'features/auth/provider/login_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //remove hashbang from url
  setPathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.openBox('user');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'GPS Student Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      builder: FlutterSmartDialog.init(builder: (context, child) {
        var userStream = ref.watch(loginProviderStream);
        var widget = ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 600, name: MOBILE),
            const Breakpoint(start: 601, end: 900, name: TABLET),
            const Breakpoint(start: 901, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
       return userStream.when(
            data: (data){
              return widget;
            },
            error: (error, stack){
              return widget;
            },
            loading: () {
              return widget;
            });
      }),
      routerConfig: router(ref),
    );
  }
}
