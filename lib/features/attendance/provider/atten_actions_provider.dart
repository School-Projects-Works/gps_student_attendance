import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_students_model.dart';
import 'package:gps_student_attendance/features/attendance/services/attendance_services.dart';
import 'package:gps_student_attendance/features/attendance/services/export_services.dart';
import 'package:gps_student_attendance/features/attendance/services/location_services.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/services/class_services.dart';
import 'package:intl/intl.dart';
import '../../../core/functions/time_functions.dart';
import '../../auth/provider/login_provider.dart';

class DefaultValues {
  bool useDefaultTime;
  bool useDefaultLocation;
  DefaultValues({
    required this.useDefaultTime,
    required this.useDefaultLocation,
  });

  DefaultValues copyWith({
    bool? useDefaultTime,
    bool? useDefaultLocation,
  }) {
    return DefaultValues(
      useDefaultTime: useDefaultTime ?? this.useDefaultTime,
      useDefaultLocation: useDefaultLocation ?? this.useDefaultLocation,
    );
  }
}

final userDefaultValuesProvider =
    StateNotifierProvider.autoDispose<UserDefaultValues, DefaultValues>(
        (ref) => UserDefaultValues());

class UserDefaultValues extends StateNotifier<DefaultValues> {
  UserDefaultValues()
      : super(DefaultValues(useDefaultTime: false, useDefaultLocation: false));

  void setDefaultTime(bool value) {
    state = state.copyWith(useDefaultTime: value);
  }

  void setDefaultLocation(bool value) {
    state = state.copyWith(useDefaultLocation: value);
  }
}

final lacTextProvider = StateNotifierProvider.autoDispose<LocationText,
    (TextEditingController, TextEditingController)>((ref) {
  return LocationText();
});

class LocationText
    extends StateNotifier<(TextEditingController, TextEditingController)> {
  LocationText() : super((TextEditingController(), TextEditingController()));

  void setLocationText(String lat, String long) {
    state =
        (TextEditingController(text: lat), TextEditingController(text: long));
  }

  void getLocationData({required WidgetRef ref}) async {
    CustomDialog.showLoading(message: 'Getting Location....');
    var (success, message, position) = await GPSServices().getPosition();
    if (success) {
      state = (
        TextEditingController(text: position!.latitude.toString()),
        TextEditingController(text: position.longitude.toString())
      );
      CustomDialog.dismiss();
      CustomDialog.showToast(message: 'Location Retrieved Successfully');
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message!);
    }
  }
}

final newAttendanceProvider =
    StateNotifierProvider.autoDispose<NewAttendanceProvider, AttendanceModel>(
        (ref) => NewAttendanceProvider());

class NewAttendanceProvider extends StateNotifier<AttendanceModel> {
  NewAttendanceProvider() : super(AttendanceModel());

  void setClass({required WidgetRef ref, required ClassModel calssData}) {
    state = state.copyWith(
      classCode: () => calssData.code,
      className: () => calssData.name,
      classId: () => calssData.id,
      startTime: () => calssData.startTime,
      endTime: () => calssData.endTime,
      lat: () => calssData.lat,
      long: () => calssData.long,
    );
    ref.read(lacTextProvider.notifier).setLocationText(
        calssData.lat != null ? calssData.lat.toString() : '',
        calssData.long != null ? calssData.long.toString() : '');
  }

  void startAttendance(
      {required WidgetRef ref,
      required BuildContext context,
      required ClassModel classModel}) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Starting Attendance....');
    //check if there is existing active attendance
    var activeAttendance =
        await AttendanceServices.getActiveAttendance(classId: classModel.id);
    if (activeAttendance != null) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          message: 'There is an active attendance for this class');
      return;
    }
    var user = ref.watch(userProvider);
    var lat = ref.watch(lacTextProvider).$1.text;
    var long = ref.watch(lacTextProvider).$2.text;
    String id = AttendanceServices.getId();
    state = state.copyWith(
      status: () => 'active',
      date: () => DateTime.now().millisecondsSinceEpoch,
      createdAt: () => DateTime.now().millisecondsSinceEpoch,
      lat: () => double.parse(lat),
      long: () => double.parse(long),
      lecturerId: () => user.id,
      lecturerName: () => user.name,
      id: () => id,
    );
    if (classModel.lat == null ||
        classModel.long == null ||
        classModel.lat != double.parse(lat) ||
        classModel.long != double.parse(long)) {
      classModel = classModel.copyWith(
          lat: () => double.parse(lat), long: () => double.parse(long));
      await ClassServices.updateClass(classModel);
    }
    var (status, message) =
        await AttendanceServices.startAttendance(attendance: state);
    if (status) {
      CustomDialog.dismiss();
      if (!kIsWeb) {
        CustomDialog.showSuccess(message: 'GPS on the web is not accurate.');
      } else {
        CustomDialog.showToast(message: message);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message);
    }
  }
}

