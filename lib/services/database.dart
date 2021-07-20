import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_preference/models/coffee.dart';
import 'package:coffee_preference/models/user.dart';

class DatabaseService {

  //constructor
  final String? uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference coffeeCollection = FirebaseFirestore.instance.collection("coffees");

  //Create-Ipdate data
  Future updateUserData(String sugars,String name,int strength) async {
    return await coffeeCollection.doc(uid).set({
      'sugars' : sugars,
      'name' : name,
      'strength' : strength,
    });
  }

  //Coffee List from snapshot
  List<Coffee> _coffeeListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((i) {
      return Coffee(
        name: i.get('name') ?? '',
        strength: i.get('strength') ?? 0,
        sugars: i.get('sugars') ?? '0',
      );
    }).toList();
  }

  //user Data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.get("name"),
      sugars: snapshot.get("sugars"),
      strength: snapshot.get("strength")
    );
  }

  //Get coffees Stream
  Stream<List<Coffee>> get coffees {
    return coffeeCollection.snapshots().map(_coffeeListFromSnapshot);
  }

  //Get user doc Stream
  Stream<UserData> get userData {
    return coffeeCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }
}