import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:flutter/material.dart';

class SingleSchoolProvider extends StatefulWidget {
  const SingleSchoolProvider({
    super.key,
    required this.onError,
    required this.loading,
    required this.onSuccess,
    required this.schoolId,
  });
  final String schoolId;
  final Widget loading;
  final Widget Function(String error) onError;
  final Widget Function(School school) onSuccess;

  @override
  State<SingleSchoolProvider> createState() => _SingleSchoolProviderState();
}

class _SingleSchoolProviderState extends State<SingleSchoolProvider> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('schools')
            .doc(widget.schoolId)
            .snapshots(),
        builder: (context, snapshot) {
          bool hasError = snapshot.hasError;
          bool loading = snapshot.connectionState == ConnectionState.waiting;
          bool done = snapshot.connectionState == ConnectionState.active;

          if (hasError) {
            return widget.onError(snapshot.error.toString());
          }
          if (loading) {
            return widget.loading;
          }
          bool finished = done && !loading && !hasError;

          if (finished && snapshot.data != null && mounted) {
            try {
              if (snapshot.data == null || snapshot.data?.data() == null) {
                throw Exception("School not found!");
              }
              return widget.onSuccess(
                School.fromJson(snapshot.data!.data()!),
              );
            } catch (e) {
              return widget.onError(
                "Oops! We couldn't find school your are looking for. $e",
              );
            }
          }
          return const Text(
            "We couldn't able to retrieve what you are looking for.",
          );
        });
  }
}
