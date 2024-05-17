import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/core/functions/navigation.dart';
import 'package:gps_student_attendance/core/functions/time_functions.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/attendance/provider/attendance_provider.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/router/router_info.dart';

Widget classAttendance(
    BuildContext context, ClassModel classModel, WidgetRef ref) {
  var attendance = ref.watch(attendanceByClassIdStream(classModel.id));
  var styles = CustomStyles(context: context);
  var breakPiont = ResponsiveBreakpoints.of(context);
  return Card(
      elevation: 6,
      child: SizedBox(
        height: breakPiont.screenHeight * .89,
        width: breakPiont.isMobile ? breakPiont.screenWidth * .95 : 500,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '${classModel.code} : ${classModel.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  const Spacer(),
                  //close
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const Divider(
                height: 25,
                color: secondaryColor,
              ),
              attendance.when(data: (attendance) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: attendance.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            TimeUtils.formatDateTime(
                                attendance[index].createdAt!,
                                onlyDate: true),
                            style: styles.textStyle(color: primaryColor),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Total Students: ${attendance[index].students.length}'),
                              //view button
                              TextButton(
                                onPressed: () {
                                  if (attendance[index].students.isNotEmpty) {
                                    navigateToName(
                                        context: context,
                                        route: RouterInfo.attendanceListRoute,
                                        parameter: {
                                          'id': attendance[index].id!,
                                          'classId': classModel.id
                                        });
                                    Navigator.pop(context);
                                  } else {
                                    CustomDialog.showError(
                                        message:
                                            'No attendance for this class yet');
                                  }
                                },
                                child: const Text('View'),
                              )
                            ],
                          ),
                        );
                      }),
                );
              }, loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }, error: (error, stack) {
                return Center(
                  child: Text('Error: $error'),
                );
              }),
            ],
          ),
        ),
      ));
}
