import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur.dart';

class AuteurListView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    Provider.of<AuteurViewModel>(context,listen: false).chargerAuteurs();

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Auteurs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=> AjouterAuteurView()),
              );
            },
          )
        ],
  
      ),
      body: Consumer<AuteurViewModel>(
        builder: (context, auteurViewModel, child){
          if(auteurViewModel.auteurs.isEmpty){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: auteurViewModel.auteurs.length,
            itemBuilder: (context, index){
              final auteur = auteurViewModel.auteurs[index];
              return ListTile(
                title: Text(auteur.nomAuteur),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        Provider.of<AuteurViewModel>(context,listen: false).supprimerAuteur(auteur.idAuteur);
                      },
                    )
                  ],
                ),
              )
      ),
    )

  }
}