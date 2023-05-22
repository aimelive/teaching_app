import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String names;
  String profilePic;
  String profilePicId;
  dynamic tel;
  dynamic nationality;
  dynamic address;
  String email;
  String password;
  bool status;
  String roleId;
  dynamic teacherAtId;
  dynamic poAtId;
  dynamic tAssistantInClassId;
  dynamic tAssistantId;
  Role role;

  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.names,
    required this.profilePic,
    required this.profilePicId,
    this.tel,
    this.nationality,
    this.address,
    required this.email,
    required this.password,
    required this.status,
    required this.roleId,
    this.teacherAtId,
    this.poAtId,
    this.tAssistantInClassId,
    this.tAssistantId,
    required this.role,
  });

  factory User.fromJson(dynamic json) => User(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        names: json["names"],
        profilePic: json["profile_pic"],
        profilePicId: json["profile_pic_id"],
        tel: json["tel"],
        nationality: json["nationality"],
        address: json["address"],
        email: json["email"],
        password: json["password"],
        status: json["status"],
        roleId: json["role_id"],
        teacherAtId: json["teacher_at_id"],
        poAtId: json["PO_at_id"],
        tAssistantInClassId: json["t_assistant_in_class_id"],
        tAssistantId: json["t_assistant_id"],
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "names": names,
        "profile_pic": profilePic,
        "profile_pic_id": profilePicId,
        "tel": tel,
        "nationality": nationality,
        "address": address,
        "email": email,
        "password": password,
        "status": status,
        "role_id": roleId,
        "teacher_at_id": teacherAtId,
        "PO_at_id": poAtId,
        "t_assistant_in_class_id": tAssistantInClassId,
        "t_assistant_id": tAssistantId,
        "role": role.toJson(),
      };
}

class Role {
  String id;
  DateTime createdAt;
  String name;
  bool status;

  Role({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.status,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "name": name,
        "status": status,
      };
}

User dummyUser = User.fromJson({
  "id": "644f856d16b1b6bf7d68a206",
  "created_at": "2023-05-01T09:25:01.738Z",
  "updated_at": "2023-05-01T09:25:01.738Z",
  "names": "John Doe",
  "profile_pic":
      "https://cdn.pixabay.com/photo/2021/04/27/04/19/girl-6210483_1280.jpg",
  "profile_pic_id": "teaching-app/1682960973820-unitytut-birdwingup.png",
  "tel": null,
  "nationality": null,
  "address": null,
  "email": "admin",
  "password": "\$2b\$10\$R5xxYap3XTD1.aRcA01DGeyKxfGF9OghnW349msk9IzsioL8y3tam",
  "status": true,
  "role_id": "644d328cc3035c3d6b140f89",
  "teacher_at_id": null,
  "PO_at_id": null,
  "t_assistant_in_class_id": null,
  "t_assistant_id": null,
  "role": {
    "id": "644d328cc3035c3d6b140f89",
    "created_at": "2023-04-29T15:06:52.536Z",
    "name": "Administrator",
    "status": true
  }
});
