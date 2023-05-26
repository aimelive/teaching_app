import 'package:cloud_firestore/cloud_firestore.dart';

class ClassServices {
  final collection = FirebaseFirestore.instance.collection('classes');

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
