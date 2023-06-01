import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherClass {
  String id;
  String name;
  String room;
  int duration;
  List<LessonFile> files;
  String schoolId;
  String schoolName;
  String? trAssistantId;
  String? trAssistantName;
  String teacherId;
  Timestamp date;
  Timestamp createdAt;
  Timestamp updatedAt;

  TeacherClass({
    required this.name,
    required this.id,
    required this.duration,
    required this.room,
    required this.files,
    required this.schoolId,
    required this.schoolName,
    this.trAssistantId,
    this.trAssistantName,
    required this.teacherId,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherClass.fromJson(Map<String, dynamic> json) => TeacherClass(
        name: json["name"],
        id: json["id"],
        files: List<LessonFile>.from(
          json["files"].map(
            (x) => LessonFile.fromJson(x),
          ),
        ),
        duration: json["duration"],
        schoolId: json["schoolId"],
        schoolName: json["schoolName"],
        room: json["room"],
        trAssistantId: json["trAssistantId"],
        trAssistantName: json["trAssistantName"],
        teacherId: json["teacherId"],
        date: json["date"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  // Map<String, dynamic> toJson() => {
  //       "name": name,
  //       "id": id,
  //       "duration": duration,
  //       "images": List<String>.from(images.map((x) => x)),
  //       "schoolId": schoolId,
  //       "schoolName": schoolName,
  //       "feedbackId": feedbackId,
  //       "room": "room",
  //       "trAssistantId": trAssistantId,
  //       "teacherId": teacherId,
  //       "date": date,
  //       "createdAt": createdAt,
  //       "updatedAt": updatedAt,
  //     };
}

class LessonFile {
  String title;
  String link;

  LessonFile({
    required this.title,
    required this.link,
  });

  factory LessonFile.fromJson(Map<String, dynamic> json) => LessonFile(
        title: json["title"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
      };
}
