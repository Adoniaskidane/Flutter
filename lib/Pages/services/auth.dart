import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<bool> updateuser()async{
    return true;
  }

  Future<String> CurrentUid()async{
      return _firebaseAuth.currentUser!.uid;
  }

  Future<bool> SendverifyingCode(String Email) async{
    Random rand=Random(TimeOfDay.now().minute.gcd(100).hashCode);
    final code=rand.nextInt(100000);
    print(code);
    await _verification.collection('VerifyEmail').doc(Email).set({'Code':code,'verified':false})
    .then((value) => ("User Added"))
      .catchError((error) => ("Failed to add user: $error"));
      return true;
  }

  Future<bool> verifyEmail(String email,String userCode)async{

    final result=_verification.collection('VerifyEmail').doc(email);
    final res=await result.get();
    final isverify=res.data()!['Code'];

    print(isverify);
    print(userCode);

    if(isverify.toString()==userCode){
      print('setting the verification ');

      await result.update({'verified':true});
      print('Set to true');
      return true; 
    }
    print('unable');
    return false;
  }
  Future<bool> isEmailverified(String email)async{
    final result=_verification.collection('VerifyEmail').doc(email);
    final res=await result.get();
    final isverify=res.data()!['verified'];
    if(isverify==true)
    {
      return true;
    }
    return false;
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
      final current=_firebaseAuth.currentUser;
      await current!.reload();
      print('Checking verification status');
      return current.emailVerified; 
  }
}


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