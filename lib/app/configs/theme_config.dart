import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class ThemeConfig {
  static ThemeData lightTheme({required BuildContext context}) => ThemeData(
        textTheme: GoogleFonts.senTextTheme().apply(
            // decorationColor: Colors.red,
            // bodyColor: CupertinoColors.black,
            // displayColor: Colors.blue,
            ),
        useMaterial3: false,
        primaryColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Bords très arrondis
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: CupertinoColors.secondarySystemFill,
          labelStyle: const TextStyle(color: CupertinoColors.black),

          prefixStyle: const TextStyle(color: CupertinoColors.systemGrey),
          hintStyle: const TextStyle(color: Color.fromARGB(179, 92, 90, 90)),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.blue),
          // ),
        ),
        appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: CupertinoColors.white,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: CupertinoColors.black,
            ),
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            )),
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
//DARK THEME
  static ThemeData darkTheme({required BuildContext context}) =>
      ThemeData.dark().copyWith(
        primaryColor: CupertinoColors.systemFill,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: CupertinoColors.white,
          ),
        ).apply(
          decorationColor: Colors.red,
          bodyColor: CupertinoColors.white,
          displayColor: Colors.blue,
        ),
        scaffoldBackgroundColor: CupertinoColors.black,
        appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: CupertinoColors.black,
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: CupertinoColors.white),
            elevation: 0,
            iconTheme: IconThemeData(
              color: CupertinoColors.white,
            )),
        //scaffoldBackgroundColor: CupertinoColors.black,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: CupertinoColors.systemFill.darkColor,
          labelStyle: const TextStyle(color: CupertinoColors.white),

          prefixStyle: const TextStyle(color: CupertinoColors.systemGrey3),
          hintStyle: const TextStyle(color: Colors.white70),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CupertinoColors.darkBackgroundGray,
            //textStyle: Tex
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor:
              WidgetStateProperty.all(CupertinoColors.darkBackgroundGray),
        ),
        //primarySwatch: Colors.green,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: CupertinoColors.darkBackgroundGray,
              secondaryContainer: CupertinoColors.darkBackgroundGray,
              surface: CupertinoColors.white,
              onPrimary: CupertinoColors.systemGrey5.darkColor,
              secondary: Colors.transparent,
              onSecondary: CupertinoColors.black,
              //: Colors.blue,
            ),
      );
}
