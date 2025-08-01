import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:gps_student_attendance/core/widget/custom_button.dart';
import 'package:gps_student_attendance/utils/styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

class QRWidget extends StatefulWidget {
  const QRWidget({super.key, required this.id});
  final String id;

  @override
  _QRWidgetState createState() => _QRWidgetState();
}

class _QRWidgetState extends State<QRWidget> {
  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              width: 500,
              height: 500,
              child: QrImageView(
                data: widget.id,
                version: QrVersions.auto,
                padding: const EdgeInsets.all(30),
                size: 400.0,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    text: 'Close',
                    color: secondaryColor,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                const SizedBox(width: 5),
                CustomButton(
                    text: 'Export',
                    color: primaryColor,
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      generatePDF();
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> generatePDF() async {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.Container(
              color: PdfColor.fromInt(Colors.white.value),
              child: pw.BarcodeWidget(
                width: 500,
                height: 500,
                backgroundColor: PdfColor.fromInt(Colors.white.value),
                margin: const pw.EdgeInsets.all(30),
                padding: const pw.EdgeInsets.all(20),
                data: widget.id,
                barcode: pw.Barcode.qrCode(),
                color: PdfColor.fromInt(Colors.black.value),
              ),
            ),
            pw.Text(
              'Scan this QR code to mark attendance',
              style: pw.TextStyle(
                fontSize: 20,
                font: pw.Font.courier(),
                fontBold: pw.Font.courierBold(),
                color: PdfColor.fromInt(Colors.black.value),
              ),
            ),
          ]));
        },
      ),
    );
    final file = await pdf.save();
    await FileSaver.instance.saveFile(
        name: widget.id, fileExtension: 'pdf', mimeType: MimeType.pdf, bytes: file);
  }
}
