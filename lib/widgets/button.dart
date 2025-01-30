import 'dart:ui';

// import 'package:ecowatt/utils/constants/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  VoidCallback onTap;
  String text;
  Color? color;
  IconData? icon;
  EdgeInsetsGeometry? padding;
  double? textSize;
  ButtonWidget({
    Key? key,
    required this.onTap,
    required this.text,
    this.color,
    this.padding,
    this.icon,
    this.textSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).cardColor,
          backgroundColor: color,
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 21,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
          padding: EdgeInsets
              .zero, // équivalent à EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(fontSize: textSize, color: Colors.white),),
            if(icon != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, color: Colors.white,),
              )
          ],
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 30),
    //   child: ElevatedButton(
    //     onPressed: onTap,
    //     style: ElevatedButton.styleFrom(
    //       foregroundColor:
    //           Theme.of(context).cardColor,
    //       backgroundColor:
    //           Constants.second,
    //       textStyle: const TextStyle(
    //         fontFamily: 'Roboto',
    //         color: Colors.white,
    //         fontSize: 21,
    //         letterSpacing: 0,
    //         fontWeight: FontWeight.bold,
    //       ),
    //       padding: EdgeInsets
    //           .zero,
    //       minimumSize: const Size(double.infinity, 50),
    //       elevation: 2,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(20),
    //       ),
    //       side: const BorderSide(
    //         color: Colors.transparent,
    //         width: 1,
    //       ),
    //     ),
    //     child: Text(text),
    //   ),
    // );
  }
}
