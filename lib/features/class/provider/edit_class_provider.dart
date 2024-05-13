// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/constants/departments.dart';
import 'package:gps_student_attendance/core/functions/navigation.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';
import 'package:gps_student_attendance/features/class/services/class_services.dart';

final editClassProvider =
    StateNotifierProvider<EditClassProvider, ClassModel>((ref) {
  return EditClassProvider();
});

class EditClassProvider extends StateNotifier<ClassModel> {
  EditClassProvider()
      : super(ClassModel(
          id: '',
          name: '',
          code: '',
          lecturerId: '',
          lecturerName: '',
        ));

  void setClass(ClassModel classItem) {
    state = classItem;
  }

  void setCode(String s) {
    state = state.copyWith(code: s);
  }

  void setName(String s) {
    state = state.copyWith(name: s);
  }

  void setClassDay(String string) {
    state = state.copyWith(classDay: () => string);
  }

  void setVenue(String s) {
    state = state.copyWith(classVenue: () => s);
  }

  void setStartTime(String string) {
    state = state.copyWith(startTime: () => string);
  }

  void setEndTime(String string) {
    state = state.copyWith(endTime: () => string);
  }

  void setDepartment(String e) {
    var departments = state.availableToDepartments ?? [];
    if (e == "All") {
      if (departments.length == departmentList.length) return;
      departments.clear();
      departments = departmentList;
      state = state.copyWith(availableToDepartments: () => departments);
      return;
    }
    departments.add(e);
    state = state.copyWith(availableToDepartments: () => departments);
  }

  void removeDepartment(String e) {
    state = state.copyWith(
        availableToDepartments: () => state.availableToDepartments!
            .where((element) => element != e)
            .toList());
  }

  void addLevel(String e) {
    var levels = state.availableToLevels ?? [];
    if (e == "All") {
      levels.clear();
      levels = [
        '100',
        '200',
        '300',
        '400',
        'Grad',
      ];
      state = state.copyWith(availableToLevels: () => levels);
      return;
    }
    levels.add(e);
    state = state.copyWith(availableToLevels: () => levels);
  }

  void removeLevel(String e) {
    state = state.copyWith(
        availableToLevels: () =>
            state.availableToLevels!.where((element) => element != e).toList());
  }

  void setClassType(String string) {
    state = state.copyWith(classType: () => string);
  }

  void updateClass(
      {required BuildContext context, required WidgetRef ref}) async {
    // Update a class
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Updating Class.....');
    var status = await ClassServices.updateClass(state);
    if (status) {
      ref.read(classProvider.notifier).updateClass(state);
      CustomDialog.dismiss();
      CustomDialog.showToast(message: 'Class Updated Successfully');
      if (mounted) {
        navigateToRoute(context: context, route: RouterInfo.homeRoute);
      }
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Failed to update class');
    }
  }
}
