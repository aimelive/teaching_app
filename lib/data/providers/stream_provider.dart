import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamProvider<T> extends StatefulWidget {
  const StreamProvider({
    super.key,
    required this.collectionId,
    required this.docId,
    required this.fromJson,
    required this.loading,
    required this.onError,
    required this.onSuccess,
  });
  final String collectionId;
  final String docId;
  final Widget loading;
  final Widget Function(String error) onError;
  final Widget Function(T data) onSuccess;
  final T Function(Map<String, dynamic> json) fromJson;

  @override
  State<StreamProvider<T>> createState() => _StreamProviderState<T>();
}

class _StreamProviderState<T> extends State<StreamProvider<T>> {
  String _replaceLastChar(String input) {
    if (input.isEmpty) {
      return input;
    }

    if (input.endsWith("s")) {
      return input.substring(0, input.length - 1);
    }

    return input;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(widget.collectionId)
            .doc(widget.docId)
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
                return widget.onError(
                    "${_replaceLastChar(widget.collectionId)} not found!");
              }
              return widget.onSuccess(widget.fromJson(snapshot.data!.data()!));
            } catch (e) {
              return widget.onError(
                "Oops! We couldn't find ${_replaceLastChar(widget.collectionId)} your are looking for. $e",
              );
            }
          }
          return const Text(
            "We couldn't able to retrieve what you are looking for.",
          );
        });
  }
}
