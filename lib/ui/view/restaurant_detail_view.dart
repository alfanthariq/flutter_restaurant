import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_restaurant/cubit/add_review_cubit.dart';
import 'package:flutter_restaurant/cubit/restaurant_detail_cubit.dart';
import 'package:flutter_restaurant/data/model/restaurant.dart';
import 'package:flutter_restaurant/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_restaurant/ui/custom/loading.dart';
import 'package:flutter_restaurant/ui/custom/menu_item.dart';
import 'package:flutter_restaurant/ui/custom/no_data.dart';
import 'package:flutter_restaurant/ui/custom/review_item.dart';
import 'package:flutter_restaurant/ui/custom/review_item_min.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantDetailView extends StatefulWidget {
  final String id;
  final String? imgId;
  RestaurantDetailView({Key? key, required this.id, this.imgId})
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
  ButtonState buttonState = ButtonState.idle;
  final _formKey = GlobalKey<FormBuilderState>();
  RestaurantDetail? detail;
  bool isBookmark = false;

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

    checkBookmarked();

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
        color: Theme.of(context).backgroundColor,
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
                  actions: [
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            builder: (context) {
                              buttonState = ButtonState.idle;
                              return BlocProvider<AddReviewCubit>(
                                create: (context) =>
                                    AddReviewCubit(ApiRepository()),
                                child: buildAddReview(widget.id, detail!),
                              );
                            },
                          );
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.edit,
                          size: 15,
                          color: isShrink
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? Colors.amberAccent
                                  : Colors.grey[900]
                              : Colors.amber,
                        )),
                    IconButton(
                        onPressed: () {
                          if (isBookmark) {
                            removeBookmark();
                          } else {
                            bookmark();
                          }
                          checkBookmarked();
                        },
                        icon: FaIcon(
                          isBookmark
                              ? FontAwesomeIcons.solidBookmark
                              : FontAwesomeIcons.bookmark,
                          size: 15,
                          color: isShrink
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? Colors.amberAccent
                                  : Colors.grey[900]
                              : Colors.amber,
                        )),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: imgUrl,
                      child: Container(
                          child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.grey[900]!.withOpacity(0.4),
                                          BlendMode.dstATop))));
                        },
                      )),
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
                    detail = state.data;
                    if (widget.imgId == null) {
                      imgUrl =
                          "https://restaurant-api.dicoding.dev/images/medium/${state.data.restaurant.pictureId}";
                    }
                  });
                } else if (state is RestaurantDetailError) {
                  var msg = state.errMsg != "" ? "(${state.errMsg})" : "";
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Failed to get restaurant detail data $msg")));
                  Navigator.pop(context);
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
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  builder: (context) => buildReviewSheet(data.restaurant),
                );
              },
              child: Text("Detail review",
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontSize: 10,
                      color: Colors.amber,
                      decoration: TextDecoration.underline)),
            )
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
      buildMenu(data.restaurant),
    ];
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
              name: restaurant.customerReviews[index].name!,
              review: restaurant.customerReviews[index].review!,
              date: restaurant.customerReviews[index].date!);
        },
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
                  return MenuItem(
                      menu: selectedIndex == 0
                          ? restaurant.menus.foods[index].name
                          : restaurant.menus.drinks[index].name,
                      icon: selectedIndex == 0
                          ? FontAwesomeIcons.utensils
                          : FontAwesomeIcons.mugHot);
                }),
          )
        ],
      ),
    );
  }

  Widget buildReviewSheet(Restaurant restaurant) {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 7),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Detail Reviews",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .apply(color: Theme.of(context).indicatorColor)),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 15,
                      ),
                    ),
                  )
                ],
              )),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: restaurant.customerReviews.length,
              itemBuilder: (context, index) {
                return ReviewItem(
                  name: restaurant.customerReviews[index].name!,
                  date: restaurant.customerReviews[index].date!,
                  review: restaurant.customerReviews[index].review!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddReview(String id, RestaurantDetail detail) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: BlocConsumer<AddReviewCubit, AddReviewState>(
          listener: (context, state) {
            if (state is AddReviewError) {
              setState(() {
                buttonState = ButtonState.fail;
              });
            } else if (state is PostedReview) {
              setState(() {
                buttonState = ButtonState.success;
              });
              Timer(Duration(seconds: 2), () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Success posting your review")));
                setState(() {
                  detail.restaurant.customerReviews =
                      state.data.customerReviews!;
                });
              });
            } else if (state is AddReviewInitial) {
              setState(() {
                buttonState = ButtonState.idle;
              });
            }
          },
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Add Review",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .apply(
                                      color: Theme.of(context).indicatorColor)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.chevronDown,
                                size: 15,
                              ),
                            ),
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: FormBuilder(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: "nama",
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.next,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                ]),
                                decoration: InputDecoration(
                                    labelText: "Your name",
                                    labelStyle: TextStyle(fontSize: 20),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder()),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              FormBuilderTextField(
                                name: "review",
                                textCapitalization:
                                    TextCapitalization.sentences,
                                minLines: 5,
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                ]),
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    labelText: "Your review",
                                    labelStyle: TextStyle(fontSize: 20),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder()),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ProgressButton.icon(
                        iconedButtons: {
                          ButtonState.idle: IconedButton(
                              text: "Send",
                              icon: Icon(Icons.send, color: Colors.grey[900]),
                              color: Theme.of(context).buttonColor),
                          ButtonState.loading: IconedButton(
                              text: "Loading",
                              color: Theme.of(context).buttonColor),
                          ButtonState.fail: IconedButton(
                              text: "Failed",
                              icon: Icon(Icons.cancel, color: Colors.grey[900]),
                              color: Colors.red.shade300),
                          ButtonState.success: IconedButton(
                              text: "Success",
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.grey[900],
                              ),
                              color: Colors.green.shade400)
                        },
                        progressIndicator: CircularProgressIndicator(
                          color: Colors.grey[900],
                        ),
                        textStyle: TextStyle(color: Colors.grey[900]),
                        onPressed: () {
                          if (buttonState != ButtonState.loading) {
                            FocusScope.of(context).unfocus();
                            _formKey.currentState?.save();
                            var data = Map<String, dynamic>();
                            data.addAll(_formKey.currentState!.value);
                            data["id"] = id;

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                buttonState = ButtonState.loading;
                              });
                              BlocProvider.of<AddReviewCubit>(context)
                                  .postReview(data);
                            }
                          }
                        },
                        state: buttonState,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void bookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> fav =
        prefs.getStringList("favourite") ?? List<String>.empty(growable: true);
    fav.add(widget.id);

    prefs.setStringList("favourite", fav);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Saved to your bookmark"),
    ));
  }

  void removeBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> fav =
        prefs.getStringList("favourite") ?? List<String>.empty(growable: true);
    fav.remove(widget.id);

    prefs.setStringList("favourite", fav);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Removed from your bookmark"),
    ));
  }

  void checkBookmarked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> fav =
        prefs.getStringList("favourite") ?? List<String>.empty(growable: true);

    setState(() {
      isBookmark = fav.contains(widget.id);
    });
  }
}
