import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/shared/shared.dart';

class CustomSearchDelegate extends SearchDelegate {
  var query1 = '';
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var stream = Firestore.instance
        .collection('usuarios')
        .where('usuarioSearch', isEqualTo: query.toLowerCase())
        .snapshots();

    print(query);
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data.documents.length == 0) {
          return Column(
            children: <Widget>[
              Text(
                "No se encontraron resultados",
              ),
            ],
          );
        } else {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return AmigoTile(
                usuario: UsuarioModel.fromDocumentSnapshot(documents[index]),
              );
            },
          );
        }
      },
    );
  }

  

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
