import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';


import 'package:gps_student_attendance/core/constants/colors_list.dart';

class ClassModel {
  String id;
  String name;
  String code;
  String? color;
  List<String>? availableToDepartments;
  List<String>? availableToLevels;
  String? classType;
  String lecturerId;
  String lecturerName;
  String? lecturerImage;
  List<String> studentIds;
  String? classDay;
  String? classVenue;
  String? status;
  String? startTime;
  String? endTime;
  double? lat;
  double? long;
  int? createdAt;
  List<Map<String, dynamic>> students;
  ClassModel({
    required this.id,
    required this.name,
    required this.code,
    this.color,
    this.availableToDepartments,
    this.availableToLevels,
    this.classType,
    required this.lecturerId,
    required this.lecturerName,
    this.lecturerImage,
    this.studentIds = const [],
    this.classDay,
    this.classVenue,
    this.status,
    this.startTime,
    this.endTime,
    this.lat,
    this.long,
    this.createdAt,
    this.students = const [],
  });

  ClassModel copyWith({
    String? id,
    String? name,
    String? code,
    ValueGetter<String?>? color,
    ValueGetter<List<String>?>? availableToDepartments,
    ValueGetter<List<String>?>? availableToLevels,
    ValueGetter<String?>? classType,
    String? lecturerId,
    String? lecturerName,
    ValueGetter<String?>? lecturerImage,
    List<String>? studentIds,
    ValueGetter<String?>? classDay,
    ValueGetter<String?>? classVenue,
    ValueGetter<String?>? status,
    ValueGetter<String?>? startTime,
    ValueGetter<String?>? endTime,
    ValueGetter<double?>? lat,
    ValueGetter<double?>? long,
    ValueGetter<int?>? createdAt,
    List<Map<String, dynamic>>? students,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      color: color != null ? color() : this.color,
      availableToDepartments: availableToDepartments != null ? availableToDepartments() : this.availableToDepartments,
      availableToLevels: availableToLevels != null ? availableToLevels() : this.availableToLevels,
      classType: classType != null ? classType() : this.classType,
      lecturerId: lecturerId ?? this.lecturerId,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerImage: lecturerImage != null ? lecturerImage() : this.lecturerImage,
      studentIds: studentIds ?? this.studentIds,
      classDay: classDay != null ? classDay() : this.classDay,
      classVenue: classVenue != null ? classVenue() : this.classVenue,
      status: status != null ? status() : this.status,
      startTime: startTime != null ? startTime() : this.startTime,
      endTime: endTime != null ? endTime() : this.endTime,
      lat: lat != null ? lat() : this.lat,
      long: long != null ? long() : this.long,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
      students: students ?? this.students,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'color': color,
      'availableToDepartments': availableToDepartments,
      'availableToLevels': availableToLevels,
      'classType': classType,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'lecturerImage': lecturerImage,
      'studentIds': studentIds,
      'classDay': classDay,
      'classVenue': classVenue,
      'status': status,
      'startTime': startTime,
      'endTime': endTime,
      'lat': lat,
      'long': long,
      'createdAt': createdAt,
      'students': students,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      color: map['color'],
      availableToDepartments: List<String>.from(map['availableToDepartments']),
      availableToLevels: List<String>.from(map['availableToLevels']),
      classType: map['classType'],
      lecturerId: map['lecturerId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerImage: map['lecturerImage'],
      studentIds: List<String>.from(map['studentIds']),
      classDay: map['classDay'],
      classVenue: map['classVenue'],
      status: map['status'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      lat: map['lat']?.toDouble(),
      long: map['long']?.toDouble(),
      createdAt: map['createdAt']?.toInt(),
      students: List<Map<String, dynamic>>.from(map['students']?.map((x) => Map<String, dynamic>.from(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassModel.fromJson(String source) =>
      ClassModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassModel(id: $id, name: $name, code: $code, color: $color, availableToDepartments: $availableToDepartments, availableToLevels: $availableToLevels, classType: $classType, lecturerId: $lecturerId, lecturerName: $lecturerName, lecturerImage: $lecturerImage, studentIds: $studentIds, classDay: $classDay, classVenue: $classVenue, status: $status, startTime: $startTime, endTime: $endTime, lat: $lat, long: $long, createdAt: $createdAt, students: $students)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ClassModel &&
      other.id == id &&
      other.name == name &&
      other.code == code &&
      other.color == color &&
      listEquals(other.availableToDepartments, availableToDepartments) &&
      listEquals(other.availableToLevels, availableToLevels) &&
      other.classType == classType &&
      other.lecturerId == lecturerId &&
      other.lecturerName == lecturerName &&
      other.lecturerImage == lecturerImage &&
      listEquals(other.studentIds, studentIds) &&
      other.classDay == classDay &&
      other.classVenue == classVenue &&
      other.status == status &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.lat == lat &&
      other.long == long &&
      other.createdAt == createdAt &&
      listEquals(other.students, students);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      code.hashCode ^
      color.hashCode ^
      availableToDepartments.hashCode ^
      availableToLevels.hashCode ^
      classType.hashCode ^
      lecturerId.hashCode ^
      lecturerName.hashCode ^
      lecturerImage.hashCode ^
      studentIds.hashCode ^
      classDay.hashCode ^
      classVenue.hashCode ^
      status.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      lat.hashCode ^
      long.hashCode ^
      createdAt.hashCode ^
      students.hashCode;
  }

  static List<ClassModel> dummyClassList() {
    final List<Map<String, String>> classInfo = [
      {"className": "MIT 718", "classTitle": "Introduction to Programming"},
      {"className": "GPD 112", "classTitle": "Data Structures"},
      {"className": "ITC 202", "classTitle": "Educational Leadership"},
      {"className": "XYZ 333", "classTitle": "Introduction to Algorithms"},
      {"className": "ABC 456", "classTitle": "Computer Networks"},
      {"className": "DEF 789", "classTitle": "Software Engineering"},
      {"className": "JKL 101", "classTitle": "Database Management Systems"},
      {"className": "PQR 505", "classTitle": "Web Development"},
      {"className": "MNO 808", "classTitle": "Artificial Intelligence"},
      {"className": "STU 909", "classTitle": "Machine Learning"},
      {"className": "VWX 707", "classTitle": "Cybersecurity"},
      {"className": "LMN 212", "classTitle": "Human-Computer Interaction"},
      {"className": "QWE 636", "classTitle": "Information Systems"},
      {"className": "ASD 999", "classTitle": "Digital Marketing"},
      {"className": "FGH 777", "classTitle": "Mobile Application Development"},
      {"className": "UIO 404", "classTitle": "Computer Graphics"},
      {"className": "TYU 303", "classTitle": "Operating Systems"},
      {"className": "HJK 555", "classTitle": "Software Testing"},
      {"className": "ZXC 888", "classTitle": "Cloud Computing"},
      {"className": "WER 747", "classTitle": "Big Data Analytics"},
      {"className": "CVB 989", "classTitle": "Computer Vision"},
      {"className": "BNM 656", "classTitle": "Game Development"},
      {"className": "OPQ 474", "classTitle": "Information Security"},
      {"className": "RTY 363", "classTitle": "Embedded Systems"},
      {"className": "GHJ 838", "classTitle": "Quantum Computing"},
      {"className": "DFG 676", "classTitle": "Blockchain Technology"},
      {"className": "XCV 121", "classTitle": "Robotics"},
      {"className": "BNV 454", "classTitle": "Natural Language Processing"},
      {"className": "QAZ 989", "classTitle": "Data Mining"},
      {"className": "WSX 878", "classTitle": "Computer Architecture"},
    ];

    List<ClassModel> data = [];
    final faker = Faker();
    for (int i = 0; i < classInfo.length; i++) {
      data.add(ClassModel(
        id: faker.guid.guid(),
        name: classInfo[i]['classTitle']!,
        code: classInfo[i]['className']!,
        lecturerId: 'Lecturer $i',
        lecturerName: faker.person.name(),
        color: faker.randomGenerator.element(colorsList),
        createdAt: faker.date.dateTime().millisecondsSinceEpoch,
      ));
    }
    return data;
  }
}
