import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_model.dart';
import 'package:rxdart/rxdart.dart';

class AttendanceServices {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

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

  static String getId() {
    return firestore.collection('attendance').doc().id;
  }

  static Future<(bool,String)>saveQrCode(String id, Uint8List capturedImage)async {
    try {
      //save image to storage
      var ref = storage.ref('attendance').child('$id.png');
       await ref.putData(
          capturedImage, SettableMetadata(contentType: 'image/jpeg'));
          var url = await ref.getDownloadURL();
      return (true,url);
    } catch (e) {
      return (false,e.toString());
    }
  }

  static Future<(bool,String)>startAttendance({required AttendanceModel attendance})async {
    try {
      //save attendance to firestore
      await firestore.collection('attendance').doc(attendance.id).set(attendance.toMap());
      return (true,'Attendance started successfully');
    } catch (e) {
      return (false,e.toString());
    }
  }
}
