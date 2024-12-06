import 'dart:io';
import 'package:demo_books/model/Auteur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../model/Livre.dart';
import '../../Widget/ConfirmModify.dart'; // Importez le widget ConfirmModify

class ModifierLivreView extends StatefulWidget {
  final Livre livre;

  const ModifierLivreView({Key? key, required this.livre}) : super(key: key);

  @override
  _ModifierLivreViewState createState() => _ModifierLivreViewState();
}

class _ModifierLivreViewState extends State<ModifierLivreView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomLivreController = TextEditingController();
  String? _jacketPath;
  final imagePicker = ImagePicker();
  int? _selectedAuteurId; // ID de l'auteur sélectionné

  @override
  void initState() {
    super.initState();
    final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
    livreViewModel.chargerAuteurs(); // Charger la liste des auteurs
    _nomLivreController.text = widget.livre.nomLivre;
    _jacketPath = widget.livre.jacketPath; // Charger l'image actuelle si disponible
    _selectedAuteurId = widget.livre.idAuteur; // L'ID de l'auteur actuel du livre
  }

  void _deleteImage() {
    setState(() {
      _jacketPath = null; // Réinitialiser le chemin de l'image
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      final String originalPath = pickedFile.path;
      final String directory = originalPath.substring(0, originalPath.lastIndexOf('/'));
      final String newPath = '$directory/$timestamp.jpg';
      final File newFile = await File(originalPath).copy(newPath);

      setState(() {
        _jacketPath = newFile.path;
        print('Image path: $_jacketPath');
      });
    }
  }

  // Create a reusable button for image selection
  Widget _buildImageSelectionButton(String label, IconData icon, ImageSource source) {
    return ElevatedButton.icon(
      onPressed: () => _pickImage(source),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un Livre'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Champ pour le nom du livre
                TextFormField(
                  controller: _nomLivreController,
                  decoration: const InputDecoration(labelText: 'Nom du Livre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom de Livre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Liste déroulante pour choisir un auteur
                DropdownButtonFormField<int>(
                  value: _selectedAuteurId,
                  decoration: const InputDecoration(labelText: 'Sélectionner un Auteur'),
                  items: Provider.of<LivreViewModel>(context).auteurs.map((auteur) {
                    return DropdownMenuItem<int>(
                      value: auteur.idAuteur,
                      child: Text('${auteur.nomAuteur}'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedAuteurId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un auteur';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Buttons for picking image from gallery or camera
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildImageSelectionButton('Galerie', Icons.photo_library, ImageSource.gallery),
                    _buildImageSelectionButton('Caméra', Icons.camera, ImageSource.camera),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _deleteImage,
                  icon: const Icon(Icons.delete_forever, color: Colors.white),
                  label: const Text('Supprimer l\'image', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                const SizedBox(height: 20),

                // Affichage de l'image de couverture si elle existe
                _jacketPath != null
                    ? Image.file(
                  File(_jacketPath!),
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),

                // Bouton pour modifier le livre
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Affiche la boîte de dialogue de confirmation
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmModify(
                            title: 'Confirmer la modification',
                            content: 'Voulez-vous vraiment enregistrer les modifications pour ce livre ?',
                            onConfirm: () {
                              // Logique pour mettre à jour le livre
                              Provider.of<LivreViewModel>(context, listen: false)
                                  .mettreAJourLivre(
                                widget.livre.idLivre!,
                                _nomLivreController.text,
                                _selectedAuteurId!, // Utilisation de l'ID de l'auteur sélectionné
                                _jacketPath, // Inclure le nouveau jacketPath
                              );
                              Navigator.pop(context); // Fermer la boîte de dialogue// Retourner à la liste
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Livre modifié avec succès')),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Modifier'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
