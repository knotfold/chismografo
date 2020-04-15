import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';

class TusLibretas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/creadorLibreta'),
        label: Text('Crea una nueva libreta'),
      ),
      appBar: myAppBar(),
      drawer: myDrawer(context),
      body: Column(
        children: <Widget>[
          Text('Tus Libretas', style: TextStyle(fontSize: 20),),
          Container(
            child: StreamBuilder(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    title: Text('Form' + index.toString()),
                    subtitle: Text('Participantes: 6'),
                    trailing: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
