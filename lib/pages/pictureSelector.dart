import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trivia_form/services/services.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart';

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File imagen;

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              imagen = await controller.getImage(context);
              setState(() {});
            },
            child: Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundImage: imagen == null
                              ? AssetImage('assets/dog.png')
                              : FileImage(imagen),
                          backgroundColor: Colors.transparent,
                        )),
                    CircleAvatar(
                      child: IconButton(
                          icon: Icon(Icons.photo_camera),
                          onPressed: () async {
                            imagen = await controller.getImage(context);
                            setState(() {});
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
