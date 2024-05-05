import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';

class ClassServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Future<(bool, String)> createClass(ClassModel data) async {
    try {
      // Create a class
      CollectionReference coll = firestore.collection('classes');
      await coll.add(data.toMap());
      return (true, 'Class created');
    } catch (e) {
      return (false, e.toString());
    }
  }

  static Future<void> updateClass(ClassModel classModel) async {
    // Update a class
    var data = classModel.toMap();
    await firestore.collection('classes').doc(classModel.id).update(data);
  }

  static Future<void> deleteClass() async {
    // Delete a class
  }

  static Future<void> getClass() async {
    // Get a class
  }

  static Future<List<ClassModel>> getClasses() async {
    // Get all classes
    var data = await firestore.collection('classes').get();
    var listOfData =
        data.docs.map((e) => ClassModel.fromMap(e.data())).toList();
    return listOfData;
  }
}
