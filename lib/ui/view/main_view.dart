import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/cubit/restaurant_list_cubit.dart';
import 'package:flutter_restaurant/cubit/restaurant_search_cubit.dart';
import 'package:flutter_restaurant/data/db/db_helper.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_restaurant/ui/view/restaurant_fav.dart';
import 'package:flutter_restaurant/ui/view/restaurant_list_view.dart';
import 'package:flutter_restaurant/ui/view/restaurant_search_view.dart';
import 'package:flutter_restaurant/ui/view/settings.dart';
import 'package:flutter_restaurant/utils/notification_helper.dart';
import 'package:flutter_restaurant/utils/scheduling_provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  AppDatabase db = AppDatabase();
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    final NotificationHelper _notificationHelper = NotificationHelper();
    _notificationHelper.configureSelectNotificationSubject("/detail");
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(child: allScreens()[tabIndex]),
          buildBottomNavBar()
        ],
      ),
    );
  }

  Widget buildBottomNavBar() {
    return GNav(
      rippleColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
      hoverColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
      haptic: true,
      tabBorderRadius: 15,
      curve: Curves.linear,
      duration: Duration(milliseconds: 500),
      gap: 10,
      color: Theme.of(context).indicatorColor,
      activeColor: Theme.of(context).indicatorColor,
      iconSize: 20,
      backgroundColor: Theme.of(context)
          .bottomNavigationBarTheme
          .backgroundColor!, //isDarkModeOn ? Colors.grey[850]! : Colors.grey[200]!,
      tabBackgroundColor: Theme.of(context).highlightColor,
      tabMargin: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).padding.bottom + 10),
      padding: EdgeInsets.symmetric(
          horizontal: 10, vertical: 7), // navigation bar padding
      tabs: [
        GButton(
          icon: CupertinoIcons.home,
          text: 'Home',
        ),
        GButton(
          icon: CupertinoIcons.bookmark,
          text: 'Bookmark',
        ),
        GButton(
          icon: CupertinoIcons.search,
          text: 'Search',
        ),
        GButton(
          icon: CupertinoIcons.settings,
          text: 'Settings',
        )
      ],
      selectedIndex: tabIndex,
      onTabChange: (value) {
        setState(() {
          tabIndex = value;
        });
      },
    );
  }

  List<Widget> allScreens() {
    return [
      BlocProvider<RestaurantListCubit>(
          create: (context) =>
              RestaurantListCubit(ApiRepository(), db.restaurantDao),
          child: RestaurantListView()),
      BlocProvider<RestaurantListCubit>(
          create: (context) =>
              RestaurantListCubit(ApiRepository(), db.restaurantDao),
          child: RestaurantFavView()),
      BlocProvider<RestaurantSearchCubit>(
          create: (context) => RestaurantSearchCubit(ApiRepository()),
          child: RestaurantSearchView()),
      ChangeNotifierProvider<SchedulingProvider>(
        create: (context) => SchedulingProvider(),
        child: SettingsView(),
      )
    ];
  }
}
