import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/controllers/teacher_class.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherClassesProvider extends StatefulWidget {
  const TeacherClassesProvider({
    super.key,
    required this.child,
    required this.schools,
  });
  final Widget child;
  final List<String> schools;

  @override
  State<TeacherClassesProvider> createState() => _TeacherClassesProviderState();
}

class _TeacherClassesProviderState extends State<TeacherClassesProvider> {
  final _authState = Get.find<AuthState>();
  final _classesState = Get.put(TeacherClassesState());
  final _appUtils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('classes')
            // .where('schoolId', isEqualTo: "wRUop49RYfKUevrXkFcL"
            //     // whereIn: widget.schools.isEmpty ? ["no-school"] : widget.schools,
            //     )
            .snapshots(),
        builder: (context, snapshot) {
          bool hasError = snapshot.hasError;
          bool loading = snapshot.connectionState == ConnectionState.waiting;
          bool done = snapshot.connectionState == ConnectionState.active;

          if (hasError) {
            _classesState.error.value = snapshot.error.toString();
          }
          if (loading) {
            _classesState.isLoading.value = true;
          } else if (done) {
            _classesState.isLoading.value = false;
          }
          bool finished = done && !loading && !hasError;

          if (finished && snapshot.data != null && mounted) {
            _classesState.error.value = '';
            _appUtils.mapClassesToState(
              snapshot.data!.docs,
              _classesState,
              context,
              _authState.user.value?.id,
            );
          }
          return widget.child;
        });
  }
}
