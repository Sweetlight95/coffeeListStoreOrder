import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/constant.dart';

class Register extends StatefulWidget {

  final Function toggle;
  Register({required this.toggle});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Register'),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign In"),
            onPressed: () {
              widget.toggle();
            },),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
            key: _formKey,
            child: Column(
          children: [
            SizedBox(height: 20,),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Email'),
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              onChanged: (val) {
                setState(() => email = val );
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Password'),
              obscureText: true,
              validator: (val) => val!.length < 6 ? "Enter a password 6+ chars long" : null,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.blue[400],
              child: Text('Register',
              style: TextStyle(
                color: Colors.white,
              ),),
                onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                 dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                 if (result == null) {
                   setState(()  {
                     error = 'please supply a valid email';
                     loading = false;
                   });
                 }
                  // print(email);
                  // print(password);
                }
                }),
            SizedBox(height: 12,),
            Text(
              error,
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
              ),
            )
          ],
        )),
      ),
    );
  }
}
