import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/cubit/restaurant_detail_cubit.dart';
import 'package:flutter_restaurant/cubit/restaurant_list_cubit.dart';
import 'package:flutter_restaurant/data/db/db_helper.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_restaurant/ui/custom/header.dart';
import 'package:flutter_restaurant/ui/custom/loading.dart';
import 'package:flutter_restaurant/ui/custom/no_data.dart';
import 'package:flutter_restaurant/ui/custom/restaurant_item.dart';
import 'package:flutter_restaurant/ui/view/restaurant_detail_view.dart';

class RestaurantListView extends StatefulWidget {
  RestaurantListView({Key? key}) : super(key: key);

  @override
  _RestaurantListViewState createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  double expandedHeight = 170.0;
  double toolbarHeight = 100.0;
  double bottomHeight = 30.0;
  double offset = 0.0;

  bool lastStatus = true;

  _scrollListener() {
    offset = _scrollController.offset;
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    if (_scrollController.hasClients ||
        // ignore: invalid_use_of_protected_member
        _scrollController.positions.length > 1) {
      return _scrollController.hasClients &&
          offset > (expandedHeight - toolbarHeight);
    } else
      return false;
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _searchController.addListener(() {
      setState(() {});
    });

    BlocProvider.of<RestaurantListCubit>(context).getRestaurantList();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  leadingWidth: 0,
                  centerTitle: false,
                  pinned: true,
                  floating: false,
                  backgroundColor: Theme.of(context).accentColor,
                  expandedHeight: expandedHeight,
                  collapsedHeight: toolbarHeight,
                  toolbarHeight: toolbarHeight,
                  brightness: Brightness.dark,
                  title: HeaderView(
                      isShrink: isShrink,
                      title: "Restaurant",
                      subtitle: "This is recommendation restaurant for you !"),
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/restaurant.jpeg"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.dstATop))),
                    ),
                  )),
            ];
          },
          body: RefreshIndicator(
            onRefresh: () => BlocProvider.of<RestaurantListCubit>(context)
                .getRestaurantListApi(),
            child: Column(
              children: [
                Expanded(
                  child: BlocConsumer<RestaurantListCubit, RestaurantListState>(
                    listener: (context, state) {
                      if (state is RestaurantListError) {
                        var msg = state.errMsg != "" ? "(${state.errMsg})" : "";
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Failed to get restaurant data $msg")));
                      }
                    },
                    builder: (context, state) {
                      if (state is RestaurantListLoading) {
                        return LoadingView(message: "Loading data ...");
                      } else if (state is RestaurantListLoaded) {
                        if (state.data.isEmpty) {
                          return NoData();
                        } else {
                          return buildDataList(state.data);
                        }
                      } else {
                        return NoData();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDataList(List<RestaurantDbData> restaurant) {
    var itemFiltered = restaurant.where((element) => element.name
        .toLowerCase()
        .startsWith(_searchController.text.toLowerCase()));
    return itemFiltered.length == 0
        ? NoData()
        : Container(
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemFiltered.length,
              itemBuilder: (context, index) {
                final RestaurantDbData data = itemFiltered.elementAt(index);

                return RestaurantItem(
                    nama: data.name,
                    kota: data.city,
                    imgUrl:
                        "https://restaurant-api.dicoding.dev/images/medium/${data.pictureId}",
                    rating: data.rating.toString(),
                    index: index,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 800),
                            reverseTransitionDuration:
                                Duration(milliseconds: 800),
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return BlocProvider<RestaurantDetailCubit>(
                                create: (context) =>
                                    RestaurantDetailCubit(ApiRepository()),
                                child: RestaurantDetailView(
                                    id: data.id, imgId: data.pictureId),
                              );
                            },
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child) {
                              return Align(
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                          ));
                    });
              },
            ),
          );
  }
}
