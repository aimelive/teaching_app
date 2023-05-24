import 'package:cloud_firestore/cloud_firestore.dart';

class School {
  String name;
  String image;
  String id;
  String addressLink;
  String description;
  String? poManager;
  String principalName;
  String principalPhone;
  List<String> teachers;
  Timestamp createdAt;
  Timestamp updatedAt;

  School({
    required this.name,
    required this.image,
    required this.addressLink,
    required this.id,
    required this.description,
    this.poManager,
    required this.principalName,
    required this.principalPhone,
    required this.teachers,
    required this.createdAt,
    required this.updatedAt,
  });

  School copyWith({
    String? name,
    String? image,
    String? addressLink,
    String? description,
    String? poManager,
    String? principalName,
    String? principalPhone,
    List<String>? teachers,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) =>
      School(
        name: name ?? this.name,
        id: id,
        image: image ?? this.image,
        addressLink: addressLink ?? this.addressLink,
        description: description ?? this.description,
        poManager: poManager ?? this.poManager,
        principalName: principalName ?? this.principalName,
        principalPhone: principalPhone ?? this.principalPhone,
        teachers: teachers ?? this.teachers,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory School.fromJson(Map<String, dynamic> json) => School(
        name: json["name"],
        image: json["image"],
        id: json["id"],
        addressLink: json["addressLink"],
        description: json["description"],
        poManager: json["poManager"],
        principalName: json["principalName"],
        principalPhone: json["principalPhone"],
        teachers: List<String>.from(json["teachers"].map((x) => x)),
        createdAt: json["createdAt"],
        updatedAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "id": id,
        "addressLink": addressLink,
        "description": description,
        "poManager": poManager,
        "principalName": principalName,
        "principalPhone": principalPhone,
        "teachers": List<String>.from(teachers.map((x) => x)),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
