import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/constants/departments.dart';
import 'package:gps_student_attendance/core/constants/time_list.dart';
import 'package:gps_student_attendance/core/widget/custom_drop_down.dart';
import 'package:gps_student_attendance/features/class/provider/classes_provider.dart';
import 'package:gps_student_attendance/features/class/provider/edit_class_provider.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/widget/custom_button.dart';
import '../../../core/widget/custom_input.dart';

class EditClassPage extends ConsumerStatefulWidget {
  const EditClassPage(this.id, {super.key});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditClassPageState();
}

class _EditClassPageState extends ConsumerState<EditClassPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    // check if widget is build
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var classList = ref.watch(classProvider);
      var classItem =
          classList.where((element) => element.id == widget.id).firstOrNull;
      if (classItem != null) {
        ref.read(editClassProvider.notifier).setClass(classItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var styles = CustomStyles(context: context);
    var breakPoint = ResponsiveBreakpoints.of(context);
    var editProvider = ref.watch(editClassProvider);
    var notifier = ref.read(editClassProvider.notifier);
    return SizedBox(
      width: breakPoint.screenWidth,
      height: breakPoint.screenHeight,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: breakPoint.isPhone
              ? double.infinity
              : breakPoint.isTablet
                  ? 600
                  : 800,
          height: breakPoint.screenHeight,
          child: Column(children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        'Update Class',
                        style: styles.textStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            mobile: 20,
                            desktop: 30,
                            tablet: 25),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          context.go(RouterInfo.homeRoute.path);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ])),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Form(
                      key: _formKey,
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text('Course Code:',
                                            style: styles.textStyle(
                                                mobile: 15,
                                                desktop: 18,
                                                tablet: 16)),
                                        subtitle: CustomTextFields(
                                          max: 7,
                                          isCapitalized: true,
                                          controller: TextEditingController(
                                              text: editProvider.code),
                                          hintText: 'Enter Course Code',
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Course code is required';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            notifier.setCode(value!);
                                          },
                                        ),
                                      ),
                                    ),
                                    //class title
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text('Course Title:',
                                            style: styles.textStyle(
                                                mobile: 15,
                                                desktop: 18,
                                                tablet: 16)),
                                        subtitle: CustomTextFields(
                                          hintText: 'Enter Course Title',
                                          controller: TextEditingController(
                                              text: editProvider.name),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Course title is required';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            notifier.setName(value!);
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text('Class Venue:',
                                            style: styles.textStyle(
                                                mobile: 15,
                                                desktop: 18,
                                                tablet: 16)),
                                        subtitle: CustomTextFields(
                                          hintText: 'Enter Class Venue',
                                          controller: TextEditingController(
                                              text: editProvider.classVenue),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Class venue is required';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            notifier.setVenue(value!);
                                          },
                                        ),
                                      ),
                                    ),
                                    //class day dropdown
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text('Class Day:',
                                            style: styles.textStyle(
                                                mobile: 15,
                                                desktop: 18,
                                                tablet: 16)),
                                        subtitle: CustomDropDown(
                                          value: editProvider.classDay,
                                          items: [
                                            'Monday',
                                            'Tuesday',
                                            'Wednesday',
                                            'Thursday',
                                            'Friday',
                                            'Saturday',
                                            'Sunday'
                                          ]
                                              .map((e) => DropdownMenuItem(
                                                  value: e, child: Text(e)))
                                              .toList(),
                                          onSaved: (day) {
                                            notifier
                                                .setClassDay(day.toString());
                                          },
                                          onChanged: (day) {},
                                          validator: (day) {
                                            if (day == null) {
                                              return 'Class day is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Text('Class Period:',
                                                  style: styles.textStyle(
                                                      mobile: 15,
                                                      desktop: 18,
                                                      tablet: 16)),
                                              subtitle: CustomDropDown(
                                                value: editProvider.startTime !=
                                                            null &&
                                                        editProvider.endTime !=
                                                            null
                                                    ? '${editProvider.startTime}-${editProvider.endTime}'
                                                    : null,
                                                items: timeList
                                                    .map((e) =>
                                                        DropdownMenuItem(
                                                            value: e,
                                                            child: Text(e)))
                                                    .toList(),
                                                onSaved: (time) {
                                                  notifier
                                                      .setTime(time.toString());
                                                },
                                                onChanged: (time) {
                                                  notifier
                                                      .setTime(time.toString());
                                                },
                                                validator: (time) {
                                                  if (time == null) {
                                                    return 'Period is required';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                    // department dropdown
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                            'Which department can join this class?',
                                            style: styles.textStyle(
                                                mobile: 15,
                                                desktop: 18,
                                                tablet: 16)),
                                        subtitle: Wrap(
                                          children: ['All', ...departmentList]
                                              .map((e) {
                                            //check boxes
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                      value: editProvider
                                                                  .availableToDepartments !=
                                                              null &&
                                                          editProvider
                                                              .availableToDepartments!
                                                              .contains(e),
                                                      onChanged: (value) {
                                                        if (value!) {
                                                          notifier
                                                              .setDepartment(e);
                                                        } else {
                                                          notifier
                                                              .removeDepartment(
                                                                  e);
                                                        }
                                                      }),
                                                  Text(
                                                    e,
                                                    style: styles.textStyle(
                                                        mobile: 15,
                                                        desktop: 18,
                                                        tablet: 16),
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    //which level can join this class
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                            'Which level can join this class?',
                                            style: styles.textStyle(
                                                mobile: 15,
                                                desktop: 18,
                                                tablet: 16)),
                                        subtitle: Wrap(
                                          children: [
                                            '100',
                                            '200',
                                            '300',
                                            '400',
                                            'Grad'
                                          ].map((e) {
                                            //check boxes
                                            return SizedBox(
                                              width: 100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Radio<String>(
                                                        groupValue: editProvider
                                                            .availableToLevels,
                                                        value: e,
                                                        onChanged: (value) {
                                                          if (value != null) {
                                                            notifier
                                                                .addLevel(e);
                                                          }
                                                        }),
                                                    Text(
                                                      e,
                                                      style: styles.textStyle(
                                                          mobile: 15,
                                                          desktop: 18,
                                                          tablet: 16),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomButton(
                                          text: 'Update Class',
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              notifier.updateClass(
                                                  context: context, ref: ref);
                                            }
                                          }),
                                    )
                                  ]),
                            ),
                          )))),
            )
          ]),
        ),
      ),
    );
  }
}
