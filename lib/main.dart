import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/cubit/restaurant_list_cubit.dart';
import 'package:flutter_restaurant/cubit/restaurant_search_cubit.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_restaurant/ui/view/restaurant_list_view.dart';
import 'package:flutter_restaurant/ui/view/restaurant_search_view.dart';
import 'package:flutter_restaurant/utils/theme_data.dart';

void main() {
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Theme(
        data: theme.brightness == Brightness.light
            ? ThemeData.from(colorScheme: ColorScheme.light())
            : ThemeData.from(colorScheme: ColorScheme.dark()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Restaurant",
          theme: lightTheme,
          darkTheme: darkTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => BlocProvider<RestaurantListCubit>(
                create: (context) => RestaurantListCubit(ApiRepository()),
                child: RestaurantListView()),
            '/search': (context) => BlocProvider<RestaurantSearchCubit>(
                  create: (context) => RestaurantSearchCubit(ApiRepository()),
                  child: RestaurantSearchView(),
                )
          },
          themeMode: ThemeMode.system,
        ));
  }
}
