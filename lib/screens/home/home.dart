import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/screens/home/settings_form.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/coffee.dart';
import 'coffee_list.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Coffee>>.value(
      value: DatabaseService(uid: '').coffees,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.yellowAccent[50],
        appBar: AppBar(
          title: Text("Welcome to Our Coffee store",
            style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.yellow[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person,
                ),
              label: Text("LogOut",
                ),
              onPressed: () async {
                  await _auth.signOut();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
                label: Text('Settings'),
                onPressed: () {
                  _showSettingsPanel();
                }
            ),
        ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/coffee2.webp'),
              fit: BoxFit.cover,
              ),

            ),

            child: CoffeeList()),
      ),
    );
  }
}
