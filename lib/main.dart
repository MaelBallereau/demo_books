import 'package:demo_books/view/ViewUser/UserLogin.dart';
import 'package:demo_books/viewmodel/viewModelLivre/LivreViewModel.dart';
import 'package:demo_books/viewmodel/viewModelUser/UserViewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'view/HomeScreen.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuteurViewModel()),
        ChangeNotifierProvider(create: (_) => LivreViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel(userName: '', userRole: '')),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bibiliothèque Numérique',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(),
    );
  }
}