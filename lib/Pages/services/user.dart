import 'dart:io';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';

class CUser{
  late String first;
  late String last;
  late String uid;
  late String email;
  late String username;
  late String profile;
}


class argEmail{
  String Email;
  argEmail({required this.Email });
}


class BuildCUser{

  CUser user=CUser();

  BuildCUser(){
    getCurrentUser();
  }
  Future<String> getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    return result;
  }

  Future<bool> getCUserNames()async{
    try{
      
      return true;
    }on FirebaseException catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> loadImage()async{
    try{
      final ref = FirebaseStorage.instance.ref().child(user.uid).child('Profile').child('Profile');
      var url = await ref.getDownloadURL();
      user.profile=url;
    }on FirebaseException catch(e){
      print('+++++++++++++++++++++++++++++++++++++++++++');
      print(e);
      print('+++++++++++++++++++++++++++++++++++++++++++');
      final ref = FirebaseStorage.instance.ref().child('Defalut').child('profile.png');
      var url = await ref.getDownloadURL();
      user.profile=url;
    }
    return true;
  }

}



class UserPost{
  UserPost({required this.isImage,required this.isText,required this.time,required this.profile});
    bool isImage;
    bool isText;
    String imgUrl="";
    String text="";
    DateTime time;
    String postId="";
    String uid="";
    CUser profile;
}

class messages{
  messages({required this.userID,required,required this.message,required this.time});
  String userID;
  String message;
  DateTime time;
}