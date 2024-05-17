import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:gps_student_attendance/core/functions/time_functions.dart';
import 'dart:html' as html;
import 'package:gps_student_attendance/features/attendance/data/attendance_students_model.dart';
import 'package:path_provider/path_provider.dart';

class ExportServices{
  Future<String> exportToExcel(List<StudentsModel> data)async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  List<String> headers = ["Index number", "Full name", "Gender", "Email", "Phone", "Mode", "Time"];
  sheetObject.appendRow(headers.map((e) =>TextCellValue(e.toUpperCase()) ).toList());

  // Add the data rows
  for (var row in data) {
    List<String> rowData = [
      row.indexNumber,
      row.name,
      row.gender,
      row.email,
      row.phone,
      row.mode,
      TimeUtils.formatDateTime(row.time)
    ];
    sheetObject.appendRow(rowData.map((e) => TextCellValue(e)).toList());
  }

  // Save the Excel file
  var fileBytes = excel.save();

  if (kIsWeb) {
    // For web, create a Blob and trigger a download
    final blob = html.Blob([fileBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "data.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
    return "Exported successfully";
  } else {
    // For Android, you might need to use path_provider to get the directory and save the file there.
    // This part is dependent on your specific requirements and file storage permissions.
    // The following is a placeholder for actual Android file saving logic.
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.xlsx');
    await file.writeAsBytes(fileBytes!, flush: true);
    return "Exported successfully";
  }
}

}