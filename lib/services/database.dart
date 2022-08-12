import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/models/user.dart';

import '../models/coffee.dart';

class DatabaseService {
  //collection reference

  final String uid;
  DatabaseService({required this.uid});


  final CollectionReference coffeeCollection = FirebaseFirestore.instance.collection('coffee');

  Future updateUserData(String sugars, String name, int strength) async {
    return await coffeeCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }
  //coffelist from snaps hot
  List<Coffee> _coffeeListFromSnapshort(QuerySnapshot snapshot) {
    return snapshot.docs.map((docus) {
      return Coffee(
          name: docus['name'] ?? '',
          sugars: docus['sugars'] ?? '0',
          strength: docus['strength'] ?? 0
      );
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot['name'],
        sugars: snapshot['sugars'],
        strength: snapshot['strength'],
    );
  }

  //get coffee stream
 Stream<List<Coffee>> get coffees {
    return coffeeCollection.snapshots().map(_coffeeListFromSnapshort);
 }

 //get user doc stream
Stream<UserData> get userData {
    return coffeeCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
}
}

