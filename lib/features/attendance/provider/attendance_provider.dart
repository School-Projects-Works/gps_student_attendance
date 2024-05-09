import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:gps_student_attendance/features/attendance/services/attendance_services.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';

final attendanceByClassIdStream = StreamProvider.family.autoDispose<List<AttendanceModel>,String>((ref,classId) async* {
  final attendanceSnap = AttendanceServices.getAttendanceByClassId(classId);
  await for (final attendance in attendanceSnap) {
    var list = attendance.docs.map((e) => AttendanceModel.fromMap(e.data())).toList();
    //order createdAt
    list.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    yield list;
  }
});


final attendanceByLecturerStream = StreamProvider.family.autoDispose<List<AttendanceModel>,String>((ref,lecturerId) async* {
  final attendanceSnap = AttendanceServices.getAttendanceByLecturerId(lecturerId);
  await for (final attendance in attendanceSnap) {
    var list = attendance.docs.map((e) => AttendanceModel.fromMap(e.data())).toList();
    //order createdAt
    list.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    yield list;
  }
});

final attendanceByStudentsAllClassStream = StreamProvider.autoDispose<List<AttendanceModel>>((ref) async* {
  var user = ref.watch(userProvider);
   final classesList = ref.watch(classProvider);
   if(user .id==null||user.userType=='Lecturer') return;
   var userClassList = classesList.where((element) => element.studentIds.contains(user.id)).toList();
   if(userClassList.isEmpty) return;
  final attendanceSnap = AttendanceServices.getAttendanceByClassIds(userClassList.map((e) => e.id).toList());
  await for (final attendance in attendanceSnap) {
    var list = attendance.docs.map((e) => AttendanceModel.fromMap(e.data())).toList();
    //order createdAt
    list.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    yield list;
  }
});
