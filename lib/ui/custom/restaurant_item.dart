import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantItem extends StatelessWidget {
  final String nama;
  final String kota;
  final String imgUrl;
  final String rating;
  final int index;
  final VoidCallback? onTap;

  RestaurantItem(
      {required this.nama,
      required this.kota,
      required this.imgUrl,
      required this.rating,
      required this.index,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.only(top: 7, bottom: 7, left: 7, right: 7),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 140,
              height: 128,
              margin: EdgeInsets.only(left: 10),
              child: Stack(
                children: <Widget>[
                  Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  )),
                  Center(
                    child: imgUrl == ""
                        ? Container(
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Hero(
                              tag: imgUrl,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                width: 140,
                                height: 100,
                                image: imgUrl,
                                fit: BoxFit.cover,
                                placeholderErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Container(
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Container(
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 16.0)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    color: Theme.of(context).splashColor,
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 14),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    nama,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .apply(color: Theme.of(context).indicatorColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(4),
                          child: FaIcon(FontAwesomeIcons.mapMarkerAlt,
                              size: 12, color: Theme.of(context).hintColor)),
                      Container(
                        child: Text(
                          kota,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .apply(color: Theme.of(context).hintColor),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          padding: EdgeInsets.all(4),
                          child: FaIcon(
                            FontAwesomeIcons.star,
                            size: 12,
                            color: Theme.of(context).hintColor,
                          )),
                      Container(
                        child: Text(
                          rating,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .apply(color: Theme.of(context).hintColor),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
