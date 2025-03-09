import 'package:flutter/material.dart';
import 'package:flutter_exam/api/api_service.dart';
import 'package:flutter_exam/di/setupLocator.dart';
import 'package:flutter_exam/providers/app_provider.dart';
import 'package:flutter_exam/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApiProvider(locator<ApiService>()),
      child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen()),
    );
  }
}
