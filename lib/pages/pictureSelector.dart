import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ChisMe/services/services.dart';
import 'package:provider/provider.dart';

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File imagen;

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              controller.image = await controller.getImage(context);
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
                          backgroundImage: controller.image == null
                              ? AssetImage('assets/file-picture-icon.png')
                              : FileImage(controller.image),
                          backgroundColor: Colors.transparent,
                        )),
                    CircleAvatar(
                      child: IconButton(
                          icon: Icon(Icons.photo_camera),
                          onPressed: () async {
                            controller.image = await controller.getImage(context);
                            controller.notify();
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
