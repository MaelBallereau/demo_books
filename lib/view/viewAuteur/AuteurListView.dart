import 'package:demo_books/viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../HomeScreen.dart';
import 'AjouterAuteurView.dart';
import 'ModifierAuteurView.dart';
import '../../model/Auteur.dart';
import '../../Widget/ConfirmDelete.dart';

class AuteurListView extends StatelessWidget {
  final String userName;
  final String userRole;

  const AuteurListView({
    super.key,
    required this.userRole,
    required this.userName,
  }); // Constructeur avec userRole

  @override
  Widget build(BuildContext context) {
    // Charger les auteurs
    Provider.of<AuteurViewModel>(context, listen: false).chargerAuteurs();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des Auteurs',
          style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold), // Appliquer Kanit à l'AppBar
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(userName: userName, userRole: userRole)),
                  (route) => false,
            );
          },
        ),
        actions: [
          if (userRole == 'admin')
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                // Naviguer vers l'écran d'ajout d'auteur
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjouterAuteurView()),
                );
              },
            )
        ],
      ),
      body: Consumer<AuteurViewModel>(
        builder: (context, auteurViewModel, child) {
          // Si la liste est vide, afficher un indicateur de chargement
          if (auteurViewModel.auteurs.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Afficher la liste des auteurs
          return ListView.builder(
            itemCount: auteurViewModel.auteurs.length,
            itemBuilder: (context, index) {
              final auteur = auteurViewModel.auteurs[index];

              // Utilisation de Card pour chaque ListTile
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    auteur.nomAuteur,
                    style: TextStyle(
                      fontFamily: 'Kanit', // Appliquer Kanit sur le titre
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: userRole == 'admin' // Condition userRole pour afficher PopupMenuButton
                      ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModifierAuteurView(auteur: auteur),
                          ),
                        );
                      } else if (value == 'delete') {
                        // Afficher la boîte de dialogue de confirmation de suppression
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDelete(
                              title: 'Confirmation',
                              content:
                              'Voulez-vous vraiment supprimer cet auteur ?',
                              onConfirm: () {
                                auteurViewModel
                                    .supprimerAuteur(auteur.idAuteur!);
                              },
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Modifier',
                                style: TextStyle(fontFamily: 'Kanit'), // Appliquer Kanit sur le texte
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Supprimer',
                                style: TextStyle(fontFamily: 'Kanit'), // Appliquer Kanit sur le texte
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  )
                      : null, // Si userRole n'est pas 'admin', trailing est null
                ),
              );
            },
          );
        },
      ),
    );
  }
}
