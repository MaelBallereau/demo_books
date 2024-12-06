import 'package:demo_books/view/viewAuteur/AuteurListView.dart';
import 'package:demo_books/view/viewLivre/AjouterLivreView.dart';
import 'package:demo_books/view/viewLivre/LivreListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../viewmodel/viewModelUser/UserViewModel.dart';
import 'ViewUser/UserListView.dart';
import 'ViewUser/UserLogin.dart';

class HomeScreen extends StatefulWidget {
  final String userName; // Champ pour stocker le nom de l'utilisateur
  final String userRole; // Champ pour stocker le rôle de l'utilisateur

  const HomeScreen(
      {super.key,
        required this.userName,
        required this.userRole}); // Passer le nom de l'utilisateur et son rôle

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Changer les livres au démarrage
    Future.microtask(() {
      final livreViewModel =
      Provider.of<LivreViewModel>(context, listen: false);
      livreViewModel.chargerLivres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque Numérique',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Kanit', // Apply Kanit font to the AppBar title
            )),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ), //AppBar
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100, // Ajuste la hauteur du DrawerHeader
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Padding(
                padding: EdgeInsets.all(32), // Ajuste le padding interne
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit', // Apply Kanit font to the menu title
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.userRole ==
                'admin') // Vérifie si l'utilisateur est un admin
              ListTile(
                leading: const Icon(Icons.add, color: Colors.deepPurple),
                title: const Text(
                  'Ajouter un livre',
                  style: TextStyle(fontFamily: 'Kanit'), // Apply Kanit font
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AjouterLivreView(
                        userName: widget.userName, userRole: widget.userRole),
                  ));
                },
              ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.deepPurple),
              title: const Text(
                'Gérer les auteurs',
                style: TextStyle(fontFamily: 'Kanit'), // Apply Kanit font
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AuteurListView(
                      userName: widget.userName, userRole: widget.userRole),
                ));
              },
            ),
            if (widget.userRole == 'admin')
              ListTile(
                leading: const Icon(Icons.admin_panel_settings,
                    color: Colors.deepPurple),
                title: const Text(
                  'Gérer les utilisateurs',
                  style: TextStyle(fontFamily: 'Kanit'), // Apply Kanit font
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangeNotifierProvider<UserViewModel>(
                          create: (context) => UserViewModel(
                              userName: widget.userName,
                              userRole: widget.userRole),
                          child: UserListView(
                              userName: widget.userName,
                              userRole: widget.userRole),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: LivreListView(
                userName: widget.userName,
                userRole: widget.userRole,
              )),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Connecté en tant que : ${widget.userRole}', // Affiche le nom de l'utilisateur
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Kanit', // Apply Kanit font to the connected user text
                  ),
                ),
                const SizedBox(height: 10), // Espacement
                ElevatedButton(
                  onPressed: () async {
                    // Appel de la méthode logout dans le UserViewModel
                    await Provider.of<UserViewModel>(context, listen: false)
                        .logout();

                    // Redirection vers l'écran de login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Se déconnecter',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Kanit', // Apply Kanit font to the button text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
