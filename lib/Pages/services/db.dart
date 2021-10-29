import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  String uid;
  Database({required this.uid});


  Future<void> setProfile()async{

  }

  Future<void> getProfile()async{

  }

  Future<void> InsertUserData(String Username,String firstname,String lastname, String Email,) async{
     CollectionReference users = FirebaseFirestore.instance.collection('Users');
     users.doc(uid).set({
       'Username':Username,
       'Firstname':firstname,
       'Lastname':lastname,
       'Email':Email
       }
     ).then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
  }
}