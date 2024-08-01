import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reservation/src/navigation/app_route_name.dart';
import 'package:reservation/src/navigation/navigation_service.dart';
import 'package:reservation/src/pages/chambre/chambre_page.dart';
import 'package:reservation/src/pages/client/client_page.dart';
import 'package:reservation/src/pages/profil/profil_page.dart';
import 'package:reservation/src/pages/reservation/formulaire_reservation_page.dart';
import 'package:reservation/src/pages/reservation/reservation_page.dart';
import 'package:reservation/src/provider/home/home_provider.dart';
import 'package:reservation/src/themes/colors.dart';
import 'package:reservation/src/widgets/app_bar/home_bottom_app_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const bgFloatingButton = AppColors.greyDark;
    final iconFloatingColor = isDarkMode
        ? AppColors.grey_2.withOpacity(.6)
        : AppColors.white.withOpacity(.5);

    return Scaffold(
        appBar: null,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const HomeBottomAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
                backgroundColor: bgFloatingButton,
                elevation: 0,
                shape: const CircleBorder(),
                onPressed: () {
                  NavigationService.navigateToPage(context,
                      targetPage: const FormulaireReservationPage(),
                      refreshSourcePage: () {});
                },
                child: SvgPicture.asset("assets/images/add_1.svg",
                    height: 30, color: iconFloatingColor))),
        body: getBody(ref));
  }
}

Widget getBody(WidgetRef ref) {
  var pageIndex = ref.watch(pageIndexProvider);

  return IndexedStack(
    index: pageIndex,
    children: [
      const ReservationPage(),
      const ChambrePage(),
      Container(),
      const ClientPage(),
      const ProfilPage(),
    ],
  );
}
