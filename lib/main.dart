import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  print("Flutter app starting...");
  runApp(
    GetMaterialApp(
      title: "Specter Mobile",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
