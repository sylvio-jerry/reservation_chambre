import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation/src/navigation/app_route.dart';
import 'package:reservation/src/pages/home/home_page.dart';
import 'package:reservation/src/themes/app_theme.dart';
import 'package:reservation/src/themes/theme_provider.dart';
import 'package:reservation/src/utils/constants/common_constants.dart';
import 'package:reservation/src/utils/constants/language.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    return MaterialApp(
      title: CommonConst.APP_TITLE,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale(Language.LANG_FR),
        Locale(Language.LANG_EN),
      ],
      home: const HomePage(),
      routes: AppRoutes.routes,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: appThemeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
