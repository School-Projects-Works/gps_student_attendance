
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/auth/data/user_model.dart';
import 'package:gps_student_attendance/features/auth/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      if(user.emailVerified==false){
        CustomDialog.dismiss();
        CustomDialog.showInfo(message: 'Your email is not verified, please verify your email',buttonText: 'Send verification',onPressed: ()async{
          await user.sendEmailVerification();
          await AuthServices.auth.signOut();
          CustomDialog.dismiss();
          CustomDialog.showSuccess(message: 'Verification email sent');
        });
        return;
      }
      var (_, userData) = await AuthServices.getUserData(user.uid);
      if(userData.id==null){
        await AuthServices.auth.signOut();
        CustomDialog.dismiss();
        CustomDialog.showError(message: 'User not found');     
        return;
      }
      // Obtain shared preferences.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', userData.id!);
      state = userData;
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: message);
      if(userData.userType=='Student'){
        context.go(RouterInfo.studentHomeRoute.path);
      
      }else{
        context.go(RouterInfo.lecturerHomeRoute.path);
      }
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(message: message);
    }
  }
  
  void setUser(Users userData) {
    state = userData;
  }
}


final loginProviderStream = StreamProvider<Users>((ref)async* {
final SharedPreferences prefs = await SharedPreferences.getInstance();
final String? userId = prefs.getString('user');
if(userId!=null){
  var (_, userData) = await AuthServices.getUserData(userId);
  if(userData.id!=null){
    ref.read(loginProvider.notifier).setUser(userData) ;
    yield userData;
  }else{
    yield Users();
  }
}

});