import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/helpers/responsive_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPagination extends StatefulWidget {
  final int itemsPerPage, totalItems;
  final Function(int) onPageChanged;

  const CustomPagination({super.key, this.itemsPerPage = kItemsPerPage, required this.totalItems, required this.onPageChanged});

  @override
  State<CustomPagination> createState() => _CustomPaginationState();
}

class _CustomPaginationState extends State<CustomPagination> {
  int currentPage = 1;
  int get totalPages => widget.totalItems == 0 ? 1 : (widget.totalItems / widget.itemsPerPage).ceil();

  List<dynamic> _getPages() {
    if (widget.totalItems == 0) return [1];

    if (context.isMobile) {
      final end = (currentPage + 1).clamp(1, totalPages);
      final adjustedStart = (end - 2).clamp(1, totalPages);
      final adjustedEnd = (adjustedStart + 2).clamp(1, totalPages);

      return List.generate(adjustedEnd - adjustedStart + 1, (i) => adjustedStart + i);
    }

    List<dynamic> pages = [];

    if (totalPages <= 5) {
      pages = List.generate(totalPages, (index) => index + 1);
    } else {
      if (currentPage <= 3) {
        pages = [1, 2, 3, 4, "...", totalPages];
      } else if (currentPage >= totalPages - 2) {
        pages = [1, "...", totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
      } else {
        pages = [1, "...", currentPage - 1, currentPage, currentPage + 1, "...", totalPages];
      }
    }

    return pages;
  }

  void _navigate(int page) {
    if (page >= 1 && page <= totalPages) {
      setState(() => currentPage = page);

      widget.onPageChanged(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = widget.totalItems == 0;
    final pages = _getPages();
    final startIndex = isEmpty ? 0 : ((currentPage - 1) * widget.itemsPerPage) + 1;
    final endIndex = isEmpty ? 0 : (startIndex + widget.itemsPerPage - 1).clamp(1, widget.totalItems);

    return Column(
      spacing: 16.0,
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4.0,
            children: <Widget>[
              CustomPaginationButton(
                onTap: currentPage > 1 ? () => _navigate(currentPage - 1) : null,
                child: Icon(Icons.chevron_left_rounded, color: Theme.of(context).colorScheme.primary),
              ),
              ...pages.map((page) {
                if (page is int) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: CustomPaginationButton(
                      isSelected: page == currentPage,
                      onTap: () => _navigate(page),
                      child: Text(
                        page.toString(),
                        style: TextStyle(
                          color: page == currentPage ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(child: Text("...")),
                  );
                }
              }),
              CustomPaginationButton(
                onTap: currentPage < totalPages ? () => _navigate(currentPage + 1) : null,
                child: Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
        CustomText(
          Globalization.msgShowingEntries.trParams({
            "start": startIndex.toString(),
            "end": endIndex.toString(),
            "total": widget.totalItems.toString(),
          }),
          fontSize: 12.0,
        ),
      ],
    );
  }
}
