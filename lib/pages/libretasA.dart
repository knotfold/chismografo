import 'package:flutter/material.dart';
import 'package:trivia_form/shared/shared.dart';

class LibretasA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => null,
        label: Text('Nueva solicitud'),
        icon: Icon(Icons.fiber_new),
      ),
      appBar: myAppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Libretas Amigos', style: TextStyle(fontSize: 25),),
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
