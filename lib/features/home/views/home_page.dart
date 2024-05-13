import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/functions/navigation.dart';
import 'package:gps_student_attendance/core/functions/transparent_page.dart';
import 'package:gps_student_attendance/core/widget/custom_button.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/attendance/provider/attendance_provider.dart';
import 'package:gps_student_attendance/features/attendance/views/new_attendnace.dart';
import 'package:gps_student_attendance/features/auth/data/user_model.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';
import 'package:gps_student_attendance/features/home/views/components/class_card.dart';
import 'package:gps_student_attendance/features/home/views/pages/class_search_page.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var userStream = ref.watch(loginProviderStream);

    var user = ref.watch(userProvider);
    var breakPiont = ResponsiveBreakpoints.of(context);
    var styles = CustomStyles(context: context);
    var classList = user.userType == 'Lecturer'
        ? ref.watch(classProvider)
        : ref
            .watch(classProvider)
            .where((element) => element.studentIds.contains(user.id))
            .toList();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: ResponsiveVisibility(
          visible: false,
          visibleConditions: const [
            Condition.equals(name: MOBILE),
          ],
          child: Padding(
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
              onSelected: (value) async {
                if (value == 0) {
                  navigateToRoute(
                      context: context, route: RouterInfo.newClassRoute);
                } else {
                  CustomDialog.showCustom(
                      width: breakPiont.isMobile
                          ? breakPiont.screenWidth
                          : breakPiont.isTablet
                              ? breakPiont.screenWidth * 0.5
                              : breakPiont.screenWidth * 0.3,
                      height: breakPiont.screenHeight,
                      ui: const ClassSearchPage());
                }
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (breakPiont.largerThan(TABLET))
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _buildSideList(ref: ref, context: context),
                ),
              Expanded(
                child: classList.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              children:
                                  classList.map((e) => ClassCard(e)).toList(),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text('You do not have any class yet',
                            style: styles.textStyle()),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideList(
      {required WidgetRef ref, required BuildContext context}) {
    var classList = ref.watch(classProvider);
    var user = ref.watch(userProvider);
    var breakPiont = ResponsiveBreakpoints.of(context);
    var styles = CustomStyles(context: context);
    var attendanceList = ref.watch(attendanceByStudentsAllClassStream);
    if (user.userType == 'Lecturer') {
      attendanceList = ref.watch(attendanceByLecturerStream(user.id!));
    }
    return Column(
      children: [
        Container(
          width: 400,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text('My Attendance'.toUpperCase(),
              style: styles.textStyle(
                  color: Colors.white,
                  mobile: 22,
                  tablet: 25,
                  fontWeight: FontWeight.bold,
                  desktop: 30)),
        ),
        Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                attendanceList.when(data: (data) {
                  if (data.isEmpty) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No attendance yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ));
                  }
                  return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var attendance = data[index];
                        var students = attendance.students
                            .map((e) => Users.fromMap(e).indexNumber)
                            .toList();
                        return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${attendance.classCode} - ${attendance.className}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: styles.textStyle(
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                        desktop: 18,
                                        tablet: 16,
                                        mobile: 15),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: students
                                      .map((e) => Text(e ?? ''))
                                      .toList(),
                                ),
                                const SizedBox(height: 5),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'View all',
                                    style: styles.textStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ));
                      });
                }, error: (error, stack) {
                  return const Center(
                      child: Text(
                    'Error loading data',
                    style: TextStyle(color: Colors.red),
                  ));
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                }),
                const Divider(
                  height: 25,
                  color: secondaryColor,
                ),
                if (user.userType == 'Lecturer')
                  CustomButton(
                      text: 'Start Attendance',
                      onPressed: () {
                        if (classList.isNotEmpty) {
                          Navigator.of(context).push(TransparentRoute(
                              builder: (BuildContext context) =>
                                  const NewAttendance()));
                        } else {
                          CustomDialog.showError(
                              message: 'You do not have any class yet');
                        }
                      })
              ],
            ))
      ],
    );
  }
}
