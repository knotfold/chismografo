import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/shared/shared.dart';

class LibretaDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    List<Pregunta> preguntas = controller.toFillForm.preguntas;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Preguntas',style: TextStyle(color: Colors.white),),
       backgroundColor: buttonColors,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
            icon: Icon(Icons.stars),
            color: Colors.yellow[500],
            onPressed: () => null,

          ),
              Text(
                controller.usuario.coins.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
              ),
                SizedBox(width: 10),
          IconButton(
            onPressed: () {
                showDialog(
                  context: context,
                  child: Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: backgroundColor,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Usuarios',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          controller.toFillForm.usuarios.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('No hay usuarios participando'),
                              )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.toFillForm.usuarios.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(
                                      '-' +
                                          controller.toFillForm.usuarios[index],
                                          style: TextStyle(fontSize: 15),
                                    );
                                  },
                                ),
                          Text(
                            'Invitados',
                            style: TextStyle(fontSize: 20),
                          ),
                         
                          controller.toFillForm.invitaciones.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('No hay usuarios invitados'),
                              )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.toFillForm.invitaciones.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(
                                      '-' +
                                          controller
                                              .toFillForm.invitaciones[index],
                                    );
                                  },
                                ),
                               controller.usuario.usuario == controller.toFillForm.creadorUsuario || controller.toFillForm.priv ? FloatingActionButton.extended(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      child: Dialog(
                                        backgroundColor: backgroundColor,
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: AmigosSelec()                                        ),
                                      )
                                    );
                                  },
                                  label: Text('Invitar Amigos'),
                                  icon: Icon(Icons.group_add,size: 30,),
                                )   : Container(),
                        ],
                      ),
                    ),
                  ));
            },
            icon: Icon(Icons.people),
          ),
          Text(
            controller.toFillForm.usuarios.length.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
          ),
          SizedBox(
            width: 15,
          ),
            ],
          ),
          
          
        ],
      ),
      body: controller.toFillForm.usuarios.length < 1
          ? Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No puedes ver las respuestas de esta libreta hasta que 3 personas la hayan contestado',
                      textAlign: TextAlign.center,
                    ),
                    controller.toFillForm.priv &&
                            controller.usuario.documentId ==
                                controller.toFillForm.creadorID
                        ? IconButton(
                            color: backgroundColor,
                            highlightColor: backgroundColor,
                            icon: Icon(Icons.group_add),
                            onPressed: () {},
                          )
                        : !controller.toFillForm.priv
                            ? IconButton(
                                color: backgroundColor,
                                icon: Icon(Icons.group_add),
                                onPressed: () {},
                              )
                            : Container(),
                  ],
                ),
              ),
            )
          : Container(
            
              padding: EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Text(
                  //   'Preguntas',
                  //   style: TextStyle(fontSize: 25),
                  // ),
                  
                  ListView.separated(
                    separatorBuilder: (context,index)=>Divider(height: 2,thickness: 1.5,color: Colors.brown[100],),
                    shrinkWrap: true,
                    itemCount: preguntas.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            child: Dialog(
                              backgroundColor: backgroundColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: <Widget>[
                                      

                                     ],
                                   ),
                                    Text(
                                      preguntas[index].pregunta,
                                      style: TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                    
                                     Divider(height: 30,color: Colors.white54,),
                                     
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, ind) {
                                        return ListTile(
                                          trailing: IconButton(icon: Icon(Icons.lock_open), onPressed: () => null,),
                                          title: Text(
                                            preguntas[index].respuestas[ind]
                                                ['respuesta']),
                                        );
                                      },
                                      itemCount:
                                          preguntas[index].respuestas.length,
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },

                      leading: Text((index + 1).toString(),style: TextStyle(fontSize: 20),),

                      title: Text(preguntas[index].pregunta),
                      trailing: Icon(Icons.library_books),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
