import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../../Widget/CustomVisible.dart';

class AjouterUserView extends StatefulWidget {
  const AjouterUserView({super.key});

  @override
  _AjouterUserViewState createState() => _AjouterUserViewState();
}

class _AjouterUserViewState extends State<AjouterUserView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomUserController = TextEditingController();
  final TextEditingController _prenomUserController = TextEditingController();
  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _mdpUserController = TextEditingController();

  // Liste des rôles avec seulement "Administrateur" et "Utilisateur"
  final List<String> _roles = ['admin', 'user'];

  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = _roles.first; // Set a default role
  }

  @override
  void dispose() {
    _nomUserController.dispose();
    _prenomUserController.dispose();
    _loginUserController.dispose();
    _mdpUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter un Utilisateur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomUserController,
                  decoration: const InputDecoration(labelText: 'Nom de l\'Utilisateur'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom d\'utilisateur';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _prenomUserController,
                  decoration: const InputDecoration(labelText: 'Prénom de l\'Utilisateur'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prénom d\'utilisateur';
                    }
                    return null;
                  },
                ),
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
                // Utilisation du widget CustomVisible pour le champ mot de passe
                CustomVisible(
                  controller: _mdpUserController,
                  labelText: 'Mot de Passe',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    if(value.length < 5) {
                      return 'Le mot de passe doit contenir au moins 5 caractères';
                    }
                    return null;
                  },
                  isPasswordField: true, // Indique que c'est un champ de mot de passe
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Rôle'),
                  value: _selectedRole,
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un rôle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Ajouter un utilisateur via le ViewModel
                      Provider.of<UserViewModel>(context, listen: false).ajouterUser(
                        nomUser: _nomUserController.text,
                        prenomUser: _prenomUserController.text,
                        loginUser: _loginUserController.text,
                        mdpUser: _mdpUserController.text,
                        roleUser: _selectedRole ?? 'user', // Utiliser le rôle sélectionné
                      );
                      // Afficher un message de succès
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Utilisateur ajouté avec succès.')),
                      );
                      Navigator.pop(context); // Revenir à la liste des utilisateurs
                    }
                  },
                  child: const Text('Ajouter Utilisateur'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
