import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/cubit/restaurant_detail_cubit.dart';
import 'package:flutter_restaurant/cubit/restaurant_list_cubit.dart';
import 'package:flutter_restaurant/data/db/db_helper.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_restaurant/ui/custom/loading.dart';
import 'package:flutter_restaurant/ui/custom/no_data.dart';
import 'package:flutter_restaurant/ui/custom/restaurant_item.dart';
import 'package:flutter_restaurant/ui/view/restaurant_detail_view.dart';

class RestaurantFavView extends StatefulWidget {
  RestaurantFavView({Key? key}) : super(key: key);

  @override
  _RestaurantFavViewState createState() => _RestaurantFavViewState();
}

class _RestaurantFavViewState extends State<RestaurantFavView> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<RestaurantListCubit>(context).getRestaurantFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        title: Text(
          "Bookmark",
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<RestaurantListCubit, RestaurantListState>(
                listener: (context, state) {
                  if (state is RestaurantListError) {
                    var msg = state.errMsg != "" ? "(${state.errMsg})" : "";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Failed to get restaurant data $msg")));
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
    );
  }

  Widget buildDataList(List<RestaurantDbData> restaurant) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: restaurant.length,
        itemBuilder: (context, index) {
          final RestaurantDbData data = restaurant.elementAt(index);

          return RestaurantItem(
              nama: data.name,
              kota: data.city,
              imgUrl:
                  "https://restaurant-api.dicoding.dev/images/medium/${data.pictureId}",
              rating: data.rating.toString(),
              index: index,
              onTap: () async {
                FocusScope.of(context).unfocus();
                await Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 800),
                      reverseTransitionDuration: Duration(milliseconds: 800),
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
                BlocProvider.of<RestaurantListCubit>(context)
                    .getRestaurantFav();
              });
        },
      ),
    );
  }
}
