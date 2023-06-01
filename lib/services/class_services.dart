import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';

class ClassServices {
  final collection = Collection.classes;

  Future<dynamic> addLessonPicture(String classId, String imgUrl) async {
    try {
      final classRef = collection.doc(classId);
      await classRef.update({
        'images': FieldValue.arrayUnion([imgUrl])
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future<School?> getSchool(String id) async {
    try {
      final result = await Collection.school.doc(id).get();
      final data = result.data()!;
      return School.fromJson(data);
    } catch (e) {
      return null;
    }
  }
  Future<TeacherClass?> getClass(String id) async {
    try {
      final result = await Collection.classes.doc(id).get();
      final data = result.data()!;
      return TeacherClass.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
