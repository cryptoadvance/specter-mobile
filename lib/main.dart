import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/utils.dart';

import 'app/routes/app_pages.dart';
import 'generated/locales.g.dart';

void main() {
  ThemeData _darkTheme = ThemeData(
    fontFamily: 'Mulish',
    accentColor: Utils.hexToColor('#F9F9F9'),
    brightness: Brightness.dark,
    primaryColor: Colors.amber,
    hintColor: Utils.hexToColor('#A3B2C2'),
    scaffoldBackgroundColor: Utils.hexToColor('#0E1927'),
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
      title: 'Narwhale Mobile',
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
