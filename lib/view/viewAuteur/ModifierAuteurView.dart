import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../model/Auteur.dart';
import '../../Widget/ConfirmModify.dart'; // Import de la boîte de dialogue de confirmation

class ModifierAuteurView extends StatelessWidget {
  final Auteur auteur;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAuteurController = TextEditingController();

  ModifierAuteurView({required this.auteur});

  @override
  Widget build(BuildContext context) {
    _nomAuteurController.text = auteur.nomAuteur;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier un Auteur',
          style: TextStyle(fontFamily: 'Kanit'), // Appliquer Kanit à l'AppBar
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ de texte pour le nom de l'auteur avec police Kanit
              TextFormField(
                controller: _nomAuteurController,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'auteur',
                  labelStyle: TextStyle(fontFamily: 'Kanit'), // Label avec Kanit
                ),
                style: TextStyle(fontFamily: 'Kanit'), // Texte de l'input avec Kanit
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'auteur';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Bouton de modification avec texte en Kanit
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Afficher la boîte de dialogue de confirmation
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmModify(
                        title: 'Confirmation',
                        content: 'Êtes-vous sûr de vouloir modifier cet auteur ?',
                        onConfirm: () {
                          Provider.of<AuteurViewModel>(context, listen: false)
                              .mettreAJourAuteur(auteur.idAuteur!, _nomAuteurController.text);
                          Navigator.pop(context); // Revenir à l'écran précédent
                        },
                      ),
                    );
                  }
                },
                child: Text(
                  'Modifier',
                  style: TextStyle(fontFamily: 'Kanit'), // Texte du bouton avec Kanit
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
