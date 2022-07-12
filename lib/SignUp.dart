import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireauth/services/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance.collection('users');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _name, _email, _password;

  // checkAuthentication() async {
  //   _auth.authStateChanges().listen((user) async {
  //     if (user != null) {
  //       Navigator.pushReplacementNamed(context, "/");
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        global.email = _email;
        global.name = _name;
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          // UserUpdateInfo updateuser = UserUpdateInfo();
          // updateuser.displayName = _name;
          //  user.updateProfile(updateuser);
          await _auth.currentUser!.updateProfile(displayName: _name);

          // await Navigator.pushReplacementNamed(context,"/") ;
        }
      } on FirebaseAuthException catch (e) {
        showError(e.message.toString());
        print(e);
      }
      try {
        final User = (await _auth.signInWithEmailAndPassword(
                email: _email, password: _password))
            .user;

        if (User != null) {
          global.ID = User.uid;
          global.profilepic = "default";
          await FirebaseFirestore.instance
              .collection('users')
              .doc(User.uid)
              .set({
            "id": User.uid,
            "username": _name,
            "email": _email,
            "created_at": DateTime.now().millisecondsSinceEpoch,
            "profilepic": "default"
          });
          Navigator.pushReplacementNamed(context, "home");
        }
      } on FirebaseAuthException catch (e) {
        showError(e.message.toString());
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              child: Image(
                image: AssetImage("images/login.jpg"),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                          validator: (input) {
                            if (input!.isEmpty) return 'Enter Name';
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          onSaved: (input) => _name = input!),
                    ),
                    Container(
                      child: TextFormField(
                          validator: (input) {
                            if (input!.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email)),
                          onSaved: (input) => _email = input!),
                    ),
                    Container(
                      child: TextFormField(
                          validator: (input) {
                            if (input!.length < 6)
                              return 'Provide Minimum 6 Character';
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input!),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: signUp,
                      child: Text('SignUp',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
