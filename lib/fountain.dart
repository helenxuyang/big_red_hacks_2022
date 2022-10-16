class Fountain {
  String fid;
  Building building;
  String locationDescription;
  bool isFunctional;
  List<Review> reviews;
  Fountain(this.fid, this.building, this.locationDescription, this.isFunctional,
      this.reviews);
}

class Building {
  String bid;
  String name;
  double latitude;
  double longitude;
  Building(this.bid, this.name, this.latitude, this.longitude);
}

class Review {
  String rid;
  String authorName;
  String authorPhoto;
  double rating;
  String? review;
  Review(this.rid, this.authorName, this.authorPhoto, this.rating, this.review);
}
