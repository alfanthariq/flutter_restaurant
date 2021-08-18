import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utils/scheduling_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool reminderValue = false;

  @override
  void initState() {
    super.initState();
    checkReminderVal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          title: Text(
            "Settings",
            style: TextStyle(color: Theme.of(context).indicatorColor),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              SwitchListTile(
                title: Text("Restaurant Notification"),
                subtitle: Text(
                  reminderValue ? "Enabled" : "Disabled",
                  style: TextStyle(color: Colors.grey),
                ),
                value: reminderValue,
                onChanged: (value) {
                  setState(() {
                    reminderValue = value;
                    setReminder(value);
                  });
                },
                activeTrackColor: Colors.amberAccent,
                activeColor: Colors.amber,
              )
            ],
          ),
        ));
  }

  void checkReminderVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      reminderValue = prefs.getBool("reminderOn") ?? false;
    });
  }

  void setReminder(bool status) async {
    SchedulingProvider().scheduledRestaurant(status);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("reminderOn", status);

    if (status) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You'll receive restaurant notification")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("You'll stop receive restaurant notification")));
    }
  }
}
