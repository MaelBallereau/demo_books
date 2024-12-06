import 'package:flutter/material.dart';
import 'dart:io';
import '../../model/Livre.dart';

class LivreDetailView extends StatelessWidget {
  final Livre livre; // The book whose details we want to show

  const LivreDetailView({Key? key, required this.livre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Voici le détail du livre : " + livre.nomLivre,
          style: TextStyle(
            fontFamily: 'Kanit', // Applique la police Kanit à la barre d'applications
          ),
        ),
      ),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Affiche l'image ou un placeholder si l'image n'est pas disponible
              if (livre.jacketPath != null && livre.jacketPath!.isNotEmpty)
                Center(
                  child: livre.jacketPath!.startsWith('/data') // Vérifie si c'est un fichier local
                      ? Image.file(
                    File(livre.jacketPath!),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                      : SizedBox.shrink(),
                )
              else
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey[600],
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Titre: ${livre.nomLivre}',
                style: const TextStyle(
                  fontFamily: 'Kanit', // Applique la police Kanit au titre du livre
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Auteur: ${livre.nomAuteur}',
                style: const TextStyle(
                  fontFamily: 'Kanit', // Applique la police Kanit au nom de l'auteur
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
