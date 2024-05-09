import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/features/auth/services/auth_services.dart';
import 'package:gps_student_attendance/features/auth/views/auth_main_page.dart';
import 'package:gps_student_attendance/features/auth/views/pages/login_page.dart';
import 'package:gps_student_attendance/features/auth/views/pages/registration_page.dart';
import 'package:gps_student_attendance/features/class/views/edit_class.dart';
import 'package:gps_student_attendance/features/class/views/new_class.dart';
import 'package:gps_student_attendance/features/home/views/home_page.dart';
import 'package:gps_student_attendance/features/home/views/home_main.dart';
import 'package:gps_student_attendance/features/profile/view/profile_page.dart';
import 'package:hive/hive.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _authShellNavigatorKey = GlobalKey<NavigatorState>();
final _homeShellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter router(WidgetRef ref) => GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: RouterInfo.loginRoute.path,
        redirect: (context, state) async {

          var box = Hive.box('route').get('currentRoute').toString();
          var user = await AuthServices.checkIfLoggedIn();
          ref.read(userProvider.notifier).setUser(user);
          var route = state.matchedLocation;
          
          if ((route.contains('login'))) {
            if (user.id != null && user.id != '') {
              ref.read(userProvider.notifier).setUser(user);
              Hive.box('route').put('currentRoute', RouterInfo.homeRoute.name);
              return RouterInfo.homeRoute.path;
            }
            return null;
          } else if (route.contains('new-class') &&
              box.contains(RouterInfo.newClassRoute.name)) {
            return null;
              }else if (route.contains('edit-class') &&
              box.contains(RouterInfo.editClassRoute.name)) {
            return null;
          } else if (route.contains('home')) {
            Hive.box('route').put('currentRoute', RouterInfo.homeRoute.name);
            return null;
          } else if (route.contains('profile') &&
              box.contains(RouterInfo.profileRoute.name)) {
            return null;
          } else {
            return RouterInfo.homeRoute.path;
          }
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
                    builder: (context, state) => const ProfilePage()),
                GoRoute(
                    path: RouterInfo.newClassRoute.path,
                    name: RouterInfo.newClassRoute.name,
                    builder: (context, state) => const NewClass()),
                GoRoute(
                    path: RouterInfo.editClassRoute.path,
                    name: RouterInfo.editClassRoute.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'];
                      return EditClassPage(id!);
                    }),
              ]),
        ]);
