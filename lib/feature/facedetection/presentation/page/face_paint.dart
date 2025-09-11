/*
@author     : karthick.d  10/09/2025
@desc       : custom painter object that will be used for 
              painting cliprect bounding box of the face

*/

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class Facepaint extends CustomPainter {
  final List<Face> facesList;
  final imageFile;

  Facepaint({required this.facesList, required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    // paint the square lip around the face of the image

    if (imageFile != null) {
      // image file available so paint a rect

      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;
    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
