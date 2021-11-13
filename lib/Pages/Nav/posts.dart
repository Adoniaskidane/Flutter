// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:bunamedia/Pages/services/db.dart';
import 'package:bunamedia/Pages/services/user_img.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  final CUser user;
  const PostPage({ Key? key,required this.user }) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState(cuser: user);
}

class _PostPageState extends State<PostPage> {

  //constructor
  _PostPageState({required this.cuser});

  CUser cuser=CUser();
  TextEditingController _postText=TextEditingController();
  late File _postImage;
  bool _ispickImage=false;
  UserImage _pickImage=UserImage();
  DateTime _now = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cuser.username),
        centerTitle: true,
      ),
      body: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50)
        ),
      ),
      //user list view so that it will be scrollable and assign the controller from drabblescrollablesheet

      child: Column(
        children: [
          //SizedBox(height: 50,),
          Container(
            decoration:BoxDecoration(
              color: Colors.white,
              border:Border(
                bottom: BorderSide(
                  color:Colors.blue,
                  width: 3,
                )
              )
            ),
            
            padding:EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20
            ),
            height:MediaQuery.of(context).size.height*0.2,
            width: MediaQuery.of(context).size.width*1,
            //color: Colors.white,
            child:TextField(
              controller: _postText,
              keyboardType: TextInputType.text,
              maxLines: 20,
              style: TextStyle(
                fontSize: 20,
                height: 1.5
              ),
              decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 17),
              hintText: 'Write something here ...',
              border: InputBorder.none,
            ),
            )
          ),
        
          Row(
            children: [
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                fixedSize:Size(100, 50), 
              ),
                onPressed: ()async{
                  try{
                  _postImage=(await _pickImage.getImage())!;
                    _ispickImage=true;
                    setState(() {
                      print('Image selected');
                    });
                  }catch(e){
                    _ispickImage=false;
                  }
                  setState(() {
                  });
                },
                child:Icon(FontAwesomeIcons.camera)),

              GestureDetector(
                child: Container(
                  height: 50,
                  width: 70,
                  child: _ispickImage==true?
                  Image.file(_postImage,fit: BoxFit.cover,):
                  Icon(FontAwesomeIcons.images,color: Colors.black,),
                ),
                onTap: (){
                  _ispickImage=false;
                  setState(() {
                    print('Gesture');
                  });
                },
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            alignment: Alignment.bottomRight,
            child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                fixedSize:Size(100, 50), 
              ),
              onPressed: ()async{
                Database db=Database(uid: cuser.uid);
                if(_ispickImage && _postText.text.isNotEmpty){
                  print('Text and  image');
                  print('Posted text: ${_postText.text}');
                  final res=await db.InsertPost(text: _postText.text,img: _postImage);
                  if(res){
                  }
                }
                //Just Text
                else if(_postText.text.isNotEmpty){
                 print('Posted only text: ${_postText.text}');
                  await db.InsertPost(text: _postText.text);
                }
                //Just Image
                else if(_ispickImage){
                  print('Just image');
                  await db.InsertPost(img: _postImage);
                }
                Navigator.pop(context);
              },
              child:Text("POST") ,
          ))
        ],
      ),
  ));
  }
}