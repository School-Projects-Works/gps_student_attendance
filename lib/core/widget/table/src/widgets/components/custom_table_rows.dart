import 'package:flutter/material.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import '../../../data/models/custom_table_columns_model.dart';
import '../../../data/models/custom_table_rows_model.dart';

class CustomTableRows<TResult extends Object> extends StatelessWidget {
  CustomTableRows({
    super.key,
    required this.columns,
    required this.rows,
    this.rowsSelectable = false,
    this.isLoading = false,
  });
  final List<CustomTableColumn<TResult>> columns;
  final bool rowsSelectable;
  final bool isLoading;
  final List<CustomTableRow<TResult>> rows;
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
     var styles = CustomStyles(context: context);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isLoading ? .3 : 1,
      child: DefaultTextStyle(
          overflow: TextOverflow.ellipsis,
          style: styles.textStyle(
            desktop: 14,
            mobile: 14,
            tablet: 14,
            fontWeight: FontWeight.w400,
            
          ),
          child: rows.isEmpty
              ? Center(
                  child: Text('No Data Found',
                      style: Theme.of(context).textTheme.bodyMedium),
                )
              : _build(context, rows)),
    );
  }

  Widget _build(BuildContext context, List<CustomTableRow<TResult>> rows) {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: [
        ...rows.map((row) {
          return row.buildCell(row.item, row.index, context,
              rowsSelectable: rowsSelectable, columns: columns);
        })
      ],
    );
  }
}
