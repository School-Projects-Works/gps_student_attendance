

class StudentsModel {
  String id;
  String indexNumber;
  String email;
  String phone;
  String gender;
  String name;
  String mode;  
  int time;


  StudentsModel({
    required this.id,
    required this.indexNumber,
    required this.email,
    required this.phone,
    required this.gender,
    required this.name,
    required this.mode,
    required this.time,
  });

  factory StudentsModel.fromJson(Map<String, dynamic> json) {
    return StudentsModel(
      id: json['id'],
      indexNumber: json['indexNumber'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      name: json['name'],
      mode: json['mode'],
      time: json['time'],
    );
}


}
 