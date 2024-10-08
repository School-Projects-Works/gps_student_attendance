import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/constants/colors_list.dart';
import 'package:gps_student_attendance/core/constants/departments.dart';
import 'package:gps_student_attendance/core/functions/navigation.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/services/class_services.dart';
import '../../auth/provider/login_provider.dart';

final newClassProvider =
    StateNotifierProvider<NewClassProvider, ClassModel>((ref) {
  return NewClassProvider();
});

class NewClassProvider extends StateNotifier<ClassModel> {
  NewClassProvider()
      : super(ClassModel(
          id: '',
          name: '',
          code: '',
          lecturerId: '',
          lecturerName: '',
        ));

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setCode(String value) {
    state = state.copyWith(code: value);
  }

  void setClassDay(String value) {
    state = state.copyWith(classDay:  value);
  }
    void setVenue(String s) {
    state = state.copyWith(classVenue:  s);
    }


  void setTime(String string) {
    var time = string.split('-');
    state = state.copyWith(startTime:  time[0], endTime:  time[1]);
  }

  void setDepartment(String department) {
    var departments = state.availableToDepartments ?? [];
    if (department == "All" ) {
      if(departments.length == departmentList.length) return;
      departments.clear();
      departments = departmentList;
      state = state.copyWith(availableToDepartments:  departments);
      return;
    }
    departments.add(department);
    state = state.copyWith(availableToDepartments:  departments);
  }

  void addLevel(String level) {
   state = state.copyWith(availableToLevels: level);
  }


  void removeDepartment(String e) {
    state = state.copyWith(
        availableToDepartments:  state.availableToDepartments!
            .where((element) => element != e)
            .toList());
  }



  void createClass(
      {required BuildContext context, required WidgetRef ref}) async {
    colorsList.toList().shuffle();
    CustomDialog.showLoading(message: 'Creating Class.....');

   
    //check id class with the same code exist
    var user = ref.watch(userProvider);
    state = state.copyWith(
      lecturerId: user.id,
      classType: 'public',
      lecturerName: user.name,
      lecturerImage:  user.profileImage,
      color:  colorsList.first,
      status:  'active',
      createdAt:  DateTime.now().millisecondsSinceEpoch,
    );

    var (success, newMessage) = await ClassServices.createClass(state);
    CustomDialog.dismiss();
    if (success) {
      CustomDialog.showToast(message: newMessage);
      navigateToRoute(context: context, route: RouterInfo.homeRoute);
    } else {
      CustomDialog.showError(message: newMessage);
    }
  }


}
