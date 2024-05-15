import 'package:flutter/material.dart';
import 'package:memex/screens/enter_category_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drag and Drop Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EnterCategoryScreen(),
    );
  }
}

