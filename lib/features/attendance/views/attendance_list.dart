import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/functions/navigation.dart';
import 'package:gps_student_attendance/core/functions/time_functions.dart';
import 'package:gps_student_attendance/core/widget/custom_button.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:gps_student_attendance/features/attendance/provider/attendance_provider.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/widget/table/data/models/custom_table_columns_model.dart';
import '../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../../core/widget/table/widgets/custom_table.dart';
import '../data/attendance_students_model.dart';
import '../provider/atten_actions_provider.dart';

class AttendanceListPage extends ConsumerStatefulWidget {
  const AttendanceListPage({this.id, required this.classId, super.key});
  final String? id;
  final String classId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AttendanceListPageState();
}

class _AttendanceListPageState extends ConsumerState<AttendanceListPage> {
  @override
  Widget build(BuildContext context) {
    var attendance = ref.watch(attendanceById(widget.id!));
    var styles = CustomStyles(context: context);
    var classList = ref.watch(classProvider);
    var thisClass = classList
        .where((element) => element.id == widget.classId)
        .toList()
        .first;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: attendance.when(data: (attendance) {
            return _buildAttendanceList(attendance!, thisClass, styles);
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, error: (error, stack) {
            return Center(
              child: Text('Error: $error'),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAttendanceList(
      AttendanceModel attendance, ClassModel thisClass, CustomStyles styles) {
    var students =
        attendance.students.map((e) => StudentsModel.fromJson(e)).toList();
    var textStyles = CustomStyles(context: context).textStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        desktop: 16,
        mobile: 14,
        tablet: 15);
    var breakPoint = ResponsiveBreakpoints.of(context);
    return CustomTable<StudentsModel>(
        header: Row(
          children: [
            IconButton(
                onPressed: () {
                  navigateToRoute(
                      context: context, route: RouterInfo.homeRoute);
                },
                icon: const Icon(Icons.close)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${thisClass.code}: ${thisClass.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styles.textStyle(
                        fontWeight: FontWeight.bold,
                        desktop: 22,
                        mobile: 17,
                        color: primaryColor),
                  ),
                  //const SizedBox(height: 2),
                  //class time
                  Text(
                    'Time: ${TimeUtils.formatDateTime(attendance.date!)}',
                    style: styles.textStyle(
                        fontWeight: FontWeight.w600,
                        desktop: 18,
                        mobile: 14,
                        color: secondaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (breakPoint.smallerThan(TABLET))
              IconButton(
                  onPressed: () {},
                  icon: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(.4),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(2)),
                      child: const Icon(Icons.import_export))),
            if (breakPoint.largerThan(MOBILE))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CustomButton(
                  text: 'Export Data',
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  radius: 10,
                  color: secondaryColor,
                  onPressed: () {
                    //export data
                    ref
                        .read(attendanceProvider.notifier)
                        .exportData(students, context, ref);
                  },
                  icon: const Icon(Icons.file_copy),
                ),
              ),
          ],
        ),
        data: students,
        pageSize: 10,
        rows: [
          for (var student in students)
            CustomTableRow<StudentsModel>(
                item: student,
                index: students.indexOf(student),
                context: context,
                onHover: (value) {})
        ],
        columns: [
          CustomTableColumn<StudentsModel>(
              width: 200,
              title: 'Index Number',
              cellBuilder: (item) {
                return Text(
                  item.indexNumber,
                  style: textStyles,
                );
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Full Name',
              cellBuilder: (item) {
                return Text(item.name, style: textStyles);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Gender',
              width: 100,
              cellBuilder: (item) {
                return Text(item.gender, style: textStyles);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Email',
              cellBuilder: (item) {
                return Text(item.email, style: textStyles);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Phone',
              width: 120,
              cellBuilder: (item) {
                return Text(item.phone, style: textStyles);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Mode',
              width: 100,
              cellBuilder: (item) {
                return Text(item.mode, style: textStyles);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Time',
              cellBuilder: (item) {
                return Text(TimeUtils.formatDateTime(item.time),
                    style: textStyles);
              }),
        ]);
  }
}
