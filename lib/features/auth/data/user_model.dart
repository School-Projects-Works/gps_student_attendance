import 'dart:convert';

import 'package:flutter/widgets.dart';

class Users {
  String? id;
  String? userType;
  String? email;
  String? password;
  String? gender;
  String? prefix;
  String? name;
  String? phone;
  String? indexNumber;
  String? department;
  String? program;
  String? level;
  String? profileImage;
  int? createdAt;
  Users({
    this.id,
    this.userType,
    this.email,
    this.password,
    this.gender,
    this.prefix,
    this.name,
    this.phone,
    this.indexNumber,
    this.department,
    this.program,
    this.level,
    this.profileImage,
    this.createdAt,
  });

  Users copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? userType,
    ValueGetter<String?>? email,
    ValueGetter<String?>? password,
    ValueGetter<String?>? gender,
    ValueGetter<String?>? prefix,
    ValueGetter<String?>? name,
    ValueGetter<String?>? phone,
    ValueGetter<String?>? indexNumber,
    ValueGetter<String?>? department,
    ValueGetter<String?>? program,
    ValueGetter<String?>? level,
    ValueGetter<String?>? profileImage,
    ValueGetter<int?>? createdAt,
  }) {
    return Users(
      id: id != null ? id() : this.id,
      userType: userType != null ? userType() : this.userType,
      email: email != null ? email() : this.email,
      password: password != null ? password() : this.password,
      gender: gender != null ? gender() : this.gender,
      prefix: prefix != null ? prefix() : this.prefix,
      name: name != null ? name() : this.name,
      phone: phone != null ? phone() : this.phone,
      indexNumber: indexNumber != null ? indexNumber() : this.indexNumber,
      department: department != null ? department() : this.department,
      program: program != null ? program() : this.program,
      level: level != null ? level() : this.level,
      profileImage: profileImage != null ? profileImage() : this.profileImage,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userType': userType,
      'email': email,
      'password': password,
      'gender': gender,
      'prefix': prefix,
      'name': name,
      'phone': phone,
      'indexNumber': indexNumber,
      'department': department,
      'program': program,
      'level': level,
      'profileImage': profileImage,
      'createdAt': createdAt,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'],
      userType: map['userType'],
      email: map['email'],
      password: map['password'],
      gender: map['gender'],
      prefix: map['prefix'],
      name: map['name'],
      phone: map['phone'],
      indexNumber: map['indexNumber'],
      department: map['department'],
      program: map['program'],
      level: map['level'],
      profileImage: map['profileImage'],
      createdAt: map['createdAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Users(id: $id, userType: $userType, email: $email, password: $password, gender: $gender, prefix: $prefix, name: $name, phone: $phone, indexNumber: $indexNumber, department: $department, program: $program, level: $level, profileImage: $profileImage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Users &&
      other.id == id &&
      other.userType == userType &&
      other.email == email &&
      other.password == password &&
      other.gender == gender &&
      other.prefix == prefix &&
      other.name == name &&
      other.phone == phone &&
      other.indexNumber == indexNumber &&
      other.department == department &&
      other.program == program &&
      other.level == level &&
      other.profileImage == profileImage &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userType.hashCode ^
      email.hashCode ^
      password.hashCode ^
      gender.hashCode ^
      prefix.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      indexNumber.hashCode ^
      department.hashCode ^
      program.hashCode ^
      level.hashCode ^
      profileImage.hashCode ^
      createdAt.hashCode;
  }
}
