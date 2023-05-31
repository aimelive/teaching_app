import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamListProvider<T> extends StatefulWidget {
  const StreamListProvider({
    super.key,
    required this.query,
    required this.fromJson,
    required this.loading,
    required this.onError,
    required this.onSuccess,
  });
  final Query<Map<String, dynamic>> query;
  final Widget loading;
  final Widget Function(String error) onError;
  final Widget Function(List<T> data) onSuccess;
  final T Function(Map<String, dynamic> json, String id) fromJson;

  @override
  State<StreamListProvider<T>> createState() => _StreamListProviderState<T>();
}

class _StreamListProviderState<T> extends State<StreamListProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.query.snapshots(),
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
              List<T> items = [];
              for (DocumentSnapshot document in snapshot.data!.docs) {
                try {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  items.add(widget.fromJson(data, document.id));
                } catch (e) {
                  continue;
                }
              }
              return widget.onSuccess(items);
            } catch (e) {
              return widget.onError(
                "Oops! We couldn't find what your are looking for. $e",
              );
            }
          }
          return const Text(
            "We couldn't able to retrieve what you are looking for.",
          );
        });
  }
}
