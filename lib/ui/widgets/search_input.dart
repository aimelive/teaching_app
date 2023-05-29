import 'package:e_connect_mobile/data/providers/stream_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class SearchInput<T> extends StatelessWidget {
  const SearchInput({
    super.key,
    required this.delegate,
    required this.onClosed,
    this.isHomeSearchbarForClasses,
  });

  final MyCustomSearchDelegate<T> delegate;
  final void Function(T? data) onClosed;
  final bool? isHomeSearchbarForClasses;

  void _onTap(BuildContext context) async {
    final result = await showSearch<T?>(
      context: context,
      delegate: delegate,
    );
    onClosed(result);
  }

  @override
  Widget build(BuildContext context) {
    if (isHomeSearchbarForClasses == true) {
      return HomeSearchbarForClasses(
        onTap: () => _onTap(context),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: secondaryColor.withOpacity(0.1),
      ),
      child: GestureDetector(
        onTap: () => _onTap(context),
        child: Theme(
          data: ThemeData(
            disabledColor: Colors.grey.shade600,
          ),
          child: TextFormField(
            cursorColor: secondaryColor,
            enabled: false,
            decoration: InputDecoration(
              isDense: true,

              prefixIconConstraints: BoxConstraints(
                maxHeight: 22.h,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  Icons.search,
                  size: 25.sp,
                ),
              ),
              // hintStyle: const TextStyle(color: primaryColor),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.h,
              ),
              hintText: "Search",
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class HomeSearchbarForClasses extends StatelessWidget {
  const HomeSearchbarForClasses({
    super.key,
    required this.onTap,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 4.r,
        left: 20.w,
        top: 4.r,
        bottom: 4.r,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: secondaryColor.withOpacity(0.1),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Theme(
          data: ThemeData(
            disabledColor: Colors.grey.shade600,
          ),
          child: TextField(
            cursorColor: secondaryColor,
            enabled: false,
            decoration: InputDecoration(
              isDense: true,
              constraints: BoxConstraints(maxHeight: 40.h),
              suffixIcon: CircleAvatar(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
                child: Icon(
                  Icons.search,
                  size: 25.sp,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.h,
              ),
              hintText: "Search",
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomSearchDelegate<T> extends SearchDelegate<T?> {
  final StreamListProvider<T> Function(
    String query,
    void Function(BuildContext context) showResults,
  ) onSearchingSuggestionsBuilder;

  final String hintText;

  @override
  MyCustomSearchDelegate({
    required this.onSearchingSuggestionsBuilder,
    required this.hintText,
  });

  @override
  String get searchFieldLabel => hintText;

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(
          Icons.arrow_back,
        ),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return onSearchingSuggestionsBuilder(query, showResults);
  }
}
