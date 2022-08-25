import 'package:coffee_shop/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'home/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserMan?>(context);
    // print(user);
    if(user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
