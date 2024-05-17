import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/core/constants/time_list.dart';
import 'package:gps_student_attendance/core/widget/custom_button.dart';
import 'package:gps_student_attendance/core/widget/custom_drop_down.dart';
import 'package:gps_student_attendance/core/widget/custom_input.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';
import 'package:gps_student_attendance/generated/assets.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/widget/custom_dialog.dart';
import '../../auth/provider/login_provider.dart';
import '../provider/atten_actions_provider.dart';

class NewAttendance extends ConsumerStatefulWidget {
  const NewAttendance({super.key, this.classModel});
  final ClassModel? classModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewAttendanceState();
}

class _NewAttendanceState extends ConsumerState<NewAttendance> {
  @override
  void initState() {
    super.initState();
    var notifier = ref.read(newAttendanceProvider.notifier);
    if (widget.classModel != null) {
      //Check if app is done building
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setClass(ref: ref, calssData: widget.classModel!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: _newAttendnace(classModel: widget.classModel),
        ));
  }

  Widget _newAttendnace({ClassModel? classModel}) {
    var user = ref.watch(userProvider);
    var breakPoint = ResponsiveBreakpoints.of(context);
    var styles = CustomStyles(context: context);
    var classList = ref.watch(classProvider);
    var defaultValues = ref.watch(userDefaultValuesProvider);
    var defaultNotifier = ref.read(userDefaultValuesProvider.notifier);
    classList =
        classList.where((element) => element.lecturerId == user.id).toList();
    var newAttendance = ref.watch(newAttendanceProvider);
    var notifier = ref.read(newAttendanceProvider.notifier);
    return Container(
      width: breakPoint.isMobile
          ? breakPoint.screenWidth
          : breakPoint.isTablet
              ? breakPoint.screenWidth * .6
              : 700,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'New Attendance',
                style: styles.textStyle(
                    color: primaryColor,
                    mobile: 20,
                    desktop: 23,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const Divider(
            height: 20,
            color: secondaryColor,
            thickness: 4,
          ),
          const SizedBox(height: 20),
          CustomDropDown(
              value: classModel?.code,
              hintText: 'Select Class',
              items: classList
                  .map((e) => e.code)
                  .toList()
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: classModel == null
                  ? (value) {
                      notifier.setClass(
                          ref: ref,
                          calssData: classList
                              .firstWhere((element) => element.code == value));
                    }
                  : null),
          const SizedBox(height: 20),
          //check box to use default start and end time
          if (newAttendance.startTime != null && newAttendance.endTime != null)
            Row(
              children: [
                Checkbox(
                  value: defaultValues.useDefaultTime,
                  onChanged: (value) {
                    defaultNotifier.setDefaultTime(value ?? false);
                  },
                ),
                Text('Use Default Start and End Time',
                    style: styles.textStyle(
                        color: primaryColor,
                        mobile: 15,
                        desktop: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomDropDown(
                    items: timeList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    hintText: 'Start Time',
                    value: newAttendance.startTime,
                    onChanged:
                        defaultValues.useDefaultTime ? null : (value) {
                      notifier.setStartTime(value.toString());
                        }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomDropDown(
                    items: timeList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    hintText: 'End Time',
                    value: newAttendance.endTime,
                    onChanged:
                        defaultValues.useDefaultTime ? null : (value) {
                      notifier.setEndTime(value.toString());
                        }),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (
              newAttendance.lat != null &&
              newAttendance.long != null)
            //check box to use default location
            Row(
              children: [
                Checkbox(
                  value: defaultValues.useDefaultLocation,
                  onChanged: (value) {
                    defaultNotifier.setDefaultLocation(value ?? false);
                  },
                ),
                Text('Use Default Location',
                    style: styles.textStyle(
                        color: primaryColor,
                        mobile: 15,
                        desktop: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          if (
              newAttendance.lat != null &&
              newAttendance.long != null)
            const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomTextFields(
                  hintText: 'Latitude',
                  isReadOnly: defaultValues.useDefaultLocation,
                  controller: ref.watch(lacTextProvider).$1,
                  isDigitOnly: true,
                  onChanged:
                      defaultValues.useDefaultLocation ? null : (value) {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextFields(
                  hintText: 'Longitude',
                  isReadOnly: defaultValues.useDefaultLocation,
                  controller: ref.watch(lacTextProvider).$2,
                  isDigitOnly: true,
                  onChanged:
                      defaultValues.useDefaultLocation ? null : (value) {},
                ),
              ),
              const SizedBox(width: 5),
              if (!defaultValues.useDefaultLocation)
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration:
                        BoxDecoration(border: Border.all(color: primaryColor)),
                    child: IconButton(
                        onPressed: () {
                          ref
                              .read(lacTextProvider.notifier)
                              .getLocationData(ref: ref);
                        },
                        icon: const Icon(Icons.location_on)))
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
              text: 'Start Attendance',
              onPressed: () {
                var selectedClass = classList
                    .where((element) => element.id == newAttendance.classId);
                if (selectedClass.isNotEmpty &&
                    selectedClass.first.students.isNotEmpty) {
                  if (newAttendance.classId == null) {
                    CustomDialog.showToast(message: 'Please select a class');
                    return;
                  }
                  if (newAttendance.startTime == null) {
                    CustomDialog.showToast(message: 'Please select start time');
                    return;
                  }
                  if (newAttendance.endTime == null) {
                    CustomDialog.showToast(message: 'Please select end time');
                    return;
                  }
                  if (ref.watch(lacTextProvider).$1.text.isEmpty ||
                      ref.watch(lacTextProvider).$2.text.isEmpty) {
                    CustomDialog.showToast(message: 'Please enter location');
                    return;
                  }
                  CustomDialog.showInfo(
                      message: 'Are you sure you want to start attendance?',
                      buttonText: 'Start',
                      onPressed: () {
                        notifier.startAttendance(ref: ref, context: context,classModel: selectedClass.first );
                      });
                } else {
                  //show error message
                  CustomDialog.showError(
                      message:
                          'No student in this class, Please add student to this class');
                }
              }),
         
          
        ],
      ),
    );
  }
}
