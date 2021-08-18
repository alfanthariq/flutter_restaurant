import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  final bool isShrink;
  final String title;
  final String? subtitle;
  const HeaderView(
      {Key? key, required this.isShrink, required this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline4?.copyWith(
                color: isShrink
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Colors.amberAccent
                        : Colors.grey[900]
                    : Colors.amberAccent),
          ),
          subtitle == null
              ? Container()
              : Text(
                  subtitle ?? "",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: isShrink
                          ? Theme.of(context).brightness == Brightness.dark
                              ? Colors.amberAccent
                              : Colors.grey[900]
                          : Colors.amberAccent),
                )
        ],
      ),
    );
  }
}
