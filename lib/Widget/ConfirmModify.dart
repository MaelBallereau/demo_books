import 'package:flutter/material.dart';

class ConfirmModify extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  ConfirmModify({
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueGrey,
      content: Text(
        content,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        // Bouton "Annuler" avec une couleur grise
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fermer la boîte de dialogue sans rien faire
          },
          child: Text('Annuler'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
          ),
        ),
        // Bouton "Modifier" avec une couleur bleue
        TextButton(
          onPressed: () {
            onConfirm(); // Exécuter la fonction passée en paramètre
            Navigator.of(context).pop(); // Fermer la boîte de dialogue
          },
          child: Text('Modifier'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
        ),
      ],
    );
  }
}
