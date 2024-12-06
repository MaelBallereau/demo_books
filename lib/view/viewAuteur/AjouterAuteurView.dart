import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';

class AjouterAuteurView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAuteurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter un Auteur',
          style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold), // Appliquer Kanit à l'AppBar
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomAuteurController,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'auteur',
                  labelStyle: TextStyle(fontFamily: 'Kanit'), // Appliquer Kanit sur le label
                ),
                style: TextStyle(fontFamily: 'Kanit'), // Appliquer Kanit sur le texte du champ
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'auteur';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<AuteurViewModel>(context, listen: false)
                        .ajouterAuteur(_nomAuteurController.text);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Ajouter',
                  style: TextStyle(fontFamily: 'Kanit'), // Appliquer Kanit sur le texte du bouton
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
