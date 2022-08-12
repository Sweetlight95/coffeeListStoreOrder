import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/shared/constant.dart';
import 'package:coffee_shop/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn({required this.toggle});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authentication = AuthService();
  final _formKey  = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.greenAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
        title: Text("Sign In"),
        actions: [
          FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () {
                widget.toggle();
              } ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
              child: Column(
            children: [
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' :  null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? "Enter a 6 character or more" : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                  color: Colors.greenAccent[400],
                  child: Text(
                    'LogIn',
                    style: TextStyle(
                      color: Colors.yellowAccent[400],
                    ),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _authentication.signInWithEmailAndPassword(email, password);
                      if (result ==  null) {
                        setState(() {
                          error = "Could not sign in with those credentials";
                          loading =  false;
                        });
                      }
                    }
                    // print(email);
                    // print(password);
                  }
                  ),
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
