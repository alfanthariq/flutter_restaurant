import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/cubit/restaurant_detail_cubit.dart';
import 'package:flutter_restaurant/data/model/restaurant.dart';
import 'package:flutter_restaurant/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant/ui/custom/loading.dart';
import 'package:flutter_restaurant/ui/custom/no_data.dart';
import 'package:flutter_restaurant/ui/custom/review_item_min.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RestaurantDetailView extends StatefulWidget {
  final String id;
  final String imgId;
  RestaurantDetailView({Key? key, required this.id, required this.imgId})
      : super(key: key);

  @override
  _RestaurantDetailViewState createState() => _RestaurantDetailViewState();
}

class _RestaurantDetailViewState extends State<RestaurantDetailView> {
  ScrollController? _scrollController;
  double expandedHeight = 250.0;
  double toolbarHeight = 60.0;
  double bottomHeight = 50;
  int selectedIndex = 0;
  String title = "";
  String address = "";
  String rating = "";
  String imgUrl = "";

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController!.hasClients &&
        _scrollController!.offset >
            (expandedHeight - toolbarHeight - bottomHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);

    BlocProvider.of<RestaurantDetailCubit>(context)
        .getRestaurantDetail(widget.id);

    imgUrl =
        "https://restaurant-api.dicoding.dev/images/medium/${widget.imgId}";
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  centerTitle: false,
                  pinned: true,
                  floating: false,
                  expandedHeight: expandedHeight,
                  collapsedHeight: toolbarHeight,
                  toolbarHeight: toolbarHeight,
                  brightness: Brightness.dark,
                  backgroundColor: Theme.of(context).accentColor,
                  leading: IconButton(
                    color: isShrink
                        ? Theme.of(context).brightness == Brightness.dark
                            ? Colors.amberAccent
                            : Colors.grey[900]
                        : Colors.amber,
                    icon: FaIcon(CupertinoIcons.back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    title,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: isShrink
                            ? Theme.of(context).brightness == Brightness.dark
                                ? Colors.amberAccent
                                : Colors.grey[900]
                            : Colors.amber),
                  ),
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: imgUrl,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[900],
                            image: DecorationImage(
                                image: NetworkImage(imgUrl),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.grey[900]!.withOpacity(0.4),
                                    BlendMode.dstATop))),
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    child: buildBottomBar(address, rating),
                    preferredSize: Size(double.infinity, bottomHeight),
                  ),
                )
              ];
            },
            body: BlocConsumer<RestaurantDetailCubit, RestaurantDetailState>(
              listener: (context, state) {
                if (state is RestaurantDetailLoaded) {
                  setState(() {
                    title = state.data.restaurant.name;
                    address =
                        "${state.data.restaurant.address}, ${state.data.restaurant.city}";
                    rating = state.data.restaurant.rating.toString();
                  });
                } else if (state is RestaurantDetailError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Gagal mendapatkan data (${state.errMsg})")));
                }
              },
              builder: (context, state) {
                if (state is RestaurantDetailLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      children: buildBody(state.data),
                    ),
                  );
                } else if (state is RestaurantDetailLoading) {
                  return LoadingView(message: "Loading data ...");
                } else {
                  return NoData();
                }
              },
            )),
      ),
    );
  }

  List<Widget> buildBody(RestaurantDetail data) {
    return [
      buildDescription(data.restaurant.description),
      Padding(padding: EdgeInsets.only(top: 35)),
      Container(
        padding: EdgeInsets.only(left: 15, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Reviews (${data.restaurant.customerReviews.length})",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .apply(color: Theme.of(context).indicatorColor)),
            Text("Detail review",
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontSize: 10,
                    color: Colors.amber,
                    decoration: TextDecoration.underline))
          ],
        ),
      ),
      buildReview(data.restaurant),
      Padding(padding: EdgeInsets.only(top: 15)),
      Container(
        padding: EdgeInsets.only(left: 15, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Menus",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .apply(color: Theme.of(context).indicatorColor)),
          ],
        ),
      ),
      buildMenu(data.restaurant)
    ];
  }

  Widget buildReview(Restaurant restaurant) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      height: 170.0,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        itemCount: restaurant.customerReviews.length > 4
            ? 4
            : restaurant.customerReviews.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ReviewItemMin(
              name: restaurant.customerReviews[index].name,
              review: restaurant.customerReviews[index].review,
              date: restaurant.customerReviews[index].date);
        },
      ),
    );
  }

  Widget buildBottomBar(String kota, String rating) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.all(4),
                    child: FaIcon(
                      FontAwesomeIcons.mapMarkerAlt,
                      size: 12,
                      color: Colors.amber,
                    )),
                Container(
                  child: Text(
                    kota,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.amber),
                  ),
                )
              ],
            ),
          ),
          Container(
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
                      color: Colors.amber,
                    )),
                Container(
                  child: Text(
                    rating,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.amber),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDescription(String description) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 10, right: 10),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7))),
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        child: Text(
          description,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  Widget buildMenu(Restaurant restaurant) {
    return Container(
      height: 300,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          FlutterToggleTab(
            width: 70,
            borderRadius: 3,
            height: 30,
            initialIndex: 0,
            selectedBackgroundColors: [Theme.of(context).buttonColor],
            unSelectedBackgroundColors: [Colors.grey[850]!],
            selectedTextStyle: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.grey[900]),
            unSelectedTextStyle: Theme.of(context)
                .textTheme
                .bodyText2!
                .apply(color: Colors.white),
            labels: ["Foods", "Drinks"],
            selectedLabelIndex: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: 20)),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: false,
                itemCount: selectedIndex == 0
                    ? restaurant.menus.foods.length
                    : restaurant.menus.drinks.length,
                itemBuilder: (context, index) {
                  return buildMenusItem(selectedIndex == 0
                      ? restaurant.menus.foods[index].name
                      : restaurant.menus.drinks[index].name);
                }),
          )
        ],
      ),
    );
  }

  Widget buildMenusItem(String menu) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          FaIcon(
            selectedIndex == 0
                ? FontAwesomeIcons.utensils
                : FontAwesomeIcons.mugHot,
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
