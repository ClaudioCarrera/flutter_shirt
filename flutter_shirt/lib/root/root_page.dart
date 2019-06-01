import 'package:flutter/material.dart';
import 'package:flutter_shirt/login/login_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RaisedButton(
              child: const Text('LOGIN'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => LoginPage()),
                );
              },
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
