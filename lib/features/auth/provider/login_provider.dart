import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/auth/data/user_model.dart';
import 'package:gps_student_attendance/features/auth/services/auth_services.dart';
import 'package:hive/hive.dart';

final loginObsecureTextProvider = StateProvider<bool>((ref) => true);

final loginProvider =
    StateNotifierProvider<LoginProvider, Users>((ref) => LoginProvider());

class LoginProvider extends StateNotifier<Users> {
  LoginProvider() : super(Users());

  void setEmail(String value) {
    state = state.copyWith(email: () => value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: () => value);
  }

  void loginUser(
      {required WidgetRef ref, required BuildContext context}) async {
    CustomDialog.showLoading(message: 'Logging in.....');
    var (message, user) = await AuthServices.login(
        email: state.email!, password: state.password!);
    if (user != null) {
      if (user.emailVerified == false) {
        CustomDialog.dismiss();
        CustomDialog.showInfo(
            message: 'Your email is not verified, please verify your email',
            buttonText: 'Send verification',
            onPressed: () async {
              await user.sendEmailVerification();
              await AuthServices.auth.signOut();
              CustomDialog.dismiss();
              CustomDialog.showSuccess(message: 'Verification email sent');
            });
        return;
      }
      var (_, userData) = await AuthServices.getUserData(user.uid);
      if (userData.id == null) {
        await AuthServices.auth.signOut();
        CustomDialog.dismiss();
        CustomDialog.showError(message: 'User not found');
        return;
      }

      var box = Hive.box('user');
      box.put('id', userData.id);
      state = userData;
      ref.read(userProvider.notifier).setUser(userData);
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: message);

      context.go(RouterInfo.homeRoute.path);
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message);
    }
  }

  void setUser(Users userData) {
    state = userData;
  }

  void signOut({required BuildContext context, required WidgetRef ref}) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Logging out.....');
    var done = await AuthServices.signOut();
    if (done) {
      var box = Hive.box('user');
      box.delete('id');
      ref.read(userProvider.notifier).removeUser();
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Logged out successfully');
      context.go(RouterInfo.loginRoute.path);
    }
  }
}

final loginProviderStream = StreamProvider.autoDispose<Users>((ref) async* {
  //! save dummy ClassList to fire base
  //List<ClassModel> dummyClass = await ClassServices.getClasses();
  // List<ClassModel> dummyClassList = ClassModel.dummyClassList();
  //List<Users> dummyUser = Users.dummyList();
  //List<Users> savesUsersList = await AuthServices.getUsers();
  // //save dummy users to firestore
  // final faker = Faker();
  // for (var user in savesUsersList) {
  //   user.indexNumber = faker.randomGenerator.numbers(9, 10).toList().join();
  //   await AuthServices.updateUserData(user);
  // }
  // //save dummy class to firestore
  // for (var classModel in dummyClassList) {
  //   var lect =
  //       savesUsersList
  //       .where((element) => element.userType == 'Lecturer').toList();
  //   var students =
  //       savesUsersList
  //       .where((element) => element.userType == 'Student').toList();
  //   lect.shuffle();
  //   students.shuffle();
  //   classModel.lecturerId = lect.first.id!;
  //   classModel.lecturerName = lect.first.name!;
  //   classModel.lecturerImage = lect.first.profileImage;
  //   classModel.students = students.map((e) => e.toMap()).toList().sublist(0, 60);
  //   classModel.studentIds = students.map((e) => e.id!).toList().sublist(0, 60);
  //   await ClassServices.createClass(classModel);
  // }
  //!==================================================
  var user = await AuthServices.checkIfLoggedIn();
  if (user.id != null) {
    ref.read(userProvider.notifier).setUser(user);
  }
  yield user;
});

final userProvider = StateNotifierProvider<UserProvider, Users>((ref) {
  return UserProvider();
});

class UserProvider extends StateNotifier<Users> {
  UserProvider() : super(Users());

  void setUser(Users user) {
    state = user;
  }

  void removeUser() {
    state = Users();
  }

  void setName(String value) {
    state = state.copyWith(name: () => value);
  }

  void setPrefix(String string) {
    state = state.copyWith(prefix: () => string);
  }

  void setGender(String s) {
    state = state.copyWith(
      gender: () => s,
    );
  }
}
