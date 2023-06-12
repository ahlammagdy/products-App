import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/my_home_page.dart';
import 'screens/products.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider<Products>(
      create: (_) => Products(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.orange,
          canvasColor: const Color.fromRGBO(255, 238, 219, 1)),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
