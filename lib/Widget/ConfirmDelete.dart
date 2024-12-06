import 'package:flutter/material.dart';

class ConfirmDelete extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  ConfirmDelete({
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blueGrey,
      content: Text(content, style: TextStyle(color: Colors.white)),
      actions: [
        // Bouton "Non" avec couleur verte
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fermer la boîte de dialogue sans rien faire
          },
          child: Text('Non'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
        ),
        // Bouton "Oui" avec couleur rouge
        TextButton(
          onPressed: () {
            onConfirm(); // Exécuter la fonction passée en paramètre
            Navigator.of(context).pop(); // Fermer la boîte de dialogue
          },
          child: Text('Oui'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ],
    );
  }
}