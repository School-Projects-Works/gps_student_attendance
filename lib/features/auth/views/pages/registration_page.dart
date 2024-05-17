import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/functions/navigation.dart';
import 'package:gps_student_attendance/features/auth/provider/register_screen_provider.dart';
import 'package:gps_student_attendance/features/auth/views/pages/registration_pages/bio_data_page.dart';
import 'package:gps_student_attendance/features/auth/views/pages/registration_pages/user_type_page.dart';
import 'package:gps_student_attendance/generated/assets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: ResponsiveVisibility(
            hiddenConditions: const [Condition.largerThan(name: TABLET)],
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (ref.watch(currentScreenProvider) == 0) {
                    navigateToRoute(
                        context: context, route: RouterInfo.loginRoute);
                  } else {
                    ref.read(currentScreenProvider.notifier).state = 0;
                  }
                },
              ),
              title: Image.asset(Assets.imagesIcon, height: 30),
            ),
          ),
        ),
        body: Center(
          child: Card(
            elevation: 0,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              height: ResponsiveBreakpoints.of(context).screenHeight,
              width: ResponsiveBreakpoints.of(context).isMobile
                  ? ResponsiveBreakpoints.of(context).screenWidth
                  : ResponsiveBreakpoints.of(context).isTablet
                      ? ResponsiveBreakpoints.of(context).screenWidth * 0.8
                      : ResponsiveBreakpoints.of(context).screenWidth > 900 &&
                              ResponsiveBreakpoints.of(context).screenWidth <
                                  1280
                          ? ResponsiveBreakpoints.of(context).screenWidth * 0.6
                          : ResponsiveBreakpoints.of(context).screenWidth * 0.3,
              child: () {
                switch (ref.watch(currentScreenProvider)) {
                  case 0:
                    return const UserTypeScreen();
                  case 1:
                    return const BioDataPage();

                  default:
                    return Container();
                }
              }(),
            ),
          ),
        ),
      ),
    );
  }
}
