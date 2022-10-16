import 'package:big_red_hacks_2022/fountain.dart';
import 'package:big_red_hacks_2022/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  ReviewsPage(this.fountain, this.user);
  final Fountain fountain;
  final User? user;

  @override
  State<StatefulWidget> createState() => ReviewsPageState();
}

class ReviewsPageState extends State<ReviewsPage> {
  int ratingInput = 0;
  String? reviewInput;

  Widget buildStarButtons() {
    List<Widget> starButtons = [];
    for (int i = 0; i < 5; i++) {
      starButtons.add(IconButton(
        onPressed: () => setState(() {
          ratingInput = i + 1;
        }),
        icon: Icon(i < ratingInput ? Icons.star : Icons.star_border),
      ));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.start, children: starButtons);
  }

  Widget buildAuthorInfo(String? name, String? photoUrl) {
    return Row(
      children: [
        photoUrl != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                maxRadius: 16,
              )
            : const Icon(Icons.person),
        const SizedBox(width: 8),
        Text(
          name ?? 'Review',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget buildReviewCard(Review review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAuthorInfo(review.authorName, review.authorPhoto),
            const SizedBox(height: 8),
            buildStars(review.rating),
            const SizedBox(height: 8),
            Text(review.review ?? '')
          ],
        ),
      ),
    );
  }

  Widget buildNewReviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: buildAuthorInfo(
                  widget.user?.displayName, widget.user?.photoURL),
            ),
            buildStarButtons(),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (input) => setState(() {
                reviewInput = input;
              }),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  // TODO: connect to backend to create review
                },
                child: Text('Submit'))
          ],
        ),
      ),
    );
  }

  TextStyle getHeaderStyle() {
    return const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  }

  Widget buildUserReviewSection() {
    Review? userReview;
    for (Review r in widget.fountain.reviews) {
      if (r.rid == widget.user?.uid) {
        userReview = r;
        break;
      }
    }
    print('has review ' + userReview.toString());
    return userReview != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Review',
                style: getHeaderStyle(),
              ),
              const SizedBox(height: 8),
              buildReviewCard(userReview),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leave a review',
                style: getHeaderStyle(),
              ),
              const SizedBox(height: 8),
              buildNewReviewCard(),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Fountain in ' + widget.fountain.building.name),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            buildUserReviewSection(),
            const SizedBox(height: 24),
            Text('Reviews', style: getHeaderStyle()),
            const SizedBox(height: 8),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.fountain.reviews.where((review) {
                return review.rid != widget.user?.uid;
              }).map((review) {
                return buildReviewCard(review);
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
