import 'dart:convert';
import 'package:flutter/foundation.dart';

class AttendanceModel {
  String? id;
  String? classId;
  String? className;
  String? classCode;
  String? lecturerId;
  String? lecturerName;
  int? date;
  String? startTime;
  String? endTime;
  double? lat;
  double? long;
  String? status;
  List<String> studentIds;
  List<Map<String, dynamic>> students;
  int? createdAt;
  AttendanceModel({
    this.id,
    this.classId,
    this.className,
    this.classCode,
    this.lecturerId,
    this.lecturerName,
    this.date,
    this.startTime,
    this.endTime,
    this.lat,
    this.long,
    this.status,
    this.studentIds=const [],
    this.students = const [],
    this.createdAt,
  });

  AttendanceModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? classId,
    ValueGetter<String?>? className,
    ValueGetter<String?>? classCode,
    ValueGetter<String?>? lecturerId,
    ValueGetter<String?>? lecturerName,
    ValueGetter<int?>? date,
    ValueGetter<String?>? startTime,
    ValueGetter<String?>? endTime,
    ValueGetter<double?>? lat,
    ValueGetter<double?>? long,
    ValueGetter<String?>? status,
    List<String>? studentIds,
    List<Map<String, dynamic>>? students,
    ValueGetter<int?>? createdAt,
  }) {
    return AttendanceModel(
      id: id != null ? id() : this.id,
      classId: classId != null ? classId() : this.classId,
      className: className != null ? className() : this.className,
      classCode: classCode != null ? classCode() : this.classCode,
      lecturerId: lecturerId != null ? lecturerId() : this.lecturerId,
      lecturerName: lecturerName != null ? lecturerName() : this.lecturerName,
      date: date != null ? date() : this.date,
      startTime: startTime != null ? startTime() : this.startTime,
      endTime: endTime != null ? endTime() : this.endTime,
      lat: lat != null ? lat() : this.lat,
      long: long != null ? long() : this.long,
      status: status != null ? status() : this.status,
      studentIds: studentIds ?? this.studentIds,
      students: students ?? this.students,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classId': classId,
      'className': className,
      'classCode': classCode,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'lat': lat,
      'long': long,
      'status': status,
      'studentIds': studentIds,
      'students': students,
      'createdAt': createdAt,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      classId: map['classId'],
      className: map['className'],
      classCode: map['classCode'],
      lecturerId: map['lecturerId'],
      lecturerName: map['lecturerName'],
      date: map['date']?.toInt(),
      startTime: map['startTime'],
      endTime: map['endTime'],
      lat: map['lat']?.toDouble(),
      long: map['long']?.toDouble(),
      status: map['status'],
      studentIds: List<String>.from(map['studentIds']),
      students: List<Map<String, dynamic>>.from(map['students']?.map((x) => Map<String, dynamic>.from(x))),
      createdAt: map['createdAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AttendanceModel(id: $id, classId: $classId, className: $className, classCode: $classCode, lecturerId: $lecturerId, lecturerName: $lecturerName, date: $date, startTime: $startTime, endTime: $endTime, lat: $lat, long: $long, status: $status, studentIds: $studentIds, students: $students, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AttendanceModel &&
      other.id == id &&
      other.classId == classId &&
      other.className == className &&
      other.classCode == classCode &&
      other.lecturerId == lecturerId &&
      other.lecturerName == lecturerName &&
      other.date == date &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.lat == lat &&
      other.long == long &&
      other.status == status &&
      listEquals(other.studentIds, studentIds) &&
      listEquals(other.students, students) &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      classId.hashCode ^
      className.hashCode ^
      classCode.hashCode ^
      lecturerId.hashCode ^
      lecturerName.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      lat.hashCode ^
      long.hashCode ^
      status.hashCode ^
      studentIds.hashCode ^
      students.hashCode ^
      createdAt.hashCode;
  }
}
