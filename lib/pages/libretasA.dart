import 'package:flutter/material.dart';
import 'package:trivia_form/pages/pages.dart';

import 'package:trivia_form/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_form/services/services.dart';
import 'package:provider/provider.dart';

class LibretasA extends StatelessWidget {
  final Home home;
  LibretasA({this.home});
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: StreamBuilder(
        stream: Firestore.instance
            .collection('formularios')
            .where('invitaciones', arrayContains: controller.usuario.usuario)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return FloatingActionButton.extended(
            heroTag: 'btnA1',
            onPressed: () {
              documents.isEmpty
                  ? null
                  : showDialog(
                      context: context,
                      child: Dialog(
                        child: Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              FormularioModel formularioModel =
                                  FormularioModel.fromDS(documents[index]);
                              return ListTile(
                                leading: Icon(Icons.book),
                                title: Text(formularioModel.nombre),
                                subtitle: Text(formularioModel.creadorUsuario),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () async {
                                        controller.toFillForm = formularioModel;
                                        Navigator.of(context).pushNamed(
                                            '/responderLibreta',
                                            arguments: formularioModel);
                                      },
                                      icon: Icon(Icons.check),
                                    ),
                                    IconButton(
                                      onPressed: () async {},
                                      icon: Icon(Icons.cancel),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
            },
            label:
                Text(documents.isEmpty ? 'Sin solicitudes' : 'Nueva solicitud'),
            icon: documents.isEmpty
                ? Icon(
                    Icons.tag_faces,
                    size: 30,
                  )
                : Stack(
                    children: <Widget>[
                      Container(
                          child: Icon(
                            Icons.fiber_new,
                            size: 30,
                          ),
                          width: 30,
                          height: 30),
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(left: 20),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: yemahuevo),
                      )
                    ],
                  ),
          );
        },
      ),
      appBar: myAppBar(controller, context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Libretas Amigos',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('formularios')
                      .where('usuarios',
                          arrayContains: controller.usuario.usuario)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();
                    List<DocumentSnapshot> documents = snapshot.data.documents;
                    return ListView.builder(
                        //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // crossAxisCount:1,crossAxisSpacing: 10,childAspectRatio: 2.5,mainAxisSpacing: 5,),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          FormularioModel formularioModel =
                              FormularioModel.fromDS(documents[index]);
                          return Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            height: 120,
                            child: Card(
                              color: Colors.transparent,
                                elevation: 0,
                                margin: EdgeInsets.only(
                                    top: 10, left: 5, right: 5, bottom: 10),
                                child: Container(
                                 // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),gradient:LinearGradient(colors: [Color(0xFF0f2027),Color(0xFF203a43),Color(0xFF2c5364)],begin: Alignment.topLeft,end: Alignment.topRight,tileMode: TileMode.clamp )),
                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),gradient:LinearGradient(colors: [Color(0xFF0f2027),Color(0xFF021B79),Color(0xFF0575E6)],begin: Alignment.topLeft,end: Alignment.topRight,tileMode: TileMode.clamp )),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.only(left: 10,right: 10),
                                          onTap: () {
                                            controller.toFillForm = formularioModel;
                                            Navigator.of(context)
                                                .pushNamed('/libretaDetalles');
                                          },
                                          leading: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                child: FadeInImage(
                                                  alignment: Alignment.centerLeft,
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      AssetImage('assets/gudtech.jpg'),
                                                  width: 50,
                                                  height: 50,
                                                  image: NetworkImage(
                                                      formularioModel.creadorfoto),
                                                ),
                                                
                                              ),
                                              Divider(color: Colors.white,)
                                            ],
                                          ),
                                          title: Text(formularioModel.nombre,style: TextStyle(color: Colors.white),),
                                          subtitle:
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(formularioModel.creadorUsuario,style: TextStyle(color: Colors.white24)),
                                                SizedBox(height:5),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.end,
                                                     crossAxisAlignment: CrossAxisAlignment.end,
                                                     mainAxisSize: MainAxisSize.min,
                                                     children: <Widget>[
                                                         Text('Participantes: ',style: TextStyle(color: Colors.white30),),
                                                       Text(
                                                  '${formularioModel.usuarios.length} / 25',style: TextStyle(color: Colors.white30),),
                                                     ],
                                                   ),
                                            
                                                ],
                                              ),
                                          trailing: Icon(Icons.arrow_forward_ios,size: 15,color: Colors.white,),
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                                // ListTile(
                                //   onTap: () {
                                //     controller.toFillForm = formularioModel;
                                //     Navigator.of(context)
                                //         .pushNamed('/libretaDetalles');
                                //   },
                                //   title: Text(
                                //     formularioModel.nombre,
                                //     style: TextStyle(fontSize: 20),
                                //   ),
                                //   subtitle: Text(formularioModel.creadorUsuario),
                                //   trailing: Text(
                                //       '${formularioModel.usuarios.length} / 25'),
                                // ),
                                ),
                          );
                          //     GestureDetector(
                          //   onTap: () {
                          //     controller.toFillForm = formularioModel;
                          //     Navigator.of(context)
                          //         .pushNamed('/libretaDetalles');
                          //   },
                          //   child: Container(

                          //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient: LinearGradient(colors: ([colorg1,colorg2]),begin: Alignment.topRight,end: Alignment.topLeft)),
                          //     child: Column(

                          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: <Widget>[
                          //         Container(
                          //           child: Text(formularioModel.creadorUsuario),
                          //           alignment: Alignment.topLeft,
                          //         ),

                          //         Container(
                          //           child: Text(formularioModel.nombre,style: TextStyle(color: Colors.white)),
                          //           alignment: Alignment.center,

                          //         ),
                          //         Container(
                          //           margin: EdgeInsets.only(left: 175,right: 2),
                          //           padding: EdgeInsets.only(right:5),
                          //           decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                          //           child:  Text('${formularioModel.usuarios.length} / 25'),
                          //           alignment: Alignment.bottomRight,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
