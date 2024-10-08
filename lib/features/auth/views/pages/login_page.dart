import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/functions/navigation.dart';
import 'package:gps_student_attendance/core/widget/custom_button.dart';
import 'package:gps_student_attendance/core/widget/custom_input.dart';
import 'package:gps_student_attendance/features/auth/provider/login_provider.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var styles = CustomStyles(context: context);
    var breakPoint = ResponsiveBreakpoints.of(context);
    ref.watch(loginProvider);
    var notifier = ref.read(loginProvider.notifier);

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        height: breakPoint.screenHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: breakPoint.equals(MOBILE)
                    ? breakPoint.screenHeight * .8
                    : null,
                alignment: Alignment.center,
                child: Card(
                  elevation: breakPoint.smallerThan(DESKTOP) ? 0 : 5,
                  child: Container(
                    width: breakPoint.smallerThan(TABLET)
                        ? double.infinity
                        : breakPoint.screenWidth < 1200
                            ? breakPoint.screenWidth * .75
                            : breakPoint.screenWidth * .6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: ResponsiveRowColumn(
                        layout: breakPoint.smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        columnMainAxisSize: MainAxisSize.min,
                        columnCrossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: ResponsiveVisibility(
                                visible: false,
                                visibleConditions: const [
                                  Condition.largerThan(name: TABLET)
                                ],
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 400,
                                        color: Colors.white,
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                                'assets/images/login.png',
                                                width: 200,
                                                height: 200),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ResponsiveVisibility(
                                            hiddenConditions: const [
                                              Condition.largerThan(name: TABLET)
                                            ],
                                            child: Image.asset(
                                                'assets/images/login.png',
                                                width: 100,
                                                height: 100)),
                                        Text(
                                          'Login ',
                                          style: styles.textStyle(
                                              color: primaryColor,
                                              mobile: 35,
                                              desktop: 45,
                                              tablet: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Divider(
                                          thickness: 3,
                                          color: secondaryColor,
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextFields(
                                          label: 'Email',
                                          prefixIcon: Icons.email,
                                          //controller: _emailController,
                                          hintText: 'Enter your email',
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          onSaved: (email) {
                                            notifier.setEmail(email!);
                                          },
                                          validator: (email) {
                                            if (email == null ||
                                                email.isEmpty) {
                                              return 'Email is required';
                                            } else if (!RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(email)) {
                                              return 'Enter a valid email';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextFields(
                                          label: 'Password',
                                          prefixIcon: Icons.lock,
                                          hintText: 'Enter your password',
                                          //controller: _passwordController,
                                          obscureText: ref
                                              .watch(loginObsecureTextProvider),
                                          suffixIcon: IconButton(
                                            icon: Icon(ref.watch(
                                                    loginObsecureTextProvider)
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              ref
                                                      .read(
                                                          loginObsecureTextProvider
                                                              .notifier)
                                                      .state =
                                                  !ref.read(
                                                      loginObsecureTextProvider);
                                            },
                                          ),
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          onSaved: (password) {
                                            notifier.setPassword(password!);
                                          },
                                          validator: (password) {
                                            if (password == null ||
                                                password.isEmpty) {
                                              return 'Password is required';
                                            } else if (password.length < 6) {
                                              return 'Password must be at least 6 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        //forget password
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              navigateToRoute(
                                                  context: context,
                                                  route: RouterInfo
                                                      .forgetPasswordRoute);
                                            },
                                            child: Text(
                                              'Forget Password?',
                                              style: styles.textStyle(
                                                  color: primaryColor,
                                                  mobile: 14,
                                                  desktop: 16,
                                                  tablet: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        CustomButton(
                                          text: 'Proceed',
                                          radius: 5,
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              //todo login user
                                              _formKey.currentState!.save();
                                              notifier.loginUser(
                                                  ref: ref, context: context);
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Don\'t have an account?',
                                                style: styles.textStyle(
                                                    color: secondaryColor,
                                                    mobile: 14,
                                                    desktop: 14,
                                                    tablet: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  navigateToRoute(
                                                      context: context,
                                                      route: RouterInfo
                                                          .registerRoute);
                                                },
                                                child: Text(
                                                  'Register',
                                                  style: styles.textStyle(
                                                      color: primaryColor,
                                                      mobile: 14,
                                                      desktop: 14,
                                                      tablet: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ])
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
