import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/cubit/restaurant_detail_cubit.dart';
import 'package:flutter_restaurant/cubit/restaurant_search_cubit.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_restaurant/ui/custom/input_field.dart';
import 'package:flutter_restaurant/ui/custom/loading.dart';
import 'package:flutter_restaurant/ui/custom/no_data.dart';
import 'package:flutter_restaurant/ui/custom/restaurant_item.dart';
import 'package:flutter_restaurant/ui/view/restaurant_detail_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RestaurantSearchView extends StatefulWidget {
  RestaurantSearchView({Key? key}) : super(key: key);

  @override
  _RestaurantSearchViewState createState() => _RestaurantSearchViewState();
}

class _RestaurantSearchViewState extends State<RestaurantSearchView> {
  final TextEditingController? _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).buttonColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.grey[900],
          ),
        ),
        title: Text(
          "Search",
          style: TextStyle(color: Colors.grey[900]),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).buttonColor),
              child: InputFieldArea(
                controller: _searchController!,
                hint: "Input restaurant / food / drink name",
                icon: FontAwesomeIcons.search,
                onSubmit: (value) {
                  FocusScope.of(context).unfocus();
                  BlocProvider.of<RestaurantSearchCubit>(context)
                      .searchRestaurant(value);
                },
                obscure: false,
              ),
            ),
            Expanded(
                child:
                    BlocConsumer<RestaurantSearchCubit, RestaurantSearchState>(
              builder: (context, state) {
                if (state is RestaurantSearchLoaded) {
                  var restaurant = state.data.restaurants;
                  return restaurant.length == 0
                      ? NoData()
                      : ListView.builder(
                          itemCount: restaurant.length,
                          itemBuilder: (context, index) {
                            return RestaurantItem(
                              nama: restaurant[index].name,
                              kota: restaurant[index].city,
                              imgUrl:
                                  "https://restaurant-api.dicoding.dev/images/medium/${restaurant[index].pictureId}",
                              rating: restaurant[index].rating.toString(),
                              index: index,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 800),
                                      reverseTransitionDuration:
                                          Duration(milliseconds: 800),
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return BlocProvider<
                                                RestaurantDetailCubit>(
                                            create: (context) =>
                                                RestaurantDetailCubit(
                                                    ApiRepository()),
                                            child: RestaurantDetailView(
                                                id: restaurant[index].id,
                                                imgId: restaurant[index]
                                                    .pictureId));
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
                              },
                            );
                          },
                        );
                } else if (state is RestaurantSearchLoading) {
                  return LoadingView(message: state.loadingMsg);
                } else {
                  return NoData();
                }
              },
              listener: (context, state) {
                if (state is RestaurantSearchError) {
                  var msg = state.errMsg != "" ? "(${state.errMsg})" : "";
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Failed to get restaurant data $msg")));
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
