import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String message;
  const LoadingView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        width: 200,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                message,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              width: 150,
              child: LinearProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
