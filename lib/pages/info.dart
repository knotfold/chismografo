import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trivia_form/services/services.dart';
class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  _launchURL() async {
    const url = 'http://gudtech.tech/es/gudpets-tos/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Scaffold(
      appBar: myAppBar(controller),
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                Text(
                  'Creado por GudTech',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/gudtech.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Nuestras redes sociales',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () => launch(
                            'https://www.facebook.com/GudTech-508541236622884/'),
                        child: Icon(
                          FontAwesomeIcons.facebook,
                          size: 30,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        onTap: () => launch(
                            'http://gudtech.tech/es/sample-page/home-spanish/'),
                        child: Icon(
                          FontAwesomeIcons.chrome,
                          size: 30,
                        )),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Donaciones',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Descripción para donaciones.',
                    style: TextStyle(fontSize: 18.0, color: Colors.brown)),
                SizedBox(
                  height: 15,
                ),
                FloatingActionButton.extended(
                  onPressed: () => launch(
                      'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CKVCWLMCRCFTN&source=url'),
                  label: Text('Donar'),
                  icon: Icon(FontAwesomeIcons.paypal),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Dudas y sugerencias',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Para externar tus dudas, sugerencias e ideas, puedes escribirnos al correo ',
                    style: TextStyle(fontSize: 18.0, color: Colors.brown)),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => Clipboard.setData(
                      ClipboardData(text: 'gudtechinfo@gmail.com')),
                  child: Tooltip(
                    message: 'Copiado',
                    child: Text('gudtechinfo@gmail.com',
                        style: TextStyle(fontSize: 18.0, color: Colors.brown)),
                  ),
                ),
              ],
            ),
          ),
        
      ),
    );
  }
}
