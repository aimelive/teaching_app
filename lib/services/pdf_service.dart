import 'dart:io';

import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/services.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfService {
  Widget PaddedText(
    final String text, {
    final TextAlign align = TextAlign.left,
  }) =>
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          textAlign: align,
        ),
      );

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
                      Text("Presented to: $teacherName"),
                      Text("Date: $date"),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(imageLogo),
                  ),
                ],
              ),
              Padding(
                child: Text(
                  "Current Week Schedule!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.all(10),
              ),
              Table(
                border: TableBorder.all(color: PdfColors.black),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        child: Text(
                          'Day',
                          // style: Theme.of(context).header4,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Padding(
                        child: Text(
                          'Course Name',
                          // style: Theme.of(context).header4,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Padding(
                        child: Text(
                          'School Name',
                          // style: Theme.of(context).header4,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Padding(
                        child: Text(
                          'Assistant Name',
                          // style: Theme.of(context).header4,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Padding(
                        child: Text(
                          'Date',
                          // style: Theme.of(context).header4,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                    ],
                  ),
                  ...classes
                      .map(
                        (trClass) => TableRow(
                          children: [
                            Expanded(
                              child: PaddedText(
                                weekDaysFull[trClass.date.toDate().weekday - 1],
                              ),
                              flex: 1,
                            ),
                            Expanded(child: PaddedText(trClass.name), flex: 1),
                            Expanded(
                                child: PaddedText(trClass.schoolName), flex: 1),
                            Expanded(
                                child: PaddedText(trClass.trAssistantName ??
                                    "<assistant_name>"),
                                flex: 1),
                            Expanded(
                              child: PaddedText(
                                "${UiUtils.date(trClass.date)} ${UiUtils.time(trClass.date, trClass.duration)}",
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      )
                      .toList()
                ],
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
      return saveDocument("$teacherName-$date-schedule.pdf", pdf);
    } catch (e) {
      return null;
    }
  }

  Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Download");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  Future<File> saveDocument(String name, Document pdf) async {
    final bytes = await pdf.save();

    final path = await _localPath;

    final file = File('$path/$name');

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
