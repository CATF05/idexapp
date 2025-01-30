import 'package:flutter/material.dart';
import 'package:frontend/models/etudiant_model.dart';


class EtudiantProfilWidget extends StatelessWidget {
  final String fullName;
  final String urlPhoto;

  const EtudiantProfilWidget({super.key, required this.fullName, required this.urlPhoto,});

  String getInitials(String fullName) {
    if (fullName.trim().isEmpty) return "N/A";
    List<String> nameParts = fullName.trim().split(" ");
    String initials = nameParts.map((name) => name[0]).take(2).join();
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.blueAccent,
      backgroundImage: urlPhoto.isNotEmpty
          ? NetworkImage(urlPhoto)
          : null,
      child: urlPhoto.isEmpty
          ? Text(
              getInitials(fullName),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}