// Collection names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'fountain.dart';

class Helpers {
  static String fountains = 'fountains';
  static String buildings = 'buildings';
  static String users = 'users';

  static Future<void> submitReview(String fountainId, String reviewId,
      String author, String authorPhotoUrl, int rating, String? review) async {
    FirebaseFirestore.instance
        .collection(fountains)
        .doc(fountainId)
        .collection('ratings')
        .doc(reviewId)
        .set({
      "authorName": author,
      "authorPhoto": authorPhotoUrl,
      "rating": rating,
      "review": review,
      "functional": true,
    });
  }

  static Future<void> updateMaintenanceStatus(
      String fountainId, bool status) async {
    FirebaseFirestore.instance
        .collection(fountains)
        .doc(fountainId)
        .update({'functional': status});
  }

  static Future<bool> queryMaintenanceStatus(String fountainId) async {
    DocumentSnapshot dShot = await FirebaseFirestore.instance
        .collection(fountains)
        .doc(fountainId)
        .get();
    return dShot.get('functional');
  }

  static Stream fountainRatingsStream(String fountainId) {
    return FirebaseFirestore.instance
        .collection(fountains)
        .doc(fountainId)
        .collection('ratings')
        .snapshots();
  }

  static List<Review> ratingsFromQuery(QuerySnapshot cShot) {
    return cShot.docs
        .map<Review>((doc) => Review(doc.id, doc.get('authorName'),
            doc.get('authorPhoto'), doc.get('rating'), doc.get('review')))
        .toList();
  }

  static Future<List<Review>> queryAllRatingsFountain(String fountainId) async {
    QuerySnapshot cShot = await FirebaseFirestore.instance
        .collection(fountains)
        .doc(fountainId)
        .collection('ratings')
        .get();

    return cShot.docs
        .map<Review>((doc) => Review(doc.id, doc.get('authorName'),
            doc.get('authorPhoto'), doc.get('rating'), doc.get('review')))
        .toList();
  }

  static StreamBuilder ratingsStreamBuilder(String fountainId,
      Function(BuildContext, List<Review>) builderFromReviews) {
    return StreamBuilder(
        stream: fountainRatingsStream(fountainId),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          List<Review> reviews = Helpers.ratingsFromQuery(snapshot.data);
          return builderFromReviews(context, reviews);
        });
  }

  static Future<double> getAverageRatingFountain(String fountainId) async {
    List<Review> ratings = await queryAllRatingsFountain(fountainId);
    if (ratings.isEmpty) {
      return 0;
    }
    double sum = ratings.fold(
        0, (double previousValue, element) => previousValue + element.rating);
    return (2 * sum / ratings.length).round() / 2.0;
  }

  static Future<List<Fountain>> getAllFountains() async {
    print('get all fountains start');
    QuerySnapshot<Object> qShot =
        await FirebaseFirestore.instance.collection(fountains).get();
    print('after qshot');
    List<Fountain> fountainList = [];
    for (QueryDocumentSnapshot doc in qShot.docs) {
      List<Review> ratings = await queryAllRatingsFountain(doc.id);
      Fountain f = Fountain(
          doc.id,
          doc.get('building_name'),
          doc.get('description'),
          doc.get('functional'),
          doc.get('location'),
          ratings);
      fountainList.add(f);
    }
    return fountainList;
  }
}
