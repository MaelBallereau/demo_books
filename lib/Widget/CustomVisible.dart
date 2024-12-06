import 'package:flutter/material.dart';

class CustomVisible extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator; // Paramètre de validation
  final bool isPasswordField; // Nouveau paramètre pour activer ou désactiver la visibilité
  final TextStyle? labelStyle; // New parameter for the label style

  const CustomVisible({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator, // Paramètre optionnel
    this.isPasswordField = true, // Par défaut, on considère que c'est un champ de mot de passe
    this.labelStyle, // Add the labelStyle parameter
  }) : super(key: key);

  @override
  _CustomVisibleState createState() => _CustomVisibleState();
}

class _CustomVisibleState extends State<CustomVisible> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: widget.labelStyle, // Apply the labelStyle if it's passed
        suffixIcon: widget.isPasswordField // La visibilité est activée seulement si isPasswordField est true
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null, // Pas de suffixIcon si ce n'est pas un champ de mot de passe
      ),
      obscureText: widget.isPasswordField && !_isPasswordVisible, // On applique la logique de visibilité du mot de passe
      validator: widget.validator,
    );
  }
}
