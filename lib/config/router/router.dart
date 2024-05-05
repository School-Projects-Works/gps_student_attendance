import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/features/auth/services/auth_services.dart';
import 'package:gps_student_attendance/features/auth/views/auth_main_page.dart';
import 'package:gps_student_attendance/features/auth/views/pages/login_page.dart';
import 'package:gps_student_attendance/features/auth/views/pages/registration_page.dart';
import 'package:gps_student_attendance/features/home/views/home_page.dart';
import 'package:gps_student_attendance/features/home/views/home_main.dart';
import 'package:gps_student_attendance/features/profile/view/profile_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _authShellNavigatorKey = GlobalKey<NavigatorState>();
final _homeShellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter router(WidgetRef ref) => GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: RouterInfo.loginRoute.path,
        redirect: (context, state) async {
          var user = await AuthServices.checkIfLoggedIn();
          // get current route and check if it is goint to login or home
          var route = state.fullPath;
          if (user.id != null&&(route!=null&&route.contains('login'))) {
            ref.read(userProvider.notifier).state = user;
            return RouterInfo.homeRoute.path;
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
              navigatorKey: _homeShellNavigatorKey,
              builder: (context, state, child) {
                return HomeMain(
                  shellContext: _homeShellNavigatorKey.currentContext,
                  child: child,
                );
              },
              routes: [
                GoRoute(
                    path: RouterInfo.homeRoute.path,
                    name: RouterInfo.homeRoute.name,
                    builder: (context, state) => const HomePage()),
                GoRoute(
                    path: RouterInfo.profileRoute.path,
                    name: RouterInfo.profileRoute.name,
                    builder: (context, state) => const ProfilePage())
              ]),
        ]);
