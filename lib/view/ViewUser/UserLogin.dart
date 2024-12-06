import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../HomeScreen.dart';
import '../../Widget/CustomVisible.dart'; // Importer le widget CustomVisible

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connexion',
          style: TextStyle(
            fontFamily: 'Kanit', // Ensure the font is applied here
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Texte ajouté au-dessus des champs
            const Text(
              'Bibliothèque',
              style: TextStyle(
                fontFamily: 'Kanit', // Font updated here
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20), // Espacement entre le texte et les champs
            TextFormField(
              controller: _loginController,
              decoration: const InputDecoration(
                labelText: 'Login',
                labelStyle: TextStyle(fontFamily: 'Kanit'), // Apply Kanit to the label text
              ),
            ),
            const SizedBox(height: 20), // Espacement entre les champs
            CustomVisible(
              controller: _passwordController,
              labelText: 'Mot de passe',
              labelStyle: TextStyle(fontFamily: 'Kanit'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? errorMessage = await userViewModel.login(
                  _loginController.text.trim(),
                  _passwordController.text.trim(),
                );

                if (errorMessage != null) {
                  // Afficher un message d'erreur en cas d'échec de connexion
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        errorMessage,
                        style: const TextStyle(fontFamily: 'Kanit'), // Apply Kanit here as well
                      ),
                    ),
                  );
                } else {
                  // Connexion réussie, on récupère le nom et le rôle de l'utilisateur
                  final String userName = userViewModel.userName;
                  final String userRole = userViewModel.userRole;

                  // Redirection vers HomeScreen en passant le rôle de l'utilisateur
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        userName: userName,
                        userRole: userRole,
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(fontFamily: 'Kanit'), // Apply Kanit to the button text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
