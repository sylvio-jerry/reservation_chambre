import 'package:flutter/material.dart';
import 'package:reservation/src/navigation/app_route_name.dart';
import 'package:reservation/src/pages/home/home_page.dart';



class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    AppRouteName.homePage: (context) => const HomePage(),
  };
}
