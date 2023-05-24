import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:get/get.dart';

class TeacherClassesState extends GetxController {
  //Values
  RxList<TeacherClass> classes = RxList<TeacherClass>([]);

  //State
  RxBool isLoading = RxBool(false);
  RxString error = RxString('');
}
