import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';

import 'package:gps_student_attendance/core/constants/colors_list.dart';
import 'package:gps_student_attendance/core/constants/departments.dart';

class ClassModel {
  String id;
  String name;
  String code;
  String description;
  String? color;
  String? department;
  String lecturerId;
  String lecturerName;
  String? lecturerImage;
  List<String> availableTo;
  List<String> studentIds;
  String? classDay;
  String? status;
  int? createdAt;
  List<Map<String, dynamic>> students;
  ClassModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    this.color,
    this.department,
    required this.lecturerId,
    required this.lecturerName,
    this.lecturerImage,
    this.availableTo = const [],
    this.studentIds = const [],
    this.createdAt,
    this.students = const [],
  });

  ClassModel copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    ValueGetter<String?>? color,
    ValueGetter<String?>? department,
    String? lecturerId,
    String? lecturerName,
    ValueGetter<String?>? lecturerImage,
    List<String>? availableTo,
    List<String>? studentIds,
    ValueGetter<int?>? createdAt,
    List<Map<String, dynamic>>? students,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      color: color != null ? color() : this.color,
      department: department != null ? department() : this.department,
      lecturerId: lecturerId ?? this.lecturerId,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerImage:
          lecturerImage != null ? lecturerImage() : this.lecturerImage,
      availableTo: availableTo ?? this.availableTo,
      studentIds: studentIds ?? this.studentIds,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
      students: students ?? this.students,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'color': color,
      'department': department,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'lecturerImage': lecturerImage,
      'availableTo': availableTo,
      'studentIds': studentIds,
      'createdAt': createdAt,
      'students': students,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      description: map['description'] ?? '',
      color: map['color'],
      department: map['department'],
      lecturerId: map['lecturerId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerImage: map['lecturerImage'],
      availableTo: List<String>.from(map['availableTo']),
      studentIds: List<String>.from(map['studentIds']),
      createdAt: map['createdAt']?.toInt(),
      students: List<Map<String, dynamic>>.from(map['students']?.map((x) => x)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassModel.fromJson(String source) =>
      ClassModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassModel(id: $id, name: $name, code: $code, description: $description, color: $color, department: $department, lecturerId: $lecturerId, lecturerName: $lecturerName, lecturerImage: $lecturerImage, availableTo: $availableTo, studentIds: $studentIds, createdAt: $createdAt, students: $students)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassModel &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.description == description &&
        other.color == color &&
        other.department == department &&
        other.lecturerId == lecturerId &&
        other.lecturerName == lecturerName &&
        other.lecturerImage == lecturerImage &&
        listEquals(other.availableTo, availableTo) &&
        listEquals(other.studentIds, studentIds) &&
        other.createdAt == createdAt &&
        listEquals(other.students, students);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        description.hashCode ^
        color.hashCode ^
        department.hashCode ^
        lecturerId.hashCode ^
        lecturerName.hashCode ^
        lecturerImage.hashCode ^
        availableTo.hashCode ^
        studentIds.hashCode ^
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
          description: faker.lorem.sentence(),
          lecturerId: 'Lecturer $i',
          lecturerName: faker.person.name(),
          color: faker.randomGenerator.element(colorsList),
          availableTo: faker.randomGenerator.boolean()
              ? ['All']
              : faker.randomGenerator
                  .numbers(departmentList.length - 1, 2)
                  .map((e) => departmentList[e])
                  .toList(),
          createdAt: faker.date.dateTime().millisecondsSinceEpoch,
          department: faker.randomGenerator.element(departmentList)));
    }
    return data;
  }
}
