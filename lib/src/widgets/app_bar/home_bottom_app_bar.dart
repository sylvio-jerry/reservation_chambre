// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reservation/src/provider/home/home_provider.dart';
import 'package:reservation/src/themes/colors.dart';

class HomeBottomAppBar extends ConsumerWidget {
  const HomeBottomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> iconItems = [
      "assets/images/document.svg",
      "assets/images/house.svg",
      "",
      "assets/images/client.svg",
      "assets/images/settings.svg",
    ];

    void updateParentState(int value) {
      ref.read(pageIndexProvider.notifier).setPageIndex(value);
    }

    final pageIndex = ref.watch(pageIndexProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const bgBottomAppBar =  AppColors.greyDark;

    return BottomAppBar(
      color: bgBottomAppBar,
      surfaceTintColor: bgBottomAppBar,
      elevation: 1,
      height: 70,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(iconItems.length, (index) {
          if (index == 2) {
            return const SizedBox(width: 60); // add space between icons
          }

          Widget iconWidget = SvgPicture.asset(
            iconItems[index],
            height: 30,
            color: (pageIndex == index)
                ? AppColors.white
                : (isDarkMode
                    ? AppColors.grey_2.withOpacity(.6)
                    : AppColors.white.withOpacity(.5)),
          );

          return GestureDetector(
            onTap: () async {
              updateParentState(index);
            },
            child: SizedBox(
              width: 60,
              child: Center(
                child: iconWidget,
              ),
            ),
          );
        }),
      ),
    );
  }
}
