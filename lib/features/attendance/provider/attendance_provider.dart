import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:gps_student_attendance/features/attendance/provider/atten_actions_provider.dart';
import 'package:gps_student_attendance/features/attendance/services/attendance_services.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';

final attendanceByUserType =
    StreamProvider<List<AttendanceModel>>((ref) async* {
  var user = ref.watch(userProvider);
  if (user.id == null) yield[];
  if (user.userType == 'Lecturer') {
    final attendanceSnap =
        AttendanceServices.getAttendanceByLecturerId(user.id!);
    await for (var attendance in attendanceSnap) {
      var list = attendance.docs.map((e) {
        return AttendanceModel.fromMap(e.data());
      }).toList();
      //order createdAt
      list.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      ref.read(attendanceProvider.notifier).setAttendance(list);
      yield list;
    }
  } else {
    final classesList = ref.watch(classProvider);
    var userClassList = classesList
        .where((element) => element.studentIds.contains(user.id))
        .toList();
    if (userClassList.isEmpty) yield [];
    final attendanceSnap = AttendanceServices.getAttendanceByClassIds(
        userClassList.map((e) => e.id).toList());
    await for (final attendance in attendanceSnap) {
      var list = attendance.docs
          .map((e) => AttendanceModel.fromMap(e.data()))
          .toList();
      //order createdAt
      list.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      ref.read(attendanceProvider.notifier).setAttendance(list);
      yield list;
    }
  }
});
final attendanceByClassIdStream = StreamProvider.family
    .autoDispose<List<AttendanceModel>, String>((ref, classId) async* {
  final attendanceSnap = AttendanceServices.getAttendanceByClassId(classId);
  await for (final attendance in attendanceSnap) {
    List<Map<String, dynamic>> data =
        attendance.docs.map((e) => e.data()).toList();
    var list = data.map((e) => AttendanceModel.fromMap(e)).toList();
    //order createdAt
    list.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    ref.read(attendanceProvider.notifier).setAttendance(list);
    yield list;
  }
});

final attendanceById = FutureProvider.family
    .autoDispose<AttendanceModel?, String>((ref, id) async {
  var attendance = await AttendanceServices.getAttendanceById(id);
  return attendance;
});
