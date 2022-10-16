import 'package:cloud_firestore/cloud_firestore.dart';

class Fountain {
  String fid;
  String buildingName;
  String locationDescription;
  bool isFunctional;
  GeoPoint location;
  List<Review> reviews;
  Fountain(this.fid, this.buildingName, this.locationDescription,
      this.isFunctional, this.location, this.reviews);
}

// class Building {
//   String bid;
//   String name;
//   double latitude;
//   double longitude;
//   Building(this.bid, this.name, this.latitude, this.longitude);
// }

class Review {
  String rid;
  String authorName;
  String authorPhoto;
  int rating;
  String? review;
  Review(this.rid, this.authorName, this.authorPhoto, this.rating, this.review);
}
