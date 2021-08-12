import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 120,
              image: AssetImage('assets/images/empty.png'),
              fit: BoxFit.fill,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  borderRadius: BorderRadius.circular(3)),
              child: Text(
                "No Data",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
