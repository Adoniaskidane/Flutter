// ignore_for_file: avoid_print
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';

class Database{

  String uid;
  CUser _user=CUser();

  Database({required this.uid});
  

  Future<CUser> getUser()async{
    await retriveUserData();
    await loadImage();
    return _user;
  }

  Future<bool> retriveUserData()async{
    _user.uid=uid;
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      final res= users.doc(uid).get().then((value){
        if(value.exists){
          _user.username=value.get('Username');
          _user.first=value.get('Firstname');
          _user.last=value.get('Lastname');
          _user.email=value.get('Email');
          return true;
        }else
        {
          return false;
        }
      });

      return res;
  }


    Future<bool> loadImage()async{
    try{
      final ref = FirebaseStorage.instance.ref().child(uid).child('Profile').child('Profile');
      var url = await ref.getDownloadURL();
      _user.profile=url;
    }on FirebaseException catch(e){
      print('+++++++++++++++++++++++++++++++++++++++++++');
      print(e);
      print('+++++++++++++++++++++++++++++++++++++++++++');
      final ref = FirebaseStorage.instance.ref().child('Defalut').child('profile.png');
      var url = await ref.getDownloadURL();
      _user.profile=url;
    }
    
    return true;
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