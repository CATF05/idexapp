import 'package:flutter/material.dart';

class Dashboarditem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  String? textOnButton;
  VoidCallback? onPressed;
  Dashboarditem({
    super.key, 
    required this.icon, 
    required this.color, 
    required this.label, 
    required this.value,
    this.textOnButton,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 195,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Container(
                width: 265,
                height: 145,
                padding: const EdgeInsets.only(right: 5, top: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(label, style: const TextStyle(fontSize: 12),),
                        Text(value, style: const TextStyle(fontSize: 28),),
                      ],
                    ),
                    if(onPressed!=null)
                    Column(
                      children: [
                        const Divider(indent: 20, height: 1, color: Color.fromARGB(255, 237, 232, 232),),
                        TextButton(
                          onPressed: onPressed, 
                          child: Row(
                            children: [
                              const Icon(
                                Icons.remove_red_eye_outlined, 
                                size: 14, 
                                color: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                textOnButton ?? "Consulter les ${label.split(' ')[0]}",
                                style: const TextStyle(fontSize: 11, color: Colors.black),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            child: Card(
              color: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: SizedBox(
                width: 75,
                height: 75,
                child: Center(child: Icon(icon, color: Colors.white, size: 35,),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}