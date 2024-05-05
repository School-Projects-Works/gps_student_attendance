import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/widget/custom_drop_down.dart';
import 'package:gps_student_attendance/core/widget/custom_input.dart';
import 'package:gps_student_attendance/core/widget/custom_selector.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var breakPoint = ResponsiveBreakpoints.of(context);
    var user = ref.watch(userProvider);
    var userNotifier = ref.read(userProvider.notifier);
    var styles = CustomStyles(context: context);
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SizedBox(
            width: breakPoint.isMobile
                ? breakPoint.screenWidth
                : breakPoint.isTablet
                    ? breakPoint.screenWidth * 0.6
                    : breakPoint.screenWidth * 0.45,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: !breakPoint.isMobile
                          ? BorderRadius.circular(10)
                          : BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 1))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Profile'.toUpperCase(),
                            style: styles.textStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                desktop: 28,
                                mobile: 20,
                                tablet: 22),
                          ),
                          const Spacer(),
                          //close button

                          IconButton(
                              onPressed: () {
                                context.go(RouterInfo.homeRoute.path);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 70,
                            height: 90,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                image: user.profileImage != null
                                    ? DecorationImage(
                                        image: NetworkImage(user.profileImage!),
                                        fit: BoxFit.cover)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: user.profileImage == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                  )
                                : null,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name ?? '',
                                  style: styles.textStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      desktop: 24,
                                      mobile: 18,
                                      tablet: 20),
                                ),
                                Text(
                                  user.email ?? '',
                                  style: styles.textStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      desktop: 18,
                                      mobile: 14,
                                      tablet: 16),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Column(children: [
                     ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('What is your full name ?',
                              style: styles.textStyle(
                                  mobile: 18, desktop: 25, tablet: 20)),
                          subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: CustomDropDown(
                                      items: [
                                        'Mr.',
                                        'Mrs.',
                                        'Miss',
                                        'Dr.',
                                        'Prof.',
                                      ]
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e)))
                                          .toList(),
                                      hintText: 'Select Prefix',
                                      onChanged: (value) {
                                        userNotifier.setPrefix(value.toString());
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: CustomTextFields(
                                      color: Colors.pink[700]!,
                                      hintText: 'Enter Full Name',
                                      onChanged: (value) {
                                        userNotifier.setName(value);
                                      },
                                    ),
                                  ),
                                ],
                              ))),
                 
                  ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('What is your gender ?',
                            style: styles.textStyle(
                                mobile: 18, desktop: 25, tablet: 20)),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomSelector(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 45),
                                  radius: 10,
                                  colors: secondaryColor,
                                  isSelected: user.gender == 'Male',
                                  onPressed: () {
                                    userNotifier.setGender('Male');
                                  },
                                  title: 'Male'),
                              const SizedBox(width: 10),
                              CustomSelector(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 45),
                                  radius: 10,
                                  colors: secondaryColor,
                                  isSelected: user.gender == 'Female',
                                  onPressed: () {
                                    userNotifier.setGender('Female');
                                  },
                                  title: 'Female'),
                            ],
                          ),
                        ),
                      ),
                  
                  ],),
                )
              ],
            )),
      ),
    ));
  }
}
