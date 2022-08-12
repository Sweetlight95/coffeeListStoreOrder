import 'package:coffee_shop/models/user.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:coffee_shop/shared/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/loading.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1', '2', '3', '4'];

  //form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength ;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserMan?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          UserData? userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Update your coffee settings.',
                  style: TextStyle(
                      fontSize: 18),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  initialValue: userData?.name ,
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() {
                    _currentName = val;
                  }),
                ),
                SizedBox(height: 20.0,),
                //dropdown
                DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData?.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() {
                      _currentSugars = val as String;
                    }
                    )
                ),
                SizedBox(height: 15,),
                Text("Coffee Strength",
                style: TextStyle(color: Colors.black,
                fontSize: 18),),
                //slider
                Slider(
                    label: 'Coffee strength',
                    value: (_currentStrength ?? userData?.strength)!.toDouble(),
                    activeColor: Colors.yellow[_currentStrength ?? userData!.strength],
                    inactiveColor: Colors.brown[_currentStrength ?? userData!.strength],
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (val) => setState(() {
                      _currentStrength = val.round();
                    })
                ),
                RaisedButton(
                    color: Colors.yellowAccent[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars ?? userData!.sugars,
                            _currentName ?? userData!.name,
                            _currentStrength ?? userData!.strength,
                        );
                        Navigator.pop(context);
                      }
                      // print(_currentName);
                      // print(_currentSugars);
                      // print(_currentStrength);
                    })
              ],
            ),
          );
        } else {
          return Loading();
        }

      }
    );
  }
}
