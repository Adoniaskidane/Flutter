// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:bunamedia/Pages/services/user.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class Account extends StatefulWidget {
  const Account({ Key? key }) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with AutomaticKeepAliveClientMixin{

  CUser user=CUser();
  bool loaded=false;
  late File _image;
  final picker = ImagePicker();


  @override
  void initState(){
    LoadData();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body:loaded==true?Profile(user.uid,user.profile):
              Center(child: CircularProgressIndicator()),      
    );
  }

  Widget Profile(String user,String profile){
    return Container(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.05,
            width:MediaQuery.of(context).size.width,
            child: Text(user),
            padding: EdgeInsets.all(10),
            color: Colors.blue,
          ),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                color: Colors.purple,
              ),
              Positioned(
                left: MediaQuery.of(context).size.width*0.3,
                top:MediaQuery.of(context).size.height*0.05 ,
                child: CircleAvatar(
                  backgroundColor:Colors.white,
                  child:ClipRRect(borderRadius:BorderRadius.circular(70),child:Image.network(profile,fit: BoxFit.fill,)),
                  radius: 70,
                ),
              ),
         
              Positioned(
                left: MediaQuery.of(context).size.width*0.4,
                top:MediaQuery.of(context).size.height*0.2 ,
                child: ElevatedButton(
                  onPressed: ()async{
                    print("pressed");
                    await getImage();
                    await uploadImage();
                    await loadImage();
                    setState((){      
                      print(_image);
                    });
                  },
                  child: Icon(FontAwesomeIcons.camera),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width*0.4,
                top:MediaQuery.of(context).size.height*0.3 ,
                child: Text('First Last'),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.1 ,
            width: MediaQuery.of(context).size.width,
            color: Colors.lightBlue[100],
            child: Center(child: Text("List view of User Post")),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: (){},
            child:Text("Term and Condition") ,
          ),
      ],),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


Future<String> LoadData()async{
  final result=await getCurrentUser();
  await loadImage();
  loaded=true;
  print('Data Loaded Done');
  setState(() {
    
  });
  return result; 
}


  //Helper Functions
  Future<String> getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    user.uid=result;
    return result;
  }

  Future getImage() async {
    final ImagePicker _picker=ImagePicker();
    try{
      final image=await _picker.pickImage(source:ImageSource.gallery);
      if(image==null){
        print("pick Image");
      }
      else{
        _image=File(image.path);
      }    
    }on PlatformException catch (e){
        print("Failed to pick image");
      }
  }

  Future<bool> uploadImage() async{
    FirebaseStorage firebaseStorage=FirebaseStorage.instance;
    
    try{
    Reference storageref=firebaseStorage.ref().child(user.uid).child('Profile').child('Profile');
    UploadTask uploadTask=storageref.putFile(_image);
    TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => true);
     return true;
    }on FirebaseException catch (e){
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