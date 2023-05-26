import 'package:cloud_firestore/cloud_firestore.dart';

class School {
  String name;
  String image;
  String id;
  Address address;
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
    required this.address,
    required this.id,
    required this.description,
    this.poManager,
    required this.principalName,
    required this.principalPhone,
    required this.teachers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        name: json["name"],
        image: json["image"],
        id: json["id"],
        address: Address.fromJson(json["address"]),
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
        "address": address.toJson(),
        "description": description,
        "poManager": poManager,
        "principalName": principalName,
        "principalPhone": principalPhone,
        "teachers": List<String>.from(teachers.map((x) => x)),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class Address {
  String location;
  String street;
  String mapLink;

  Address({
    required this.location,
    required this.street,
    required this.mapLink,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      location: json["location"],
      street: json["street"],
      mapLink: json["mapLink"]);

  Map<String, dynamic> toJson() =>
      {"location": location, "street": street, "mapLink": mapLink};
}
