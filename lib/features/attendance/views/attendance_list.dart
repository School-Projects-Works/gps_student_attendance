import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/core/functions/time_functions.dart';
import 'package:gps_student_attendance/core/widget/custom_button.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:gps_student_attendance/features/attendance/provider/attendance_provider.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';
import 'package:gps_student_attendance/utils/styles.dart';
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
    return CustomTable<StudentsModel>(
        header: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${thisClass.code}: ${thisClass.name}',
                  style: styles.textStyle(
                      fontWeight: FontWeight.bold,
                      desktop: 22,
                      mobile: 17,
                      color: primaryColor),
                ),
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
            const Spacer(),
            CustomButton(
              text: 'Export Data',
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
              title: 'Index Number',
              cellBuilder: (item) {
                return Text(item.indexNumber);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Full Name',
              cellBuilder: (item) {
                return Text(item.name);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Gender',
              width: 100,
              cellBuilder: (item) {
                return Text(item.gender);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Email',
              cellBuilder: (item) {
                return Text(item.email);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Phone',
              width: 100,
              cellBuilder: (item) {
                return Text(item.phone);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Mode',
              width: 100,
              cellBuilder: (item) {
                return Text(item.mode);
              }),
          CustomTableColumn<StudentsModel>(
              title: 'Time',
              cellBuilder: (item) {
                return Text(TimeUtils.formatDateTime(item.time));
              }),
        ]);
  }
}
