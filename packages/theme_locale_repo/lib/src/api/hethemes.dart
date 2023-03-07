import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeTheme {
  static ThemeData get light {
    return ThemeData(
      textTheme: GoogleFonts.ralewayTextTheme(),
      primaryColorDark: const Color(0xFF0097A7),
      primaryColorLight: const Color(0xFFB2EBF2),
      primaryColor: const Color(0xff349141),
      iconTheme: const IconThemeData(color: Color(0xff349141)),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(secondary: Colors.green),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF13B9FF),
      ),
      // colorScheme: ColorScheme.fromSwatch(
      //   accentColor: const Color(0xFF13B9FF),
      // ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF13B9FF);
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF13B9FF);
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF13B9FF);
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF13B9FF);
          }
          return null;
        }),
      ),
    );
  }

  static ThemeData get light_one {
    return ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(),
        primaryColorDark: const Color(0xFF0097A7),
        primaryColorLight: const Color(0xFFB2EBF2),
        primaryColor: const Color(0xFF00BCD4),
        colorScheme: const ColorScheme.light(secondary: Color(0xFF009688)),
        scaffoldBackgroundColor: const Color(0xFFE0F2F1),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(24),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ));
  }

  static ThemeData get dark {
    return ThemeData(
      textTheme: GoogleFonts.ralewayTextTheme(),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF13B9FF),
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: const Color(0xFF13B9FF),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF13B9FF);
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF13B9FF);
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF13B9FF);
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF13B9FF);
          }
          return null;
        }),
      ),
    );
  }
}
