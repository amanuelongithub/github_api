import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:git_hub_clone/src/controllers/leading_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/pages/home_page.dart';

void main() {
  Get.put(LeadingController());
  setToken();
  runApp(const MyApp());
}

setToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('token', 'Your Token here');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
