import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AttendanceServices {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get all attendance Stream
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAttendance() {
    // Get all attendance
    return firestore.collection('attendance').snapshots();
  }

  //get attendance by classId Stream
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAttendanceByClassId(
      String classId) {
    // Get all attendance
    return firestore
        .collection('attendance')
        .where('classId', isEqualTo: classId)
        .snapshots();
  }

  //get attendance by lecturerId Stream
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAttendanceByLecturerId(
      String lecturerId) {
    // Get all attendance
    return firestore
        .collection('attendance')
        .where('lecturerId', isEqualTo: lecturerId)
        .snapshots();
  }

  //get attendance where studentId is in the list
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAttendanceByStudentId(
      List<String> studentIds) {
    // Get all attendance
    return firestore
        .collection('attendance')
        .where('studentIds', arrayContainsAny: studentIds)
        .snapshots();
  }

  //get attendance of all the list of classIds
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAttendanceByClassIds(
      List<String> classIds) {
    //get attendance of each classId
    List<Stream<QuerySnapshot<Map<String, dynamic>>>?> streams = [];
    for (var classId in classIds) {
      streams.add(getAttendanceByClassId(classId));
    }
    return MergeStream([
      for (var stream in streams) stream!]);
  }
}
