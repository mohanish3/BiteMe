import 'package:biteme/utilities/server_functions.dart';
import 'package:flutter/material.dart';

class ServerDialog extends StatelessWidget {
  final TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            ServerFunctions.serverIp =
                'http://' + ipController.text.trim() + ':3000';
            Navigator.of(context).pop();
          },
        )
      ],
      content: Container(
        height: MediaQuery.of(context).size.height / 5.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Enter Server IP',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              'Leaving this blank will disable the search feature and you won\'t be awarded any credits for your reviews.',
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
            TextField(
                controller: ipController,
                decoration: InputDecoration(labelText: 'Server IP')),
          ],
        ),
      ),
    );
  }
}
