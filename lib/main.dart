import 'package:flutter/material.dart';
import 'package:medical_animal/core/provider/map_provider.dart';
import 'package:medical_animal/ui/pages/auth/sign_in_page.dart';
import 'package:medical_animal/ui/pages/home/main_page.dart';
import 'package:medical_animal/ui/pages/home/maps_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MapProvider(),
        ),
      ],
      child: const MaterialApp(
        title: "Skripsi",
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}
