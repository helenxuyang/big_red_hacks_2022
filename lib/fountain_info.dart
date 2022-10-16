import 'package:big_red_hacks_2022/fountain.dart';
import 'package:big_red_hacks_2022/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FountainInfo extends StatelessWidget {
  Fountain fountain;
  List<Review> reviews;
  LatLng? currLoc;
  FountainInfo(this.fountain, this.reviews, this.currLoc);

  @override
  Widget build(BuildContext context) {
    Widget dividerDot = const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(
        Icons.circle,
        size: 2,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fountain in ' + fountain.buildingName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            currLoc != null
                ? Text(calculateDistance(
                    fountain.location.latitude,
                    fountain.location.longitude,
                    currLoc?.latitude,
                    currLoc?.longitude))
                : Container(),
            currLoc != null ? dividerDot : Container(),
            buildStars(getAvgRating(reviews)),
            Text('(' + reviews.length.toString() + ')'),
            dividerDot,
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: fountain.isFunctional
                  ? const [
                      Icon(Icons.check_circle_outline,
                          color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Functional',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      )
                    ]
                  : const [
                      Icon(Icons.cancel_outlined,
                          color: Colors.redAccent, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Broken',
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      )
                    ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Location: ' + fountain.locationDescription,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
