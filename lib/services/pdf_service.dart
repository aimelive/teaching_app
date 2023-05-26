import 'dart:io';

import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfService {
  Future<File?> makePdf(
    String date,
    String teacherName,
    List<TeacherClass> classes,
  ) async {
    try {
      //Assets
      final imageLogo = await getLogo();
      //PDF
      final pdf = Document();
      pdf.addPage(
        Page(build: (context) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Attention to: $teacherName"),
                      Text("Date: $date"),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(imageLogo),
                  ),
                ],
              ),
              Table(
                border: TableBorder.all(color: PdfColors.black),
                children: classes
                    .map(
                      (trClass) => TableRow(
                        children: [
                          Expanded(child: Text(trClass.name), flex: 1),
                          Expanded(child: Text(trClass.schoolName), flex: 1),
                          Expanded(child: Text("04:00PM"), flex: 1),
                          Expanded(
                            child: Text("${trClass.duration} Min"),
                            flex: 1,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
              Padding(
                child: Text(
                  "E-connect - Teaching Platform!",
                  style: Theme.of(context).header3,
                ),
                padding: const EdgeInsets.all(10),
              ),
            ],
          );
        }),
      );
      return await saveDocument("$teacherName-$date-schedule", pdf);
    } catch (e) {
      return null;
    }
  }

  Future<File> saveDocument(String name, Document pdf) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  Future<MemoryImage> getLogo() async {
    final bytesData = await rootBundle.load('assets/images/imageLogo.png');
    return MemoryImage(bytesData.buffer.asUint8List());
  }

  Future<void> openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
