// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:reservation/src/navigation/app_route_name.dart';
import 'package:reservation/src/pages/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationService {
  //navigate without context
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigationService instance = NavigationService();

  dynamic forwardTo(String route, {dynamic arguments}) {
    return instance.navigatorKey.currentState
        ?.pushNamed(route, arguments: arguments);
  }

  dynamic goBack() {
    return navigatorKey.currentState?.pop();
  }

  Future<void> forwardToLoginPage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    instance.forwardTo(AppRouteName.homePage);
  }

  // navigation Standard dynamic
  static void navigateToPage(BuildContext context,
      {required Widget targetPage,
      required Function refreshSourcePage,
      bool mounted = true}) async {
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );

    if (!mounted) return;
    if (shouldRefresh) {
      refreshSourcePage();
    }
  }

  // navigation PushName dynamic
  static void navigateByPushNameToPage(BuildContext context,
      {required String pageRoute,
      required Function refreshSourcePage,
      required Map<String, dynamic> arguments}) async {
    arguments["refreshSourcePage"] = refreshSourcePage;
    final shouldRefresh =
        await Navigator.pushNamed(context, pageRoute, arguments: arguments);

    if (shouldRefresh == true) {
      refreshSourcePage();
    }
  }

  // pop until to page dynamic
  static void popUntilToPage(BuildContext context,
      {required String pageRoute}) {
    Navigator.popUntil(context, (route) {
      try {
        final Map args = route.settings.arguments as Map;
        final Function refreshSourcePage = args['refreshSourcePage'];
        refreshSourcePage();
      } catch (e) {
        // nothing special to do
      }
      return route.settings.name == pageRoute;
    });
  }
}
