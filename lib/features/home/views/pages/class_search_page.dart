import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';
import 'package:gps_student_attendance/features/home/views/components/class_card.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/widget/custom_input.dart';
import '../../../auth/provider/login_provider.dart';

class ClassSearchPage extends ConsumerStatefulWidget {
  const ClassSearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClassSearchPageState();
}

class _ClassSearchPageState extends ConsumerState<ClassSearchPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var breakPoint = ResponsiveBreakpoints.of(context);
    var styles = CustomStyles(context: context);
    var filteredList = ref.watch(filteredClassList);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: primaryColor,
            ),
            onPressed: () {
              CustomDialog.dismiss();
            },
          ),
          title: Text(
            'Find a Class',
            style:
                styles.textStyle(color: primaryColor, mobile: 20, desktop: 23),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: breakPoint.isMobile
                    ? breakPoint.screenWidth
                    : breakPoint.isTablet
                        ? breakPoint.screenWidth * 0.5
                        : breakPoint.screenWidth * 0.3,
                child: CustomTextFields(
                  hintText: 'Search Class',
                  radius: 15,
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                  },
                  suffixIcon: const Icon(Icons.search),
                  onSubmitted: (value) {},
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: filteredList
                            .map((e) => ClassCard(
                                  e,
                                  hasJoin: true,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
