import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../../Widget/CustomVisible.dart';
import '../../Widget/ConfirmModify.dart'; // Import the ConfirmModify widget

class UserPasswordView extends StatefulWidget {
  final int userId; // User ID
  const UserPasswordView({Key? key, required this.userId}) : super(key: key);

  @override
  _UserPasswordViewState createState() => _UserPasswordViewState();
}

class _UserPasswordViewState extends State<UserPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _ancienMotDePasseController = TextEditingController();
  final _nouveauMotDePasseController = TextEditingController();
  final _confirmationMotDePasseController = TextEditingController();

  @override
  void dispose() {
    _ancienMotDePasseController.dispose();
    _nouveauMotDePasseController.dispose();
    _confirmationMotDePasseController.dispose();
    super.dispose();
  }

  void _showConfirmModify(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmModify(
          title: 'Confirmer la modification',
          content: 'Êtes-vous sûr de vouloir modifier le mot de passe ?',
          onConfirm: () async {
            if (_formKey.currentState!.validate()) {
              final userViewModel = Provider.of<UserViewModel>(context, listen: false);
              try {
                await userViewModel.changerMotDePasse(
                  widget.userId,
                  _nouveauMotDePasseController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mot de passe changé avec succès')),
                );
                Navigator.pop(context); // Close the dialog
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur : $e')),
                );
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Changer le mot de passe',
          style: TextStyle(fontFamily: 'Kanit', color: Colors.white), // Apply Kanit font to AppBar title
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text field for the new password
              CustomVisible(
                controller: _nouveauMotDePasseController,
                labelText: 'Nouveau mot de passe',
                labelStyle: const TextStyle(fontFamily: 'Kanit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nouveau mot de passe';
                  }
                  if(value.length < 5) {
                    return 'Le mot de passe doit contenir au moins 5 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Text field for confirming the new password
              CustomVisible(
                controller: _confirmationMotDePasseController,
                labelText: 'Confirmez le nouveau mot de passe',
                isPasswordField: true,
                labelStyle: const TextStyle(fontFamily: 'Kanit'),
                validator: (value) {
                  if (value != _nouveauMotDePasseController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Button to trigger the confirmation dialog
              ElevatedButton(
                onPressed: () {
                  _showConfirmModify(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blueGrey,
                ),
                child: const Text(
                  'Changer le mot de passe',
                  style: TextStyle(
                    fontFamily: 'Kanit', // Apply Kanit font to the button text
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
