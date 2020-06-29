import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:ChisMe/services/controller.dart';
import 'package:ChisMe/services/models.dart';
import 'package:provider/provider.dart';

class ImageViewer extends StatefulWidget {
  final String image;
  final UsuarioModel usuarioModel;
  ImageViewer({this.image, @required this.usuarioModel});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool loading = false;
  _save() async {
   
    try {
       loading = true;
        setState(() {
     
    });
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(widget.image);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
      Fluttertoast.showToast(
          msg: 'Imagen guardada en $path', toastLength: Toast.LENGTH_SHORT);
    } on PlatformException catch (error) {
      loading = false;
      setState(() {
        
      });
      print(error);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
   UsuarioModel usuario = widget.usuarioModel ?? UsuarioModel(usuario: controller.usuarioAct.usuario, amigos: []);
   List<dynamic> amigos = usuario.amigos;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          usuario.usuario != controller.usuario.usuario &&
                  !verifyFriendship(controller, amigos)
              ? Container()
              : loading
                  ? Container(
                      child: CircularProgressIndicator(),
                      margin: EdgeInsets.symmetric(vertical: 10),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.file_download,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await _save();
                      })
        ],
      ),
      body: Center(
        child: Container(
            child: PhotoView(
          imageProvider: NetworkImage(widget.image),
        )),
      ),
    );
  }

  bool verifyFriendship(Controller controller, List<dynamic> amigos) {
    return amigos.contains(controller.usuario.documentId);
  }
}
