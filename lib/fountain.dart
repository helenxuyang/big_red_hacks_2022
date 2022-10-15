class Fountain {
  Building building;
  String locationDescription;
  bool isFunctional;
  List<Review> reviews;
  Fountain(
      this.building, this.locationDescription, this.isFunctional, this.reviews);
}

class Building {
  String name;
  double latitude;
  double longitude;
  Building(this.name, this.latitude, this.longitude);
}

class Review {
  String author;
  double rating;
  String? review;
  Review(this.author, this.rating, this.review);
}
