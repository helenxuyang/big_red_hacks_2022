// Collection names
import 'package:cloud_firestore/cloud_firestore.dart';

import 'fountain.dart';

class Helpers {
  static String fountains = 'fountains';
  static String buildings = 'buildings';
  static String users = 'users';

  static List<Review> _castReviewHelper(QuerySnapshot qShot) {
    return qShot.docs[0]
        .get('ratings')
        .map<Review>((doc) => Review(doc.id, doc.get('authorName'),
            doc.get('authorPhoto'), doc.get('rating'), doc.get('review')))
        .toList();
  }

  static Future<void> submitReview(String fountainId, String reviewId,
      String author, String authorPhotoUrl, int rating, String? review) async {
    FirebaseFirestore.instance.collection(fountains).doc(fountainId).set({
      "authorName": author,
      "authorPhoto": authorPhotoUrl,
      "rating": rating,
      "review": review
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

  static Future<List<Review>> queryAllRatingsFountain(String fountainId) async {
    QuerySnapshot qShot = await FirebaseFirestore.instance
        .collection(fountains)
        .where(fountains == fountainId)
        .get();

    return _castReviewHelper(qShot);
  }

  static Future<double> getAverageRatingFountain(String fountainId) async {
    List<Review> ratings = await queryAllRatingsFountain(fountainId);
    double sum = ratings.fold(
        0, (double previousValue, element) => previousValue + element.rating);
    return (2 * sum / ratings.length).round() / 2.0;
  }

  static Future<List<Fountain>> getAllFountains() async {
    print('get all fountains start');
    QuerySnapshot<Object> qShot =
        await FirebaseFirestore.instance.collection(fountains).get();
    print('after qshot');
    List<Review> ratings = _castReviewHelper(qShot);
    return qShot.docs.map<Fountain>((doc) {
      print('fountain doc ' + doc.id);
      return Fountain(doc.id, doc.get('building_name'), doc.get('description'),
          doc.get('functional'), doc.get('location'), ratings);
    }).toList();
  }
}
