import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/generated/assets.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = CustomStyles(context: context);
    var user = ref.watch(userProvider);
    return ResponsiveVisibility(
      visible: false,
      visibleConditions: const [
        Condition.largerThan(name: MOBILE),
      ],
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {},
        // ),
        title: InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            context.go(RouterInfo.homeRoute.path);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Assets.imagesIcon,
                  width: 40, height: 40, fit: BoxFit.cover),
              const SizedBox(width: 10),
              Text(
                'GPS | Attendance',
                style: styles.textStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    desktop: 28,
                    tablet: 22),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PopupMenuButton<int>(
              itemBuilder: (context) => [
                if (user.id != null && user.userType == 'Lecturer')
                  const PopupMenuItem(
                    padding: EdgeInsets.only(right: 70, left: 30),
                    value: 0,
                    child: ListTile(
                      title: Text('Create Class'),
                      leading: Icon(Icons.add),
                    ),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 1,
                  padding: EdgeInsets.only(right: 70, left: 30),
                  child: ListTile(
                    title: Text('Join Class'),
                    leading: Icon(Icons.join_full_outlined),
                  ),
                ),
              ],
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                icon: const Icon(Icons.add),
                onPressed: null,
              ),
            ),
          ),
          if (user.id != null)
            PopupMenuButton<int>(
              tooltip: 'User Manu',
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  padding: EdgeInsets.only(right: 70, left: 30),
                  child: ListTile(
                    title: Text('Profile'),
                    leading: Icon(Icons.person),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 1,
                  padding: EdgeInsets.only(right: 70, left: 30),
                  child: ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.logout),
                  ),
                ),
              ],
              onSelected: (index) {
                if (index == 0) {
                  
                  context.go(RouterInfo.profileRoute.path);
                } else {
                  CustomDialog.showInfo(
                      message: 'Want to logout?',
                      buttonText: 'Logout',
                      onPressed: () {
                        ref
                            .read(loginProvider.notifier)
                            .signOut(context: context, ref: ref);
                      });
                }
                //close popup
              },
              child: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: primaryColor),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
