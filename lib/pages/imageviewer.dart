import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_downloader/image_downloader.dart';

class ImageViewer extends StatefulWidget {
  final String image;
  ImageViewer({this.image});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool loading = false;
  _save() async {
    setState(() {
      loading = true;
    });
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(
         widget.image);
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
      print(error);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: <Widget>[
         loading ? Container(child: CircularProgressIndicator(), margin: EdgeInsets.symmetric(vertical: 10),) : IconButton(
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
}
