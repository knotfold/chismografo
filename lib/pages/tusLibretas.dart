import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';

class TusLibretas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        isExtended: true,
        onPressed: () => Navigator.of(context).pushNamed('/creadorLibreta'),
        label: Text('Crea una nueva libreta'),
        icon: Icon(Icons.book),
      ),
      appBar: myAppBar(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text('Tus Libretas', style: TextStyle(fontSize: 25),),
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
      ),
    );
  }
}
