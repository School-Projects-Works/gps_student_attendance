import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:gps_student_attendance/core/constants/departments.dart';

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

  static List<Users> dummyList() {
    final List<Map<String, dynamic>> combinedList = [
      {
        "name": "Zoey Patel",
        "gender": "female",
        "phoneNumber": "123-456-7890",
        "prefix": "Ms."
      },
      {
        "name": "Elijah Bennett",
        "gender": "male",
        "phoneNumber": "234-567-8901",
        "prefix": "Mr."
      },
      {
        "name": "Maisie Walker",
        "gender": "female",
        "phoneNumber": "345-678-9012",
        "prefix": "Ms."
      },
      {
        "name": "Liam Hernandez",
        "gender": "male",
        "phoneNumber": "456-789-0123",
        "prefix": "Mr."
      },
      {
        "name": "Aurora Wright",
        "gender": "female",
        "phoneNumber": "567-890-1234",
        "prefix": "Ms."
      },
      {
        "name": "Muhammad Khan",
        "gender": "male",
        "phoneNumber": "678-901-2345",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Moore",
        "gender": "female",
        "phoneNumber": "789-012-3456",
        "prefix": "Ms."
      },
      {
        "name": "Ethan Nelson",
        "gender": "male",
        "phoneNumber": "890-123-4567",
        "prefix": "Mr."
      },
      {
        "name": "Penelope Garcia",
        "gender": "female",
        "phoneNumber": "901-234-5678",
        "prefix": "Ms."
      },
      {
        "name": "Caleb Ramirez",
        "gender": "male",
        "phoneNumber": "012-345-6789",
        "prefix": "Mr."
      },
      {
        "name": "Riley Thomas",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
      {
        "name": "Noah Mitchell",
        "gender": "male",
        "phoneNumber": "876-543-2109",
        "prefix": "Mr."
      },
      {
        "name": "Olivia Brown",
        "gender": "female",
        "phoneNumber": "765-432-1098",
        "prefix": "Ms."
      },
      {
        "name": "William Allen",
        "gender": "male",
        "phoneNumber": "654-321-0987",
        "prefix": "Mr."
      },
      {
        "name": "Luna Johnson",
        "gender": "female",
        "phoneNumber": "543-210-9876",
        "prefix": "Ms."
      },
      {
        "name": "Lucas Wilson",
        "gender": "male",
        "phoneNumber": "432-109-8765",
        "prefix": "Mr."
      },
      {
        "name": "Scarlett Garcia",
        "gender": "female",
        "phoneNumber": "321-098-7654",
        "prefix": "Ms."
      },
      {
        "name": "Benjamin Moore",
        "gender": "male",
        "phoneNumber": "210-987-6543",
        "prefix": "Mr."
      },
      {
        "name": "Charlotte Young",
        "gender": "female",
        "phoneNumber": "109-876-5432",
        "prefix": "Ms."
      },
      {
        "name": "Mason Clark",
        "gender": "male",
        "phoneNumber": "098-765-4321",
        "prefix": "Mr."
      },
      {
        "name": "Mia Garcia",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
      {
        "name": "Aiden Lewis",
        "gender": "male",
        "phoneNumber": "876-543-2109",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Miller",
        "gender": "female",
        "phoneNumber": "765-432-1098",
        "prefix": "Ms."
      },
      {
        "name": "Jackson King",
        "gender": "male",
        "phoneNumber": "654-321-0987",
        "prefix": "Mr."
      },
      {
        "name": "Avery Hernandez",
        "gender": "female",
        "phoneNumber": "543-210-9876",
        "prefix": "Ms."
      },
      {
        "name": "David Robinson",
        "gender": "male",
        "phoneNumber": "432-109-8765",
        "prefix": "Mr."
      },
      {
        "name": "Harper Lee",
        "gender": "female",
        "phoneNumber": "321-098-7654",
        "prefix": "Ms."
      },
      {
        "name": "Jayden Gonzalez",
        "gender": "male",
        "phoneNumber": "210-987-6543",
        "prefix": "Mr."
      },
      {
        "name": "Amelia Torres",
        "gender": "female",
        "phoneNumber": "109-876-5432",
        "prefix": "Ms."
      },
      {
        "name": "Logan Walker",
        "gender": "male",
        "phoneNumber": "098-765-4321",
        "prefix": "Mr."
      },
      {
        "name": "Eleanor Johnson",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
      {
        "name": "Michael Allen",
        "gender": "male",
        "phoneNumber": "876-543-2109",
        "prefix": "Mr."
      },
      {
        "name": "Stella Young",
        "gender": "female",
        "phoneNumber": "765-432-1098",
        "prefix": "Ms."
      },
      {
        "name": "Alexander Brown",
        "gender": "male",
        "phoneNumber": "654-321-0987",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Lopez",
        "gender": "female",
        "phoneNumber": "543-210-9876",
        "prefix": "Ms."
      },
      {
        "name": "Daniel Hernandez",
        "gender": "male",
        "phoneNumber": "432-109-8765",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Carter",
        "gender": "female",
        "phoneNumber": "321-098-7654",
        "prefix": "Ms."
      },
      {
        "name": "James Moore",
        "gender": "male",
        "phoneNumber": "210-987-6543",
        "prefix": "Mr."
      },
      {
        "name": "Sofia Garcia",
        "gender": "female",
        "phoneNumber": "109-876-5432",
        "prefix": "Ms."
      },
      {
        "name": "Matthew Davis",
        "gender": "male",
        "phoneNumber": "098-765-4321",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Robinson",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
      {
        "name": "Christopher Taylor",
        "gender": "male",
        "phoneNumber": "876-543-2109",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Thomas",
        "gender": "female",
        "phoneNumber": "765-432-1098",
        "prefix": "Ms."
      },
      {
        "name": "Andrew Anderson",
        "gender": "male",
        "phoneNumber": "654-321-0987",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Wilson",
        "gender": "female",
        "phoneNumber": "543-210-9876",
        "prefix": "Ms."
      },
      {
        "name": "Joseph Jackson",
        "gender": "male",
        "phoneNumber": "432-109-8765",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Campbell",
        "gender": "female",
        "phoneNumber": "321-098-7654",
        "prefix": "Ms."
      },
      {
        "name": "Mark Thomas",
        "gender": "male",
        "phoneNumber": "210-987-6543",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Walker",
        "gender": "female",
        "phoneNumber": "109-876-5432",
        "prefix": "Ms."
      },
      {
        "name": "Nicholas Miller",
        "gender": "male",
        "phoneNumber": "098-765-4321",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Wright",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
      {
        "name": "Kevin Garcia",
        "gender": "male",
        "phoneNumber": "876-543-2109",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Brown",
        "gender": "female",
        "phoneNumber": "765-432-1098",
        "prefix": "Ms."
      },
      {
        "name": "Ryan Hernandez",
        "gender": "male",
        "phoneNumber": "654-321-0987",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Young",
        "gender": "female",
        "phoneNumber": "543-210-9876",
        "prefix": "Ms."
      },
      {
        "name": "Joshua Moore",
        "gender": "male",
        "phoneNumber": "432-109-8765",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Allen",
        "gender": "female",
        "phoneNumber": "321-098-7654",
        "prefix": "Ms."
      },
      {
        "name": "Christian Ramirez",
        "gender": "male",
        "phoneNumber": "210-987-6543",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn King",
        "gender": "female",
        "phoneNumber": "109-876-5432",
        "prefix": "Ms."
      },
      {
        "name": "Daniel Williams",
        "gender": "male",
        "phoneNumber": "098-765-4321",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Lopez",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
      {
        "name": "Samuel Clark",
        "gender": "male",
        "phoneNumber": "876-543-2109",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Robinson",
        "gender": "female",
        "phoneNumber": "765-432-1098",
        "prefix": "Ms."
      },
      {
        "name": "David Jones",
        "gender": "male",
        "phoneNumber": "654-321-0987",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Hernandez",
        "gender": "female",
        "phoneNumber": "543-210-9876",
        "prefix": "Ms."
      },
      {
        "name": "Benjamin Garcia",
        "gender": "male",
        "phoneNumber": "432-109-8765",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Moore",
        "gender": "female",
        "phoneNumber": "321-098-7654",
        "prefix": "Ms."
      },
      {
        "name": "Michael Davis",
        "gender": "male",
        "phoneNumber": "210-987-6543",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Brown",
        "gender": "female",
        "phoneNumber": "109-876-5432",
        "prefix": "Ms."
      },
      {
        "name": "Christopher Miller",
        "gender": "male",
        "phoneNumber": "098-765-4321",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Robinson",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
      {
        "name": "Andrew Hernandez",
        "gender": "male",
        "phoneNumber": "876-543-2109",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Lopez",
        "gender": "female",
        "phoneNumber": "765-432-1098",
        "prefix": "Ms."
      },
      {
        "name": "Joseph Garcia",
        "gender": "male",
        "phoneNumber": "654-321-0987",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Moore",
        "gender": "female",
        "phoneNumber": "543-210-9876",
        "prefix": "Ms."
      },
      {
        "name": "Daniel Young",
        "gender": "male",
        "phoneNumber": "432-109-8765",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Robinson",
        "gender": "female",
        "phoneNumber": "321-098-7654",
        "prefix": "Ms."
      },
      {
        "name": "Benjamin Allen",
        "gender": "male",
        "phoneNumber": "210-987-6543",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn King",
        "gender": "female",
        "phoneNumber": "109-876-5432",
        "prefix": "Ms."
      },
      {
        "name": "David Walker",
        "gender": "male",
        "phoneNumber": "098-765-4321",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Hernandez",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
      {
        "name": "Michael Brown",
        "gender": "male",
        "phoneNumber": "876-543-2109",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Robinson",
        "gender": "female",
        "phoneNumber": "765-432-1098",
        "prefix": "Ms."
      },
      {
        "name": "Christopher Lopez",
        "gender": "male",
        "phoneNumber": "654-321-0987",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn King",
        "gender": "female",
        "phoneNumber": "543-210-9876",
        "prefix": "Ms."
      },
      {
        "name": "Andrew Moore",
        "gender": "male",
        "phoneNumber": "432-109-8765",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Hernandez",
        "gender": "female",
        "phoneNumber": "321-098-7654",
        "prefix": "Ms."
      },
      {
        "name": "Joseph Garcia",
        "gender": "male",
        "phoneNumber": "210-987-6543",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Allen",
        "gender": "female",
        "phoneNumber": "109-876-5432",
        "prefix": "Ms."
      },
      {
        "name": "David Robinson",
        "gender": "male",
        "phoneNumber": "098-765-4321",
        "prefix": "Mr."
      },
      {
        "name": "Evelyn Brown",
        "gender": "female",
        "phoneNumber": "987-654-3210",
        "prefix": "Ms."
      },
    ];
    List<Users> data = [];
    final _faker = Faker();
    for (int i = 0; i < combinedList.length; i++) {
      var usertype = i > 75 ? 'Lecturer' : 'Student';
      var prefix = i > 75 ? _faker.randomGenerator.element(['Dr.', 'Prof.']) : _faker.randomGenerator.element(['Mr.', 'Ms.']);
      data.add(Users(
          name: combinedList[i]['name'],
          id: _faker.guid.guid(),
          userType: usertype,
          password: _faker.internet.password(),
          email: _faker.internet.email(),
          createdAt: _faker.date.dateTime().millisecondsSinceEpoch,
          department: _faker.randomGenerator.element(departmentList),
          gender: combinedList[i]['gender'],
          //10 digit number 
          indexNumber: _faker.randomGenerator.numbers(9,10).toList().join(),
          phone: combinedList[i]['phoneNumber'],
          profileImage: _faker.image.image(),
          program: _faker.randomGenerator.element([
            'BSc Computer Science',
            'BSc Information Technology',
            'BSc Mathematics',
            'BSc Statistics'
          ]),
          level: _faker.randomGenerator
              .element(['100', '200', '300', '400', 'Graduate']),
          prefix: prefix));
    }
    return data;
  }
}
