import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';

final attendanceActionsProvider =
    StateNotifierProvider<AttendanceActionsProvider, void>(
        (ref) => AttendanceActionsProvider());

class AttendanceActionsProvider extends StateNotifier<void> {
  AttendanceActionsProvider() : super(null);

  void startAttendance({required ClassModel classModel, required WidgetRef ref}) {}

  void closeAttendance({required AttendanceModel attendance, required ClassModel classData, required WidgetRef ref}) {}

}
