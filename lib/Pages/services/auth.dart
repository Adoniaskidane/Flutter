import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//authentication class, helps methods for auth implemented here
class UserAuthentication{

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _verification = FirebaseFirestore.instance;

  UserAuthentication(this._firebaseAuth);
  Future<bool> SignUp(String email,String password) async{
    try{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password); 
    return true;
    }on FirebaseException catch(e){
      print(e.message);
      return false;
    }
  }

  Future<bool> SignIn(String email,String password) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return true;
    }on FirebaseException catch(e){
      print(e.message);
      return false;
    }

  }
  Future<bool> SignOut() async{
    try{
      await _firebaseAuth.signOut();
    return true;
    }on FirebaseException catch(e){
      print(e.message);
      return false;
    }

  }


  Future<String> CurrentUid()async{
      return _firebaseAuth.currentUser!.uid;
  }

  Future<bool> sendEmail(String email) async{
    final current=_firebaseAuth.currentUser;
    try{
    await current!.sendEmailVerification();
    print('sent Email');
    return true;
    }on FirebaseException catch(e){
      print(e.message);
      print('Verification sending falied');
      return false;
    }
  }


  Future<bool> checkVerifyStatus()async{
      final current=await _firebaseAuth.currentUser!.reload();
      //await current!.reload();
      print('Checking verification status');
      final res=_firebaseAuth.currentUser!.emailVerified;
      return res; 
  }
}



//Form validation classes and it methods
class validator{
  String? emailValidator(String? value){
    if(value!.isEmpty)
    {
      return "enter email!";
    }
    else if(!RegExp(r'[a-zA-Z]+\.+[a-zA-z]+@udc.edu').hasMatch(value)){
      return "Fix Email Format";
    }
    return null;
    //return "email Worked out well";
  }

  String? passValidator(String? value){
    if(value!.isEmpty)
    {
      return "enter password!";
    }
    return null;
  }
  
}