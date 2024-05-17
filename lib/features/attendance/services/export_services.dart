import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:gps_student_attendance/core/functions/time_functions.dart';
import 'package:gps_student_attendance/features/attendance/data/attendance_students_model.dart';


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
    // Use file_saver to save the file
    String fileName = "data.xlsx";
    MimeType mimeType = MimeType.microsoftExcel;

    if (kIsWeb) {
      // Save file for web
      FileSaver.instance.saveFile(
        name: fileName,
        mimeType: mimeType,
        bytes: fileBytes as Uint8List,
      );
    } else {
      // Save file for Android or other platforms
      FileSaver.instance.saveFile(
        name: fileName,
        mimeType: mimeType,
        bytes: fileBytes as Uint8List,
      );
    }
    return fileName;
  }

}