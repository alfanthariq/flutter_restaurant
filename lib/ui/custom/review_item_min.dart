import 'package:flutter/material.dart';

class ReviewItemMin extends StatelessWidget {
  final String name;
  final String review;
  final String date;
  const ReviewItemMin(
      {Key? key, required this.name, required this.review, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(name,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .apply(color: Colors.amber)),
            Text(date, style: Theme.of(context).textTheme.overline),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  review,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
