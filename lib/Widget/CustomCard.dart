import 'dart:io';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;          // Titre de la carte
  final String subtitle;       // Sous-titre de la carte
  final String? userRole;      // Rôle de l'utilisateur (admin ou autre)
  final String? jacketPath;    // Chemin de la couverture du livre
  final bool displayJacket;    // Indicateur pour afficher ou non la jacket
  final VoidCallback? onTap;   // Callback pour l'action au tap
  final VoidCallback? onDelete; // Callback pour l'action de suppression
  final VoidCallback? onEdit;  // Callback pour l'action de modification
  final Icon? leadingIcon;     // Nouveau paramètre pour l'icône de gauche

  const CustomCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.userRole,
    this.jacketPath,
    this.displayJacket = false,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.leadingIcon, // Paramètre pour l'icône de gauche
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[350], // Couleur de fond de la carte
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: displayJacket && jacketPath != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8.0), // Bordures arrondies
          child: Image.file(
            File(jacketPath!), // Charger l'image depuis un fichier
            width: 50,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                size: 50,
                color: Colors.red,
              ); // Icône d'erreur en cas d'image manquante
            },
          ),
        )
            : leadingIcon ?? const Icon(
          Icons.book, // Icône par défaut si jacketPath est null
          size: 50,
          color: Colors.blueAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Kanit', // Appliquer la police Kanit
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Kanit', // Appliquer la police Kanit
            fontSize: 14,
          ),
        ),
        onTap: () {
          if (userRole == 'admin' && onTap != null) {
            onTap!();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vous n\'avez pas les droits de modifications.'),
              ),
            );
          }
        },
        trailing: userRole == 'admin' // Modifier/Supprimer visible uniquement pour les admins
            ? PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit' && onEdit != null) {
              onEdit!();
            } else if (value == 'delete' && onDelete != null) {
              onDelete!();
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Modifier', style: TextStyle(fontFamily: 'Kanit')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer', style: TextStyle(fontFamily: 'Kanit')),
                  ],
                ),
              ),
            ];
          },
        )
            : null,
      ),
    );
  }
}
