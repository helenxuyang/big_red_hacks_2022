import 'package:big_red_hacks_2022/utils.dart';
import 'package:flutter/material.dart';

import 'fountain.dart';
import 'fountain_info.dart';

class ListPage extends StatefulWidget {
  List<Fountain> fountains;
  ListPage(this.fountains);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Fountain> sortedFountains = [];

  @override
  void initState() {
    super.initState();
    sortedFountains = widget.fountains;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort by:',
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() {
                        sortedFountains.sort(
                            (a, b) => a.buildingName.compareTo(b.buildingName));
                      }),
                      child: Text('Building'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        sortedFountains.sort((a, b) =>
                            (getAvgRating(b.reviews) - getAvgRating(a.reviews))
                                .toInt());
                      }),
                      child: Text('Rating'),
                    ),
                  ],
                ),
              ],
            );
          }
          return FountainInfo(sortedFountains[index - 1],
              sortedFountains[index - 1].reviews, null);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 24,
          thickness: 1,
        ),
        itemCount: sortedFountains.length,
      ),
    );
  }
}
