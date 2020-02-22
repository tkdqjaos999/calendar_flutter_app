import 'package:calendar_flutter_app/src/data/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    logger.d(fp.getUser());

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('로그인',
          style: TextStyle(
              color: Colors.black
          ),),
      ),
      body: Center(
        child: Container(
          height: 40,
          child: SignInButton(
            Buttons.Google,
            onPressed: (){
              _signInWithGoogle();
            },
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   로그인 중 ....")
          ],
        )));
    bool result = await fp.singWithGoogleAccount();
    _scaffoldKey.currentState.hideCurrentSnackBar();
//    if(result == false)
    if(result  == true) {
      Navigator.of(context).pop();
    }
  }
}
