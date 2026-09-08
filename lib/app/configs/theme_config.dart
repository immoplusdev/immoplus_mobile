import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class ThemeConfig {
  static ThemeData lightTheme({required BuildContext context}) => ThemeData(
        textTheme: AppTypography.lightTextTheme(),
        useMaterial3: false,
        primaryColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: AppTypography.button,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: CupertinoColors.secondarySystemFill,
          labelStyle: AppTypography.bodyMedium.copyWith(color: CupertinoColors.black),
          prefixStyle: AppTypography.bodyMedium.copyWith(color: CupertinoColors.systemGrey),
          hintStyle: AppTypography.bodyMedium.copyWith(color: const Color.fromARGB(179, 92, 90, 90)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: CupertinoColors.white,
          titleTextStyle: AppTypography.h4.copyWith(
            color: CupertinoColors.black,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(AppColors.primary),
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              secondaryContainer: CupertinoColors.white,
              onPrimary: CupertinoColors.white,
              surface: CupertinoColors.systemGrey,
              secondary: const Color.fromARGB(255, 229, 228, 228),
              onSecondary: CupertinoColors.white,
            ),
      );

  // DARK THEME
  static ThemeData darkTheme({required BuildContext context}) =>
      ThemeData.dark().copyWith(
        primaryColor: CupertinoColors.systemFill,
        textTheme: AppTypography.darkTextTheme(),
        scaffoldBackgroundColor: CupertinoColors.black,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: CupertinoColors.black,
          titleTextStyle: AppTypography.h4.copyWith(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: CupertinoColors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: CupertinoColors.systemFill.darkColor,
          labelStyle: AppTypography.bodyMedium.copyWith(color: CupertinoColors.white),
          prefixStyle: AppTypography.bodyMedium.copyWith(color: CupertinoColors.systemGrey3),
          hintStyle: AppTypography.bodyMedium.copyWith(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CupertinoColors.darkBackgroundGray,
            textStyle: AppTypography.button,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor:
              WidgetStateProperty.all(CupertinoColors.darkBackgroundGray),
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: CupertinoColors.darkBackgroundGray,
              secondaryContainer: CupertinoColors.darkBackgroundGray,
              surface: CupertinoColors.white,
              onPrimary: CupertinoColors.systemGrey5.darkColor,
              secondary: Colors.transparent,
              onSecondary: CupertinoColors.black,
            ),
      );
}

class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.button.copyWith(
        color: AppColors.text0B1C30,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }
}
