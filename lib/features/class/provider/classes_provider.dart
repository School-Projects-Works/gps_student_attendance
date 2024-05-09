import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_student_attendance/core/widget/custom_dialog.dart';
import 'package:gps_student_attendance/features/class/data/class_model.dart';
import 'package:gps_student_attendance/features/class/services/class_services.dart';
import '../../auth/data/user_model.dart';

final classesStreamProvider =
    StreamProvider.autoDispose.family<List<ClassModel>,String>((ref,query) async* {
  final classesSnap = ClassServices.getClasses(query);
  await for (final classes in classesSnap) {
    var list = classes.docs.map((e) => ClassModel.fromMap(e.data())).toList();
    //order createdAt
    list.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    ref.read(classProvider.notifier).setClasses(list);
    yield list;
  }
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

final searchProvider = StateProvider<String>((ref) => '');
final filteredClassList = Provider.autoDispose<List<ClassModel>>((ref) {
  final classes = ref.watch(classProvider);
  final search = ref.watch(searchProvider);
  if (search.isEmpty) return [];
  return classes
      .where((element) =>
          element.name.toLowerCase().contains(search.toLowerCase()) ||
          element.code.toLowerCase().contains(search.toLowerCase()))
      .toList();
});

final joinClassProvider =
    StateNotifierProvider<JoinClass, void>((ref) => JoinClass());

class JoinClass extends StateNotifier<void> {
  JoinClass() : super(null);

  void joinClass(
      {required ClassModel classModel,
      required Users users,
      required WidgetRef ref}) async {
    CustomDialog.showLoading(message: 'Joining Class.....');
    //check if user is already in class
    if (classModel.studentIds.contains(users.id)) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'You are already in this class');
      return;
    }
    //check if class  department is all or equal to user department
    if (classModel.availableToDepartment != 'All' &&
        classModel.availableToDepartment != users.department) {
           CustomDialog.dismiss();
      CustomDialog.showError(
          message: 'This class is not available to your department');
      return;
    }
    //check if class level is all or equal to user level
    if (classModel.availableToLevel != 'All' &&
        classModel.availableToLevel != users.level) {
           CustomDialog.dismiss();
      CustomDialog.showError(
          message: 'This class is not available to your level');
      return;
    }
    //add user id to class studentIds
    classModel.studentIds.add(users.id!);
    //check if class type is private
    if (classModel.classType!.toLowerCase() != 'public') {
      await ClassServices.updateClass(classModel);
      //check if user id is equal to lecturer id
      CustomDialog.showSuccess(message: 'You have successfully joined class, Pending approval from lecturer');
    }else{
      //add student map to class students 
      classModel.students.add(users.toMap());
      //update class
      await ClassServices.updateClass(classModel);
      CustomDialog.showSuccess(message: 'You have successfully joined class');
    }
  }
}
