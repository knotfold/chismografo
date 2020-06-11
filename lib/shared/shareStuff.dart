import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/services/services.dart';
import 'package:ChisMe/shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

AppBar myAppBar(Controller controller, BuildContext context) {
  return AppBar(
    
    elevation: 0,
    title: Text(
      'ChisMe ;)',
      style: TextStyle(color: Colors.white),
    ),
    actions: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 15),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.live_help),
              onPressed: () {
                controller.sdtP = 0;
                showDialog(
                  context: context,
                  child: TutorialDialog(),
                );
              },
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              icon: Icon(Icons.stars),
              color: Colors.yellow[800],
              onPressed: () {
                controller.seleccionado = 4;
                controller.notify();
              },
            ),
            Text(
              controller.usuario.coins.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
              SizedBox(
              width: 10,
            ),
            GestureDetector(
            onTap: () {
              // if (widget.group) {
              //   Navigator.of(context)
              //       .pushNamed('/imageViewer', arguments: widget.foto);
              //   return;
              // }
              // controller.selectedUser = widget.usuario;
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => Perfil(
              //           usuario: widget.usuario,
              //         )));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              child: CircleAvatar(
                maxRadius: 18,
                backgroundImage: NetworkImage(controller.usuarioAct.foto),
              ),
            ),
          ),
          
          ],
        ),
      ),
    ],
  );
}

class TutorialDialog extends StatefulWidget {
  const TutorialDialog({
    Key key,
  }) : super(key: key);

  @override
  _TutorialDialogState createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {

  Future<DocumentSnapshot> fetchTutorial(Controller controller) async {
    String search;
    switch (controller.seleccionado) {
      case 0:
        {
          search = 'howtouse';
          break;
        }
      case 1:
        search = 'howtouselibretasA';
        break;

      case 2:
        search = 'howtouseamigos';
        break;

      case 3:
        search = 'howtouseperfil';
        break;

      case 4:
        search = 'howtousetienda';
        break;
    }
    return await Firestore.instance
        .collection('howtouse')
        .document(search)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of(context);
    return Dialog(
      child: Container(
        margin: EdgeInsets.all(20),
        child: FutureBuilder(
            future: fetchTutorial(controller),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              String search;
              switch (controller.seleccionado) {
                case 0:
                  {
                    search = 'howtouse';
                    break;
                  }
                case 1:
                  search = 'howtouselibretasA';
                  break;

                case 2:
                  search = 'howtouseamigos';
                  break;

                case 3:
                  search = 'howtouseperfil';
                  break;

                case 4:
                  search = 'howtousetienda';
                  break;
              }
              List<dynamic> map = snapshot.data[search];
              List<Widget> pages = [];
            
              map.forEach((f) {
   
                pages.add(Container(
                  child: SingleChildScrollView(
                                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          f['titulo'],
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(f['desc'],style: TextStyle(color: Colors.white),),
                        SizedBox(
                          height: 25,
                        ),
                        Image(
                          alignment: Alignment.topCenter,
                          height: 300,
                          width: 400,
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(f['imagen']),
                        ),
                      ],
                    ),
                  ),
                ));
              });

     
              return SingleChildScrollView(
                              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: ListView.builder(
                        itemCount: map.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Icon(
                            Icons.fiber_manual_record,
                            size: 10,
                            color:  controller.sdtP == index
                                ? secondaryColor
                                : Colors.grey,
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 400,
                      child: PageView(
                        onPageChanged: (value){
                          controller.sdtP = value;
                          controller.notify();
                          setState(() {
                            
                          });
                        },
                        controller: controller.pageController2,
                        children: pages,
                      ),
                    ),
                    
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Drawer myDrawer(BuildContext context) {
  Controller controller = Provider.of<Controller>(context);
  return Drawer(
    child: Column(
      children: <Widget>[
        AppBar(
          // centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 1,
          title: Text('Ménu'),
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pushReplacementNamed('/misLibretas'),
          title: Text('Tus libretas'),
          leading: Icon(Icons.book),
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pushReplacementNamed('/libretasAmigos'),
          title: Text('Libretas de Amigos'),
          leading: Icon(Icons.bookmark),
        ),
        ListTile(
          title: Text('Info'),
          leading: Icon(Icons.info),
        ),
        ListTile(
          title: Text('Cerrar Sesión'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              signOutGoogle();
              await controller.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', ModalRoute.withName('/home'));
            },
          ),
        )
      ],
    ),
  );
}
