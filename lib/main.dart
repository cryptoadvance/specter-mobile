import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_rust/specter_rust.dart';
import 'app/routes/app_pages.dart';

void main() {
  print("Flutter app starting...");
  SpecterRust.sayHi();
  final result = SpecterRust.greet("Someone");
  print('Calling SpecterRust.greet() ${result}');

  final log = SpecterRust.runBitcoinDemo();
  print('Bitcoin demo: ${log}');

  runApp(
    GetMaterialApp(
      title: "Specter Mobile",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
