import 'package:cloud_firestore/cloud_firestore.dart';

class Fountain {
  Building building;
  String locationDescription;
  bool isFunctional;
  GeoPoint location;
  List<Review> reviews;
  Fountain(this.building, this.locationDescription, this.isFunctional,
      this.location, this.reviews);
}

class Building {
  String name;
  double latitude;
  double longitude;
  Building(this.name, this.latitude, this.longitude);
}

class Review {
  String author;
  int rating;
  String? review;
  Review(this.author, this.rating, this.review);
}
