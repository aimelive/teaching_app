import 'package:cloud_firestore/cloud_firestore.dart';
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
}
