import 'package:demo_books/model/Livre.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewLivre/AjouterLivreView.dart';
import '../viewLivre/ModifierLivreView.dart';
import '../../Widget/ConfirmDelete.dart'; // Importation de ConfirmDelete
import '../../Widget/CustomCard.dart';
import 'LivreDetailView.dart'; // Importation de CustomCard

class LivreListView extends StatelessWidget {
  final String userName;
  final String userRole;

  const LivreListView({Key? key, required this.userName, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Charger les livres
    Provider.of<LivreViewModel>(context, listen: false).chargerLivres();

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Livres',style: TextStyle(
          fontFamily: 'Kanit',
        )),
        actions: [
          if (userRole == 'admin') // L'option "Ajouter" est disponible uniquement pour les admins
            IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () {
                // Naviguer vers l'écran d'ajout de livre
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjouterLivreView(userName: userName, userRole: userRole)),
                );
              },
            )
        ],
      ),
      body: Consumer<LivreViewModel>(
        builder: (context, livreViewModel, child) {
          // Si la liste est vide, afficher un indicateur de chargement
          if (livreViewModel.livres.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Afficher la liste des livres avec CustomCard
          return ListView.builder(
            itemCount: livreViewModel.livres.length,
            itemBuilder: (context, index) {
              final livre = livreViewModel.livres[index];

              // Utilisation de CustomCard pour chaque livre
              return CustomCard(
                title: livre.nomLivre, // Titre du livre
                subtitle: 'Auteur: ' + livre.nomAuteur, // Auteur du livre
                userRole: userRole, // Rôle de l'utilisateur
                jacketPath: livre.jacketPath, // Optionnel : Si vous avez un chemin pour l'image du livre, vous pouvez le passer ici
                displayJacket: true, // Afficher l'image de couverture
                onTap: () {
                  // Action de tap sur la carte (modifier un livre pour les admins)
                  if (userRole == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LivreDetailView(livre: livre)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vous n\'avez pas les droits pour modifier ce livre.'),
                      ),
                    );
                  }
                },
                onEdit: () {
                  // Action de modification pour les admins
                  if (userRole == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ModifierLivreView(livre: livre)),
                    );
                  }
                },
                onDelete: () {
                  // Action de suppression avec confirmation pour les admins
                  if (userRole == 'admin') {
                    _deleteBookConfirmation(context, livre);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  // Fonction de confirmation de suppression, utilisée avec CustomCard
  void _deleteBookConfirmation(BuildContext context, Livre livre) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDelete(
          title: 'Confirmation',
          content: 'Voulez-vous vraiment supprimer le livre "${livre.nomLivre}" de l\'auteur "${livre.nomAuteur}" ?',
          onConfirm: () {
            // Supprimer le livre
            Provider.of<LivreViewModel>(context, listen: false)
                .supprimerLivre(livre.idLivre!);

            // Afficher un message de confirmation après suppression
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Livre supprimé avec succès')),
            );
          },
        );
      },
    );
  }
}
