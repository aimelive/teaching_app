import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/controllers/school.dart';
import 'package:e_connect_mobile/data/providers/classes_provider.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchoolsProvider extends StatefulWidget {
  const SchoolsProvider({super.key, required this.child});
  final Widget child;

  @override
  State<SchoolsProvider> createState() => _SchoolsProviderState();
}

class _SchoolsProviderState extends State<SchoolsProvider> {
  final _authState = Get.find<AuthState>();
  final _schoolState = Get.put(SchoolsState());
  final _appUtils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('schools')
            .where('teachers', arrayContains: _authState.user.value?.id)
            .snapshots(),
        builder: (context, snapshot) {
          bool hasError = snapshot.hasError;
          bool loading = snapshot.connectionState == ConnectionState.waiting;
          bool done = snapshot.connectionState == ConnectionState.active;

          if (hasError) {
            _schoolState.error.value = snapshot.error.toString();
          }
          if (loading) {
            _schoolState.isLoading.value = true;
          } else if (done) {
            _schoolState.isLoading.value = false;
          }
          bool finished = done && !loading && !hasError;

          if (finished && snapshot.data != null && mounted) {
            _schoolState.error.value = '';
            _appUtils.mapSchoolsToState(
              snapshot.data!.docs,
              _schoolState,
              context,
              _authState.user.value?.id,
            );
          }
          return TeacherClassesProvider(schools: [], child: widget.child);
        });
  }
}
