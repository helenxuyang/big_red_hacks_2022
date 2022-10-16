import 'package:flutter/material.dart';

Widget buildStars(double rating) {
  List<Widget> stars = [];
  int fullStars = rating.toInt();
  bool hasHalfStar = rating % 1 > 0;
  const double size = 16;
  for (int i = 0; i < fullStars; i++) {
    stars.add(const Icon(Icons.star, size: size));
  }
  if (hasHalfStar) {
    stars.add(const Icon(Icons.star_half, size: size));
    for (int i = 0; i < 5 - fullStars - 1; i++) {
      stars.add(const Icon(Icons.star_border, size: size));
    }
  } else {
    for (int i = 0; i < 5 - fullStars; i++) {
      stars.add(const Icon(Icons.star_border, size: size));
    }
  }
  return Row(children: stars);
}
