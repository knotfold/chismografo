import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Amigos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.face),
        onPressed: () {
          showDialog(
            context: context,
            child: SolicitudesAmistad(),
          );
        },
      ),
      appBar: myAppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(
              'Amigos',
              style: TextStyle(fontSize: 25),
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('usuarios')
                  .where('amigos', arrayContains: controller.usuario.documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                List<DocumentSnapshot> documents = snapshot.data.documents;
                print(documents.length);
                return documents.isEmpty
                    ? Text(
                        'No tienes amigos :(, Haz click en el botón de abajo para buscar mas amigos')
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          Usuario usuario = Usuario.fromDS(documents[index]);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(usuario.foto),
                            ),
                            title: Text(usuario.nombre),
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SolicitudesAmistad extends StatefulWidget {
  @override
  _SolicitudesAmistadState createState() => _SolicitudesAmistadState();
}

class _SolicitudesAmistadState extends State<SolicitudesAmistad> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Solicitudes de Amistad'),
            StreamBuilder(
              stream: controller.usuario.reference
                  .collection('solicitudes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                List<DocumentSnapshot> documents = snapshot.data.documents;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    Usuario usuario = Usuario.fromDS(documents[index]);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(usuario.foto),
                      ),
                      title: Text(usuario.nombre),
                      trailing: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.check),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_forever),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            FloatingActionButton.extended(
              onPressed: () => showSearch(),
              icon: Icon(Icons.search),
              label: Text('Buscar Amigos'),
            )
          ],
        ),
      ),
    );
  }
}
