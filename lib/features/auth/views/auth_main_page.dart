import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';

class AuthMainPage extends ConsumerStatefulWidget {
  const AuthMainPage({required this.child, this.shellContext, super.key});
  final Widget child;
  final BuildContext? shellContext;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthMainPageState();
}

class _AuthMainPageState extends ConsumerState<AuthMainPage> {
  @override
  Widget build(BuildContext context) {
    var loginStream = ref.watch(loginProviderStream);
    return SafeArea(
      child: Scaffold(
        body: loginStream.when(data: (data){
         return widget.child;
        }, error: (error,stack){
          return const Center(child: Text('Something went wrong'));
        }, loading: (){
          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
