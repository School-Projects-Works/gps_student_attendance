import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/features/auth/services/auth_services.dart';
import 'package:gps_student_attendance/features/auth/views/auth_main_page.dart';
import 'package:gps_student_attendance/features/auth/views/pages/login_page.dart';
import 'package:gps_student_attendance/features/auth/views/pages/registration_page.dart';
import 'package:gps_student_attendance/features/lecturer/views/lecturer_home_page.dart';
import 'package:gps_student_attendance/features/lecturer/views/lecturer_main.dart';
import 'package:gps_student_attendance/features/student/views/student_main.dart';

import '../../features/student/views/student_home_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _authShellNavigatorKey = GlobalKey<NavigatorState>();
final _lecturerShellNavigatorKey = GlobalKey<NavigatorState>();
final _studentShellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouterInfo.loginRoute.path,
    redirect: (context, state) async {
      var user = await AuthServices.checkIfLoggedIn();
      if (user.id != null) {
        if (user.userType == 'Student') {
          return RouterInfo.studentHomeRoute.path;
        } else {
          return RouterInfo.lecturerHomeRoute.path;
        }
      }
      return null;
    },
    routes: [
      ShellRoute(
          navigatorKey: _authShellNavigatorKey,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state, child) {
            return AuthMainPage(
              shellContext: _authShellNavigatorKey.currentContext,
              child: child,
            );
          },
          routes: [
            GoRoute(
                path: RouterInfo.loginRoute.path,
                name: RouterInfo.loginRoute.name,
                builder: (context, state) => const LoginPage()),
            GoRoute(
                path: RouterInfo.registerRoute.path,
                name: RouterInfo.registerRoute.name,
                builder: (context, state) => const RegistrationPage()),
          ]),
      ShellRoute(
          navigatorKey: _lecturerShellNavigatorKey,
          builder: (context, state, child) {
            return LectureMain(
              shellContext: _lecturerShellNavigatorKey.currentContext,
              child: child,
            );
          },
          routes: [
            GoRoute(
                path: RouterInfo.lecturerHomeRoute.path,
                name: RouterInfo.lecturerHomeRoute.name,
                builder: (context, state) => const LecturerHomePage()),
          ]),
      ShellRoute(
          navigatorKey: _studentShellNavigatorKey,
          builder: (context, state, child) {
            return StudentMain(
              shellContext: _studentShellNavigatorKey.currentContext,
              child: child,
            );
          },
          routes: [
            GoRoute(
                path: RouterInfo.studentHomeRoute.path,
                name: RouterInfo.studentHomeRoute.name,
                builder: (context, state) => const StudentHomePage()),
          ])
    ]);
