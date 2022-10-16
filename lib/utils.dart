import 'dart:math';

import 'package:flutter/material.dart';

import 'fountain.dart';

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

double getAvgRating(List<Review> ratings) {
  if (ratings.isEmpty) {
    return 0;
  }
  double sum = ratings.fold(
      0, (double previousValue, element) => previousValue + element.rating);
  return (2 * sum / ratings.length).round() / 2.0;
}

String calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return (12742 * asin(sqrt(a)) * 0.621371).toStringAsFixed(2) + ' mi';
}
