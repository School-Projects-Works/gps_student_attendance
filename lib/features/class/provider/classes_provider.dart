import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/services/class_services.dart';

final classesStreamProvider =
    StreamProvider.autoDispose<List<ClassModel>>((ref) async* {
  final classes = await ClassServices.getClasses();
  ref.read(classProvider.notifier).setClasses(classes);
  yield classes;
  //yield [];
});

final classProvider = StateNotifierProvider<ClassProvider, List<ClassModel>>(
    (ref) => ClassProvider());

class ClassProvider extends StateNotifier<List<ClassModel>> {
  ClassProvider() : super([]);

  void setClasses(List<ClassModel> classes) {
    state = classes;
  }

  void addClass(ClassModel classModel) {
    state = [...state, classModel];
  }

  void updateClass(ClassModel classModel) {
    state = state.map((e) => e.id == classModel.id ? classModel : e).toList();
  }

  void deleteClass(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}
