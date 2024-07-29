import 'package:flutter/material.dart';
import 'package:population/services.dart';
import 'package:population/setPseudo.dart';

import 'homePage.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alert App',
      home: UserPreferences.getPseudo() == null ? SetPseudoScreen() : const HomeScreen(),
    );
  }
}
