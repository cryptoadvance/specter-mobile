import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'generated/locales.g.dart';

void main() {
  ThemeData _darkTheme = ThemeData(
    fontFamily: 'Mulish',
    accentColor: Colors.white,
    brightness: Brightness.dark,
    primaryColor: Colors.amber,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.amber,
      disabledColor: Colors.grey,
    )
  );

  ThemeData _lightTheme = ThemeData(
    fontFamily: 'Mulish',
    accentColor: Colors.grey[800],
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      disabledColor: Colors.grey,
    )
  );

  runApp(
    GetMaterialApp(
      title: "Specter Mobile",
      locale: Locale('en', 'US'),
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.dark,
      translationsKeys: AppTranslation.translations,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    )
  );
}
