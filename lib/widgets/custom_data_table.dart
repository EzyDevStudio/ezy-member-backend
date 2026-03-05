import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef ValueExtractor<T> = String Function(T model);

class CustomDataTable<T> extends StatefulWidget {
  final List<int> ratios;
  final List<String> headers;
  final List<T> models;
  final List<ValueExtractor<T>> variables;
  final List<Widget> Function(T model)? actions;
  final Widget Function(T model)? pending;

  const CustomDataTable({
    super.key,
    required this.ratios,
    required this.headers,
    required this.models,
    required this.variables,
    this.actions,
    this.pending,
  });

  @override
  State<CustomDataTable<T>> createState() => _CustomDataTableState<T>();
}

class _CustomDataTableState<T> extends State<CustomDataTable<T>> {
  late List<T> _displayModels;

  int? _sortColumnIndex;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();

    _displayModels = List.from(widget.models);
  }

  void _sort(int index) => setState(() {
    if (_sortColumnIndex == index) {
      _isAscending = !_isAscending;
    } else {
      _sortColumnIndex = index;
      _isAscending = true;
    }

    final extractor = widget.variables[index];

    _displayModels.sort((a, b) {
      final result = extractor(a).compareTo(extractor(b));
      return _isAscending ? result : -result;
    });
  });

  @override
  void didUpdateWidget(covariant CustomDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.models != widget.models) {
      _displayModels = List.from(widget.models);
      _sortColumnIndex = null;
      _isAscending = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allRatios = [...widget.ratios, if (widget.pending != null) 1, if (widget.actions != null) 1];

    return Expanded(
      child: Column(
        children: <Widget>[
          Table(
            columnWidths: {for (int i = 0; i < allRatios.length; i++) i: FlexColumnWidth(allRatios[i].toDouble())},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                children: <Widget>[
                  ...widget.headers.asMap().entries.map(
                    (entry) => InkWell(
                      onTap: () => _sort(entry.key),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: CustomText(
                                entry.value,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                maxLines: 2,
                              ),
                            ),
                            if (_sortColumnIndex == entry.key)
                              Icon(
                                _isAscending ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20.0,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (widget.pending != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: CustomText(
                        Globalization.pending.tr,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (widget.actions != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: CustomText(
                        Globalization.action.tr,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Table(
                  columnWidths: {for (int i = 0; i < allRatios.length; i++) i: FlexColumnWidth(allRatios[i].toDouble())},
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    ..._displayModels.asMap().entries.map(
                      (entry) => TableRow(
                        decoration: BoxDecoration(
                          color: entry.key.isEven ? Colors.white : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
                        ),
                        children: <Widget>[
                          ...widget.variables.map(
                            (extractor) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                              child: SizedBox(width: double.infinity, child: CustomText(extractor(entry.value), fontSize: 12.0, maxLines: 2)),
                            ),
                          ),
                          if (widget.pending != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(runSpacing: 4.0, spacing: 4.0, children: <Widget>[widget.pending!(entry.value)]),
                            ),
                          if (widget.actions != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(runSpacing: 4.0, spacing: 4.0, children: widget.actions!(entry.value)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
