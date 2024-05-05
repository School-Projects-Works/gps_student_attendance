import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/core/functions/color_convertor.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../auth/provider/login_provider.dart';

class ClassCard extends ConsumerStatefulWidget {
  const ClassCard(this.classModel, {super.key});
  final ClassModel classModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassCardState();
}

class _ClassCardState extends ConsumerState<ClassCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    var styles = CustomStyles(context: context);
    var pointBreaker = ResponsiveBreakpoints.of(context);
    var user = ref.watch(userProvider);
    return InkWell(
        onTap: () {
          // navigate to class detail
        },
        onHover: (value) {
          setState(() {
            _hover = value;
          });
        },
        child: Card(
            elevation: _hover ? 6 : 1,
            child: Container(
              width: pointBreaker.isMobile ? pointBreaker.screenWidth : 300,
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
                            if (user.userType == 'Lecturer'
                                //&&
                                // user.id == widget.classModel.lecturerId
                                )
                              //popup menu
                              PopupMenuButton<int>(
                                color: Colors.white,
                                iconColor: Colors.white38,
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    padding:
                                        EdgeInsets.only(right: 50, left: 20),
                                    value: 0,
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 10),
                                        Text('Edit Class'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    padding:
                                        EdgeInsets.only(right: 50, left: 20),
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Icon(Icons.close),
                                        SizedBox(width: 10),
                                        Text('Close Class'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    padding:
                                        EdgeInsets.only(right: 50, left: 20),
                                    value: 2,
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
                                  //Todo implement the popup menu
                                },
                              )
                          ],
                        ),
                        // const SizedBox(height: 5),
                        //description
                        Text(
                          widget.classModel.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styles.textStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                              desktop: 13),
                        ),
                        const SizedBox(height: 12),
                        //lecturer,
                        Text(
                          widget.classModel.lecturerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styles.textStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
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
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        widget.classModel.lecturerImage != null
                                            ? NetworkImage(
                                                widget.classModel
                                                        .lecturerImage ??
                                                    '',
                                              )
                                            : null,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: widget
                                                    .classModel.lecturerImage !=
                                                null
                                            ? null
                                            : Text(
                                                widget
                                                    .classModel.lecturerName[0]
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
                        const SizedBox(height: 40),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
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
            )));
  }
}
