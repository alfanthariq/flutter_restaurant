import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReviewItem extends StatelessWidget {
  final String name;
  final String review;
  final String date;
  const ReviewItem(
      {Key? key, required this.name, required this.review, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FaIcon(FontAwesomeIcons.solidUserCircle, size: 40),
                Padding(padding: EdgeInsets.only(right: 20)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .apply(color: Colors.amber)),
                    Text(date, style: Theme.of(context).textTheme.overline),
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                review,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
