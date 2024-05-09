import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';

class ClassServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Future<(bool, String)> createClass(ClassModel data) async {
    try {
      // Create a class
      CollectionReference coll = firestore.collection('classes');
      var id = coll.doc().id;
      data.id = id;
      //save if class code does not exist
      var existence = await coll.where('code', isEqualTo: data.code).get();
      if (existence.docs.isNotEmpty) {
        return (false, 'Class code exists');
      }

      await coll.doc(data.id).set(data.toMap());
      return (true, 'Class created successfully');
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

  static Stream<QuerySnapshot<Map<String,dynamic>>> getClasses(String query) {
    // Get all classes
    if(query.isEmpty||query.toLowerCase()=='all') {
      return firestore.collection('classes').snapshots();
    }else{
      return firestore.collection('classes').where('lecturerId',isEqualTo: query).snapshots();
    }
  }

  // static Future<(bool, String)> checkClassCode(String code) async {
  //   // Check if class code exists
  //   try {
  //     var data = await firestore
  //         .collection('classes')
  //         .where('code', isEqualTo: code)
  //         .get();
  //     //var data = await firestore.collection('classes').get();
  //     // var foundData = data.docs.where((element) => element.data()['code'] == code).toList();
  //     if (data.docs.isNotEmpty) {
  //       return (true, 'Class code exists');
  //     } else {
  //       return (false, 'Class code does not exist');
  //     }
  //   } catch (e) {
  //     return (false, e.toString());
  //   }
  // }
}
