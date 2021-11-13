// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class UserImage
{
  late File _image;
  UserImage();

  Future<File?> getImage() async {
    final ImagePicker _picker=ImagePicker();
    try{
      final image=await _picker.pickImage(source:ImageSource.gallery);
      if(image==null){
        print("pick Image");
        return _image;
      }
      else{
        _image=File(image.path);
        return _image;
      }    
    }
    on PlatformException catch (e){
        print("Failed to pick image");
        return _image;
      }
      catch (e){
        return null;
      }
  }

  Future<String?> UploadPostImage({required String uid,required String ref,required File images}) async{
    FirebaseStorage firebaseStorage=FirebaseStorage.instance;
    
    try{
    Reference storageref=firebaseStorage.ref().child(uid).child(ref).child('image');
    UploadTask uploadTask=storageref.putFile(images);
    TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => true);
    return await taskSnapshot.ref.getDownloadURL();
    }on FirebaseException catch (e){
      return null;
    }
   
  }
}