import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ModifierUserView.dart';
import 'package:demo_books/Widget/ConfirmDelete.dart';
import '../HomeScreen.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import 'AjouterUserView.dart';
import '../../Widget/CustomCard.dart';

class UserListView extends StatelessWidget {
  final String userName;
  final String userRole;

  const UserListView({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    // Chargement des utilisateurs uniquement si nécessaire
    if (userViewModel.utilisateur.isEmpty) {
      Future.microtask(() => userViewModel.chargerUtilisateur());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des Utilisateurs',
          style: TextStyle(
            fontFamily: 'Kanit', // Apply the Kanit font to the AppBar title
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        actions: userRole == 'admin'
            ? [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterUserView()),
              );
            },
          ),
        ]
            : [],
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          // Display a message if there are no users
          if (userViewModel.utilisateur.isEmpty) {
            return const Center(child: Text('Aucun utilisateur disponible.'));
          }

          // Display the list of users
          return ListView.builder(
            itemCount: userViewModel.utilisateur.length,
            itemBuilder: (context, index) {
              final user = userViewModel.utilisateur[index];
              return CustomCard(
                title: '${user.nomUser} ${user.prenomUser}', // Full name of the user
                subtitle: user.loginUser, // Username of the user
                userRole: userRole, // Current user's role (admin or not)
                jacketPath: null, // No jacket for users
                displayJacket: false, // Disable image display
                leadingIcon: const Icon(
                  Icons.person_4_sharp, // Person icon for each user
                  size: 50,
                  color: Colors.blueAccent,
                ),
                onTap: () {
                  if (userRole == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModifierUserView(user: user),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vous n\'avez pas les droits pour modifier cet utilisateur.',
                        ),
                      ),
                    );
                  }
                },
                onEdit: () {
                  if (userRole == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModifierUserView(user: user)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vous n\'avez pas les droits pour modifier cet utilisateur.',
                        ),
                      ),
                    );
                  }
                },
                onDelete: () {
                  if (userRole == 'admin') {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDelete(
                        title: 'Confirmer la suppression',
                        content:
                        'Êtes-vous sûr de vouloir supprimer cet utilisateur ?',
                        onConfirm: () {
                          Provider.of<UserViewModel>(context, listen: false)
                              .supprimerUser(user.idUser);
                        },
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vous n\'avez pas les droits pour supprimer cet utilisateur.',
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
