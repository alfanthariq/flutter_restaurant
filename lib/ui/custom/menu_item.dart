import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItem extends StatelessWidget {
  final String menu;
  final IconData icon;
  const MenuItem({Key? key, required this.menu, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 15,
            color: Theme.of(context).hintColor,
          ),
          Padding(padding: EdgeInsets.only(right: 20)),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(menu, style: Theme.of(context).textTheme.bodyText2),
                //Text(price, style: Theme.of(context).textTheme.subtitle2)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
