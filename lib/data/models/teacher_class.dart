import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherClass {
  String name;
  int duration;
  List<String> images;
  String schoolId;
  String? trAssistantId;
  String teacherId;
  Timestamp date;
  Timestamp createdAt;
  Timestamp updatedAt;

  TeacherClass({
    required this.name,
    required this.duration,
    required this.images,
    required this.schoolId,
    this.trAssistantId,
    required this.teacherId,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  TeacherClass copyWith({
    String? name,
    int? duration,
    List<String>? images,
    String? schoolId,
    String? trAssistantId,
    String? teacherId,
    Timestamp? date,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) =>
      TeacherClass(
        name: name ?? this.name,
        duration: duration ?? this.duration,
        images: images ?? this.images,
        schoolId: schoolId ?? this.schoolId,
        trAssistantId: trAssistantId ?? this.trAssistantId,
        teacherId: teacherId ?? this.teacherId,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory TeacherClass.fromJson(Map<String, dynamic> json) => TeacherClass(
        name: json["name"],
        duration: json["duration"],
        images: List<String>.from(json["images"].map((x) => x)),
        schoolId: json["schoolId"],
        trAssistantId: json["trAssistantId"],
        teacherId: json["teacherId"],
        date: json["date"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "duration": duration,
        "images": List<String>.from(images.map((x) => x)),
        "schoolId": schoolId,
        "trAssistantId": trAssistantId,
        "teacherId": teacherId,
        "date": date,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
