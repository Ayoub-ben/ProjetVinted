import 'package:flutter/material.dart';
import 'package:vinted/ProfilPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vinted/login_register_page.dart';
import 'AchatPage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      primarySwatch: Colors.orange,
      ),
      home: LoginPage(),
    );
  }
}


