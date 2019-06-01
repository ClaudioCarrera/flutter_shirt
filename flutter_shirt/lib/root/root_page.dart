import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  initLogin() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account != null) {
        print('logged');
      } else {
        print('not logged');
      }
    });
    _googleSignIn.signInSilently().whenComplete(() {
      print('ok');
    });
  }

  doLogin() async {
    showLoading();
    await _googleSignIn.signIn();
  }

  Widget showLoading() {
    return CircularProgressIndicator();
  }

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
                  MaterialPageRoute<void>(builder: (_) => doLogin()),
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
