import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_rust/specter_rust.dart';
import 'app/routes/app_pages.dart';

void main() {
  print("Flutter app starting...");
  SpecterRust.sayHi();
  runApp(
    GetMaterialApp(
      title: "Specter Mobile",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