final attendanceProvider = StateNotifierProvider.autoDispose<AttendanceProvider,
    List<AttendanceModel>>((ref) => AttendanceProvider());

class AttendanceProvider extends StateNotifier<List<AttendanceModel>> {
  AttendanceProvider() : super([]);

  void setAttendance(List<AttendanceModel> list) {
    state = list;
  }

  void markAttendance(
      {required ClassModel classModel,
      required AttendanceModel attendance,
      required String mode,
      required WidgetRef ref}) async {
    CustomDialog.showLoading(message: 'Marking Attendance....');
    var user = ref.watch(userProvider);
    //get current dat eand time
    var now = DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd');
    String today = dateFormat.format(now);
    String attendanceDate = dateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(attendance.date!));
    var startTime = TimeUtils.stringToTimeOfDay(classModel.startTime!);
    var endTime = TimeUtils.stringToTimeOfDay(classModel.endTime!);
    //check user is not already marked
    if (attendance.studentIds.contains(user.id)) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          message: 'You have already marked your attendance');
      return;
    }
    if (attendanceDate != today) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Attendance is over');
      return;
    }
    if (now.isBefore(DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute))) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Attendance has not started yet');
      return;
    }
    if (now.isAfter(
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute))) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Attendance is over');
      return;
    }
    if (attendance.studentIds.contains(user.id)) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          message: 'You have already marked your attendance');
      return;
    }
    if (mode.toLowerCase() == 'qr') {
      attendance.studentIds.add(user.id!);
      attendance.students.add({
        'id': user.id,
        'indexNumber': user.indexNumber,
        'email': user.email,
        'phone': user.phone,
        'gender': user.gender,
        'name': user.name,
        'mode': 'gr',
        'time': DateTime.now().millisecondsSinceEpoch
      });
      var (status, message) =
          await AttendanceServices.updateAttendance(attendance: attendance);
      if (status) {
        CustomDialog.dismiss();
        CustomDialog.showSuccess(message: message);
        return;
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: message);
        return;
      }
    } else {
      var (success, message, position) = await GPSServices().getPosition();
      if (success) {
        var distance = GPSServices.calculateDistance(position!.latitude,
            position.longitude, attendance.lat!, attendance.long!);
        if (distance == null || distance > 100) {
          CustomDialog.dismiss();
          CustomDialog.showError(
              message:
                  'You are not in the class location. Try using QR code to mark attendance');
          return;
        } else {
          attendance.studentIds.add(user.id!);
          attendance.students.add({
            'id': user.id,
            'indexNumber': user.indexNumber,
            'email': user.email,
            'phone': user.phone,
            'gender': user.gender,
            'name': user.name,
            'mode': 'gps',
            'time': DateTime.now().millisecondsSinceEpoch
          });
          var (status, message) =
              await AttendanceServices.updateAttendance(attendance: attendance);
          if (status) {
            CustomDialog.dismiss();
            CustomDialog.showSuccess(message: message);
            return;
          } else {
            CustomDialog.dismiss();
            CustomDialog.showError(message: message);
            return;
          }
        }
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: message!);
        return;
      }
    }
  }

  void endAttendance(AttendanceModel attendance)async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Ending Attendance....');
    attendance = attendance.copyWith(status: () => 'ended');
   var(sucess,message) =await AttendanceServices.updateAttendance(attendance: attendance);
    if(sucess){
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: message);
    }else{
      CustomDialog.dismiss();
      CustomDialog.showError(message: message);
    }
  }

  void exportData(List<StudentsModel> students, BuildContext context, WidgetRef ref) async{
    CustomDialog.showLoading(message: 'Exporting Data....');
    var message = await ExportServices().exportToExcel(students);
    CustomDialog.dismiss();
    CustomDialog.showToast(message: message);
    
  }
}
