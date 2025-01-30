import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)), // Splash color
        ),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.blue),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          subtitle: Text(description, style: const TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }
}
