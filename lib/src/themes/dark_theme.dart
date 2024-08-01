import 'package:flutter/material.dart';
import 'package:reservation/src/themes/colors.dart';
import 'package:reservation/src/utils/constants/font_size.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  dividerColor: AppColors.grey_10,
  colorScheme: const ColorScheme.dark().copyWith(
    background: AppColors.bgDark,
    primary: AppColors.opacity30Color1,
    secondary: AppColors.white,
    onBackground: AppColors.white,
    error: AppColors.red,
  ),
  scaffoldBackgroundColor: AppColors.bgDark,
  hintColor: AppColors.grey_6,
  textTheme: const TextTheme(
    // for title
    displayLarge: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.thirtySix,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.thirtyTwo,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.twentyEight,
      fontWeight: FontWeight.w700,
    ),
    headlineLarge: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.fourXL,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.twoXL,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.XL,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.MD,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.MD,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.SM,
      fontWeight: FontWeight.w400,
    ),
    // for body
    bodyLarge: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.XL,
    ),
    bodyMedium:
        TextStyle(color: AppColors.white, fontSize: KatappultFontSize.MD),
    bodySmall: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.SM,
    ),
    //for button label, caption, text underlined
    labelLarge: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.MD,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.SM,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: TextStyle(
      color: AppColors.white,
      fontSize: KatappultFontSize.SM,
      fontWeight: FontWeight.w400,
    ),
  ),
);
