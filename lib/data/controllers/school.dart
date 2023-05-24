import 'package:e_connect_mobile/data/models/school.dart';
import 'package:get/get.dart';

class SchoolsState extends GetxController {
  //Values
  RxList<School> schools = RxList<School>([]);

  //State
  RxBool isLoading = RxBool(false);
  RxString error = RxString('');
}
