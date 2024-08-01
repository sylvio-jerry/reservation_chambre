import 'package:flutter/material.dart';
import 'package:reservation/src/themes/colors.dart';
import 'package:reservation/src/utils/constants/font_size.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  dividerColor: AppColors.grey_10,
  colorScheme: const ColorScheme.light().copyWith(
    background: AppColors.white,
    primary: AppColors.bgPurple,
    secondary: AppColors.color1,
    onBackground: AppColors.black,
    error: AppColors.red,
  ),
  scaffoldBackgroundColor: AppColors.white,
  hintColor: AppColors.grey_2,
  textTheme: const TextTheme(
    // for title
    displayLarge: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.thirtySix,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.thirtyTwo,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.twentyEight,
      fontWeight: FontWeight.w700,
    ),
    headlineLarge: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.fourXL,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.twoXL,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.XL,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.MD,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.MD,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.SM,
      fontWeight: FontWeight.w400,
    ),
    // for body
    bodyLarge: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.XL,
    ),
    bodyMedium:
        TextStyle(color: AppColors.black, fontSize: KatappultFontSize.MD),
    bodySmall: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.SM,
    ),
    //for button label, caption, text underlined
    labelLarge: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.MD,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.SM,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: TextStyle(
      color: AppColors.black,
      fontSize: KatappultFontSize.SM,
      fontWeight: FontWeight.w400,
    ),
  ),
  iconTheme: const IconThemeData(
    color: AppColors.transparent,
  ),
);
