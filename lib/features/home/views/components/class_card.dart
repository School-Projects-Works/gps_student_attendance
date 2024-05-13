import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_student_attendance/config/router/router_info.dart';
import 'package:gps_student_attendance/core/functions/color_convertor.dart';
import 'package:gps_student_attendance/core/functions/navigation.dart';
import 'package:gps_student_attendance/core/functions/transparent_page.dart';
import 'package:gps_student_attendance/core/widget/custom_button.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:gps_student_attendance/features/attendance/provider/atten_actions_provider.dart';
import 'package:gps_student_attendance/features/attendance/provider/attendance_provider.dart';
import 'package:gps_student_attendance/features/attendance/views/new_attendnace.dart';
import 'package:gps_student_attendance/features/attendance/views/qr_widget.dart';
import 'package:gps_student_attendance/features/auth/data/user_model.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../auth/provider/login_provider.dart';
import '../../../class/provider/classes_provider.dart';

class ClassCard extends ConsumerStatefulWidget {
  const ClassCard(this.classModel, {super.key, this.hasJoin = false});
  final ClassModel classModel;
  final bool hasJoin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassCardState();
}

class _ClassCardState extends ConsumerState<ClassCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    var attendanceSream =
        ref.watch(attendanceByClassIdStream(widget.classModel.id));
    return InkWell(
        onTap: () {
          // navigate to class detail
        },
        onHover: (value) {
          setState(() {
            _hover = value;
          });
        },
        child: attendanceSream.when(
          loading: () {
            return _buildCard(loading: true);
          },
          error: ((error, stackTrace) {
            return _buildCard(error: error.toString());
          }),
          data: (data) {
            return _buildCard(attendance: data);
          },
        ));
  }

  Widget _buildCard(
      {List<AttendanceModel>? attendance,
      String? error,
      bool loading = false}) {
    var styles = CustomStyles(context: context);
    var pointBreaker = ResponsiveBreakpoints.of(context);
    var user = ref.watch(userProvider);
    //get active attendance
    List<AttendanceModel> activeAttendance = [];
    if (attendance != null) {
      activeAttendance = attendance
          .where((element) => element.status!.toLowerCase() == 'active')
          .toList();
    }
    print('Active : ${activeAttendance.length}');
    return Card(
        elevation: _hover ? 10 : 6,
        child: Container(
          width: pointBreaker.isMobile ? pointBreaker.screenWidth : 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.classModel.color != null
                      ? widget.classModel.color!.toColor()
                      : primaryColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.classModel.code} : ${widget.classModel.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styles.textStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                desktop: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (user.userType != 'Lecturer' &&
                            widget.classModel.studentIds.contains(user.id))
                          _studentManu(
                              user,
                              activeAttendance.isNotEmpty
                                  ? activeAttendance[0]
                                  : null),
                        if (user.userType == 'Lecturer' &&
                            user.id == widget.classModel.lecturerId)
                          _lecturerManu(
                              user,
                              activeAttendance.isNotEmpty
                                  ? activeAttendance[0]
                                  : null),
                      ],
                    ),
                    Text(
                      widget.classModel.lecturerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.textStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          desktop: 15),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                // padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -27),
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    widget.classModel.lecturerImage != null
                                        ? NetworkImage(
                                            widget.classModel.lecturerImage ??
                                                '',
                                          )
                                        : null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: widget.classModel.lecturerImage !=
                                            null
                                        ? null
                                        : Text(
                                            widget.classModel.lecturerName[0]
                                                .toUpperCase(),
                                            style: styles.textStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                desktop: 20,
                                                tablet: 20,
                                                mobile: 20),
                                          ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Class Day:',
                                style: styles.textStyle(color: secondaryColor),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.classModel.classDay ?? '',
                                style: styles.textStyle(
                                    color: widget.classModel.color!.toColor(),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Venue: ',
                                style: styles.textStyle(color: secondaryColor),
                              ),
                              Text(
                                widget.classModel.classVenue ?? '',
                                style: styles.textStyle(
                                    color: widget.classModel.color!.toColor(),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    //class start and end time
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Start At:',
                                style: styles.textStyle(color: secondaryColor),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.classModel.startTime ?? '',
                                style: styles.textStyle(
                                    color: widget.classModel.color!.toColor(),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'End At:',
                                style: styles.textStyle(color: secondaryColor),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.classModel.endTime ?? '',
                                style: styles.textStyle(
                                    color: widget.classModel.color!.toColor(),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // const Divider(
                    //   color: Colors.black12,
                    // ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          if (user.userType == 'Lecturer')
                            _buildLecturerButtons(
                                user,
                                activeAttendance.isNotEmpty
                                    ? activeAttendance[0]
                                    : null),
                          if (user.userType != 'Lecturer')
                            _buildStudentManu(
                                user,
                                activeAttendance.isNotEmpty
                                    ? activeAttendance[0]
                                    : null),
                          if (widget.hasJoin)
                            if (!widget.classModel.studentIds.contains(user.id))
                              TextButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            widget.classModel.color!.toColor()),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  onPressed: () {
                                    //join class
                                    ref
                                        .read(joinClassProvider.notifier)
                                        .joinClass(
                                            classModel: widget.classModel,
                                            users: user,
                                            ref: ref);
                                  },
                                  icon: const Icon(
                                    Icons.grass_rounded,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Join Class',
                                  )),
                          const Spacer(),
                          const Icon(Icons.school,
                              color: Colors.black54, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            '${widget.classModel.students.length}',
                            style: styles.textStyle(
                                color: Colors.black54,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                desktop: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildStudentManu(Users user, AttendanceModel? attendanceModel) {
    print('Attendance Model: ${attendanceModel?.toMap()}');
    var students =
        widget.classModel.students.map((e) => Users.fromMap(e)).toList();
    var studentFound =
        students.where((element) => element.id == user.id).toList().isNotEmpty;
    if (studentFound) {
      if (attendanceModel != null &&
          attendanceModel.studentIds.contains(user.id)) {
        return const Text(
          'You are in class Today',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        );
      }
      if (attendanceModel != null &&
          !attendanceModel.studentIds.contains(user.id)) {
        return TextButton.icon(
            onPressed: () {
              ref.read(attendanceProvider.notifier).markAttendance(
                  classModel: widget.classModel,
                  attendance: attendanceModel,
                  ref: ref);
            },
            icon: const Icon(Icons.check),
            label: const Text(
              'Mark Attendance',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ));
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildLecturerButtons(Users user, AttendanceModel? attendanceModel) {
    if (attendanceModel != null) {
      return TextButton.icon(
          onPressed: () {
            //Todo end attendance
          },
          icon: const Icon(Icons.cancel_presentation_rounded),
          label: const Text('End Attendance'));
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _studentManu(Users user, AttendanceModel? attendanceModel) {
    
    return PopupMenuButton<int>(
        color: Colors.white,
        iconColor: Colors.white38,
        itemBuilder: (context) {
          var students =
              widget.classModel.students.map((e) => Users.fromMap(e)).toList();
          var studentFound = students
              .where((element) => element.id == user.id)
              .toList()
              .isNotEmpty;
          return [
            if (studentFound)
              const PopupMenuItem(
                padding: EdgeInsets.only(right: 50, left: 20),
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 10),
                    Text('Leave Class'),
                  ],
                ),
              ),
            if (studentFound && attendanceModel != null)
              const PopupMenuItem(
                padding: EdgeInsets.only(right: 50, left: 20),
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.list_alt_rounded),
                    SizedBox(width: 10),
                    Text('View Attendance'),
                  ],
                ),
              ),
          ];
        },
        onSelected: (value) {
          switch (value) {
            case 0:
              //leave class
              CustomDialog.showInfo(
                  message: 'Are you sure you want to leave?',
                  buttonText: 'Leave',
                  onPressed: () {
                    ref.read(joinClassProvider.notifier).leaveClass(
                        classModel: widget.classModel, users: user, ref: ref);
                  });

              break;
            case 1:
              break;

            default:
              break;
          }
        });
  }

  Widget _lecturerManu(Users user, AttendanceModel? attendanceModel) {
    return PopupMenuButton<int>(
        color: Colors.white,
        iconColor: Colors.white38,
        itemBuilder: (context) => [
              if (attendanceModel != null)
                const PopupMenuItem(
                  padding: EdgeInsets.only(right: 50, left: 20),
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.cancel_presentation_rounded),
                      SizedBox(width: 10),
                      Text('End Attendance'),
                    ],
                  ),
                )
              else
                const PopupMenuItem(
                  padding: EdgeInsets.only(right: 50, left: 20),
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_rounded),
                      SizedBox(width: 10),
                      Text('Start Attendance'),
                    ],
                  ),
                ),
              if (attendanceModel != null)
                const PopupMenuItem(
                  padding: EdgeInsets.only(right: 50, left: 20),
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_rounded),
                      SizedBox(width: 10),
                      Text('Get QR Code'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                padding: EdgeInsets.only(right: 50, left: 20),
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.list_alt_rounded),
                    SizedBox(width: 10),
                    Text('View Attendance'),
                  ],
                ),
              ),
              const PopupMenuItem(
                padding: EdgeInsets.only(right: 50, left: 20),
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text('Edit Class'),
                  ],
                ),
              ),
              const PopupMenuItem(
                padding: EdgeInsets.only(right: 50, left: 20),
                value: 5,
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
        onSelected: (value) {
          switch (value) {
            case 0:
              //end attendance
              break;
            case 1:
              if (widget.classModel.students.isNotEmpty) {
                Navigator.of(context).push(TransparentRoute(
                    builder: (BuildContext context) => const NewAttendance()));
              } else {
                CustomDialog.showError(
                    message:
                        'No student in this class yet, Please add student to this class');
              }
              break;
            case 2:
              Navigator.of(context).push(TransparentRoute(
                  builder: (BuildContext context) =>
                      QRWidget(id: attendanceModel!.id!)));
              break;
            case 3:
              break;
            case 4:
              navigateToName(
                  context: context,
                  route: RouterInfo.editClassRoute,
                  parameter: {'id': widget.classModel.id});

              break;
            case 5:
              CustomDialog.showInfo(
                  message: 'Are you sure you want to delete this class?',
                  buttonText: 'Yes|Delete',
                  onPressed: () {
                    ref
                        .read(classProvider.notifier)
                        .deleteClass(widget.classModel.id);
                  });

              break;
            default:
              break;
          }
        });
  }
}
