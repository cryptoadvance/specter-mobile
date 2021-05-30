import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:specter_rust/specter_rust.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // TODO: remove
    final rustGreeting = SpecterRust.greet("Username");

    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Rust: ${rustGreeting}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
