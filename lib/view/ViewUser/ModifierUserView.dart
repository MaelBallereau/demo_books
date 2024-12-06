import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../../model/User.dart';
import './UserPasswordView.dart';
import '../../Widget/ConfirmModify.dart'; // Importez le widget ConfirmModify

class ModifierUserView extends StatefulWidget {
  final User user;

  const ModifierUserView({super.key, required this.user});

  @override
  _ModifierUserViewState createState() => _ModifierUserViewState();
}

class _ModifierUserViewState extends State<ModifierUserView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomUserController = TextEditingController();
  final TextEditingController _prenomUserController = TextEditingController();
  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _roleUserController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs avec les valeurs de l'utilisateur
    _nomUserController.text = widget.user.nomUser;
    _prenomUserController.text = widget.user.prenomUser;
    _loginUserController.text = widget.user.loginUser;
    _roleUserController.text = widget.user.roleUser;
  }

  @override
  void dispose() {
    _nomUserController.dispose();
    _prenomUserController.dispose();
    _loginUserController.dispose();
    _roleUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modifier l\'Utilisateur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ de texte pour le nom d'utilisateur
              TextFormField(
                controller: _nomUserController,
                decoration: const InputDecoration(labelText: 'Nom d\'Utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ de texte pour le prénom
              TextFormField(
                controller: _prenomUserController,
                decoration: const InputDecoration(labelText: 'Prénom d\'Utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom d\'utilisateur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ de texte pour le login
              TextFormField(
                controller: _loginUserController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un login';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Menu déroulant pour le rôle
              DropdownButtonFormField<String>(
                value: widget.user.roleUser,
                decoration: const InputDecoration(labelText: 'Rôle'),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'user', child: Text('User')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _roleUserController.text = value;
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un rôle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bouton pour enregistrer les modifications avec confirmation
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Affiche le dialogue de confirmation
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ConfirmModify(
                          title: 'Confirmer la modification',
                          content:
                          'Voulez-vous vraiment enregistrer les modifications pour cet utilisateur ?',
                          onConfirm: () {
                            // Exécute la logique de mise à jour
                            try {
                              Provider.of<UserViewModel>(context, listen: false)
                                  .mettreAJourUser(
                                idUser: widget.user.idUser,
                                nomUser: _nomUserController.text,
                                prenomUser: _prenomUserController.text,
                                loginUser: _loginUserController.text,
                                mdpUser: '', // Pas de modification du mot de passe ici
                                roleUser: _roleUserController.text,
                              );
                              Navigator.pop(context); // Ferme le dialogue
                              Navigator.pop(context); // Retourne à la liste des utilisateurs
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Utilisateur mis à jour avec succès.')),
                              );
                            } catch (e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erreur: $e')),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
                child: const Text('Enregistrer'),
              ),
              const SizedBox(height: 20),

              // Bouton pour changer le mot de passe
              ElevatedButton(
                onPressed: () {
                  // Redirige vers UserPasswordView
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserPasswordView(userId: widget.user.idUser)),
                  );
                },
                child: const Text(
                  'Changer le mot de passe ?',
                  style: TextStyle(color: Colors.white), // Texte en blanc
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Bouton rouge
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
