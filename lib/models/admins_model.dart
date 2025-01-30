// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class AdminsModel {
//   String id;
//   String name;
//   String role;
//   String email;
//   AdminsModel({
//     required this.id,
//     required this.name,
//     required this.role,
//     required this.email,
//   });

//   AdminsModel copyWith({
//     String? id,
//     String? name,
//     String? role,
//     String? email,
//   }) {
//     return AdminsModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       role: role ?? this.role,
//       email: email ?? this.email,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'role': role,
//       'email': email,
//     };
//   }

//   factory AdminsModel.fromMap(Map<String, dynamic> map) {
//     return AdminsModel(
//       id: map['id'] as String,
//       name: map['name'] as String,
//       role: map['role'] as String,
//       email: map['email'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory AdminsModel.fromJson(String source) => AdminsModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'AdminsModel(id: $id, name: $name, role: $role, email: $email)';
//   }

//   @override
//   bool operator ==(covariant AdminsModel other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.id == id &&
//       other.name == name &&
//       other.role == role &&
//       other.email == email;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//       name.hashCode ^
//       role.hashCode ^
//       email.hashCode;
//   }
// }
