import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';

import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:gps_student_attendance/features/attendance/services/attendance_services.dart';
import 'package:gps_student_attendance/features/attendance/services/location_services.dart';
import 'package:gps_student_attendance/features/auth/data/user_model.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/services/class_services.dart';
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
      CustomDialog.showToast(message: message);
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
      required WidgetRef ref}) async {
    CustomDialog.showLoading(message: 'Marking Attendance....');
    var user = ref.watch(userProvider);
    var (success, message, position) = await GPSServices().getPosition();
    if (success) {
      var distance = GPSServices.calculateDistance(position!.latitude,
          position.longitude, attendance.lat!, attendance.long!);
      if (distance==null || distance > 100) {
        CustomDialog.dismiss();
        CustomDialog.showError(message: 'You are not in the class location');
        return;
      }else{
        
      }
    }else{
      CustomDialog.dismiss();
      CustomDialog.showError(message: message!);
      return;
    }
  }
}
