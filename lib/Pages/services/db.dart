// ignore_for_file: avoid_print
import 'package:bunamedia/Pages/services/user_img.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
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

  Future<bool> InsertPost({String? text,File? img})async{
    DateTime time=DateTime.now();
    UserImage imgUpload=UserImage();
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    CollectionReference AllPost = FirebaseFirestore.instance.collection('Posts');
    final ref=users.doc(uid).collection('Post').doc();

    final parseTime=('${time.year}-${time.month}-${time.day}-${time.hour}-${time.minute}-${time.second}-${time.millisecond}-${time.microsecond}');
    //Image and Text
    if(img!=null && text!=null)
    {
      await ref.set({'Text':text,'Time':time,'isImage':true,'isText':true,'Comment':0,'like':0,'love':0,'dislike':0});
      AllPost.doc(parseTime).set({'ref':ref,'Time': time});
      final ImgUrl=await imgUpload.UploadPostImage(uid: uid,ref: ref.id,images: img);
      await ref.update({'ImgUrl':ImgUrl});
      return true;
   }//only Text post
   else if(img==null && text!=null){
        ref.set({'Text':text,'Time':time,'isImage':false,'isText':true,'Comment':0,'like':0,'love':0,'dislike':0});
        AllPost.doc(parseTime).set({'ref':ref,'Time': time}); 
        return true;
   }//only image post
   else if(img!=null && text==null){
        ref.set({'Time':time,'isImage':true,'isText':false,'Comment':0,'like':0,'love':0,'dislike':0});
        AllPost.doc(parseTime).set({'ref':ref,'Time': time});
        final ImgUrl=await imgUpload.UploadPostImage(uid: uid,ref: ref.id,images: img);
        await ref.update({'ImgUrl':ImgUrl});
        return true;
   }else{
     return false;
   }
  }


  //Retrieve data for the feeding section

  Future<List<UserPost>> getFeedingData(int size)async{
    CollectionReference users = FirebaseFirestore.instance.collection('Posts');
    List<DocumentReference> a=[];
    List<UserPost> userposts=[];
    final value=await users.limit(size).orderBy('Time',descending: true).get();
    value.docs.forEach((e){
      a.add(e.get('ref'));
    });
    print(a.length);

    for(int i=0;i<a.length;i++){
      UserPost post;
      final b=await a[i].get();
      final id =b.reference.parent.parent!.id;
      Database db=Database(uid: id);
      CUser profile=await db.getUser();
      print('This is the username ${profile.username}');
      final postid=b.reference.id;
      final isImage=b.get('isImage');
      final isText=b.get('isText');
      final time=b.get('Time');
      Timestamp t=time;
      DateTime newtime=t.toDate();
      post=UserPost(isImage: isImage,isText: isText,time: newtime,profile: profile);
      post.uid=id;
      post.postId=postid;
      if(isText==true)
      {
        final text=b.get('Text');
        post.text=text;
      }
      if(isImage==true)
      {
        final imgUrl=b.get('ImgUrl');
        post.imgUrl=imgUrl;
      }
      userposts.add(post);
    }

  print('${userposts.length}');
  return userposts;
    }

}