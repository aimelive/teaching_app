import 'dart:convert';

UserAccount userFromJson(String str) => UserAccount.fromJson(json.decode(str));

String userToJson(UserAccount data) => json.encode(data.toJson());

class UserAccount {
  String id;
  DateTime createdAt;
  // DateTime updatedAt;
  String names;
  String profilePic;
  // String profilePicId;
  String tel;
  // dynamic nationality;
  // dynamic address;
  String email;
  // String password;
  bool status;
  // String roleId;
  // dynamic teacherAtId;
  // dynamic poAtId;
  // dynamic tAssistantInClassId;
  // dynamic tAssistantId;
  Role role;

  UserAccount({
    required this.id,
    required this.createdAt,
    // required this.updatedAt,
    required this.names,
    required this.profilePic,
    // required this.profilePicId,
    required this.tel,
    // this.nationality,
    // this.address,
    required this.email,
    // required this.password,
    required this.status,
    // required this.roleId,
    // this.teacherAtId,
    // this.poAtId,
    // this.tAssistantInClassId,
    // this.tAssistantId,
    required this.role,
  });

  factory UserAccount.fromJson(dynamic json) => UserAccount(
        id: json["id"],
        createdAt: json["created_at"].runtimeType == String
            ? DateTime.parse(json["created_at"])
            : json["created_at"]?.toDate() ?? DateTime.now(),
        // updatedAt: json["created_at"].runtimeType == String
        //     ? DateTime.parse(json["updated_at"])
        //     : json["created_at"]?.toDate() ?? DateTime.now(),
        names: json["names"] ?? "Unknown User",
        profilePic: json["profile_pic"],
        // profilePicId: json["profile_pic_id"],
        tel: json["tel"] ?? "Unknown phone number",
        // nationality: json["nationality"],
        // address: json["address"],
        email: json["email"],
        // password: json["password"],
        status: json["status"],
        // roleId: json["role_id"],
        // teacherAtId: json["teacher_at_id"],
        // poAtId: json["PO_at_id"],
        // tAssistantInClassId: json["t_assistant_in_class_id"],
        // tAssistantId: json["t_assistant_id"],
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "names": names,
        "profile_pic": profilePic,
        // "profile_pic_id": profilePicId,
        "tel": tel,
        // "nationality": nationality,
        // "address": address,
        "email": email,
        // "password": password,
        "status": status,
        // "role_id": roleId,
        // "teacher_at_id": teacherAtId,
        // "PO_at_id": poAtId,
        // "t_assistant_in_class_id": tAssistantInClassId,
        // "t_assistant_id": tAssistantId,
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
        createdAt: json["created_at"].runtimeType == String
            ? DateTime.parse(json["created_at"])
            : json["created_at"]?.toDate() ?? DateTime.now(),
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
