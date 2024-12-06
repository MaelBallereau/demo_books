import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import 'package:image_picker/image_picker.dart';

class AjouterLivreView extends StatefulWidget {
  final String userName;
  final String userRole;

  const AjouterLivreView(
      {Key? key, required this.userName, required this.userRole})
      : super(key: key);

  @override
  _AjouterLivreViewState createState() => _AjouterLivreViewState();
}

class _AjouterLivreViewState extends State<AjouterLivreView> {
  final _formKey = GlobalKey<FormState>();
  String? _jacketPath;
  final imagePicker = ImagePicker();
  final TextEditingController _nomLivreController = TextEditingController();
  int? _selectedAuteurId; // Variable pour stocker l'ID de l'auteur sélectionné

  @override
  void initState() {
    super.initState();
    // Charger les auteurs lors de l'initialisation de la vue
    Provider.of<LivreViewModel>(context, listen: false).chargerAuteurs();
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
      final String directory =
      originalPath.substring(0, originalPath.lastIndexOf('/'));

      final String newPath = '$directory/$timestamp.jpg';

      final File newFile = await File(originalPath).copy(newPath);

      setState(() {
        _jacketPath = newFile.path;
        print('Image path: $_jacketPath');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter un Livre',
          style: TextStyle(fontFamily: 'Kanit'), // Appliquer Kanit à l'AppBar
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nom du livre avec police Kanit
              TextFormField(
                controller: _nomLivreController,
                decoration: InputDecoration(
                  labelText: 'Nom du Livre',
                  labelStyle: TextStyle(fontFamily: 'Kanit'), // Label avec Kanit
                ),
                style: TextStyle(fontFamily: 'Kanit'), // Texte de l'input avec Kanit
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de Livre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // DropdownButton pour sélectionner un auteur avec Kanit
              DropdownButtonFormField<int>(
                value: _selectedAuteurId,
                decoration: InputDecoration(
                  labelText: 'Sélectionner un Auteur',
                  labelStyle: TextStyle(fontFamily: 'Kanit'), // Label avec Kanit
                ),
                items: Provider.of<LivreViewModel>(context)
                    .auteurs
                    .map((auteur) {
                  return DropdownMenuItem<int>(
                    value: auteur.idAuteur,
                    child: Text(
                      auteur.nomAuteur,
                      style: TextStyle(fontFamily: 'Kanit'), // Texte de l'item avec Kanit
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAuteurId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un auteur';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    label: const Text(
                      'Galerie',
                      style: TextStyle(color: Colors.white, fontFamily: 'Kanit'), // Texte avec Kanit
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera, color: Colors.white),
                    label: const Text(
                      'Caméra',
                      style: TextStyle(color: Colors.white, fontFamily: 'Kanit'), // Texte avec Kanit
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _jacketPath != null
                  ? Image.file(
                File(_jacketPath!),
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              )
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _deleteImage(),
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                label: const Text(
                  'Supprimer l\'image',
                  style: TextStyle(color: Colors.white, fontFamily: 'Kanit'), // Texte avec Kanit
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Récupérer le nom du livre et l'ID de l'auteur sélectionné
                    String nomLivre = _nomLivreController.text;

                    // Appeler le ViewModel pour ajouter le livre
                    Provider.of<LivreViewModel>(context, listen: false)
                        .ajouterLivre(nomLivre, _selectedAuteurId!, _jacketPath)
                        .then((_) {
                      // Fermer la vue après l'ajout réussi
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text(
                  'Ajouter',
                  style: TextStyle(fontFamily: 'Kanit'), // Texte avec Kanit
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
