// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:bunamedia/Pages/Nav/posts.dart';
import 'package:bunamedia/Pages/services/auth.dart';
import 'package:bunamedia/Pages/services/db.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:bunamedia/Pages/services/user_img.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  CUser _CurrentUser=CUser();
  DateTime _now = DateTime.now();
  UserAuthentication _authentication=UserAuthentication(FirebaseAuth.instance);
  bool initialization=false;

  //Post content variables
  TextEditingController _postText=TextEditingController();
  late File _postImage;
  bool _ispickImage=false;
  UserImage _pickImage=UserImage();


  @override
  void initState(){
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:initialization==true? Container(
          height: MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
          child:Column(
            children:[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height*.05,
                width:  MediaQuery.of(context).size.width,
                color: Colors.blue[900],
                child: Text("BunaMedia",
                    style :TextStyle(
                      color: Colors.white,
                      fontFamily: 'Times',
                      fontSize: 20
                    ),
                  ),
              ),
              //Container for header pic, username and post button
              Container(
                height: MediaQuery.of(context).size.height*.12,
                width:  MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border:Border(
                    bottom: BorderSide(
                      color: Colors.blue.shade900
                    )
                  )
                ),
                //put them in row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              radius: 33,
                              backgroundImage:NetworkImage(_CurrentUser.profile) ,
                            ),
                          ),
                          Container(
                            //padding: EdgeInsets.all(10),
                            alignment:Alignment.centerRight,
                            child: Text(_CurrentUser.username,
                              style :TextStyle(
                                fontFamily: 'Times',
                                fontSize: 25
                              ),
                        )
                      ),

                        ],
                      ),
                      //Post button
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade900,
                          fixedSize: Size.fromWidth(120),
                        ),
                        /*
                        onPressed: ()=>showModalBottomSheet(
                          backgroundColor:Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder:(context)=>PostingPage()),*/
                        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage()));},
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(FontAwesomeIcons.plusCircle),
                            SizedBox(width: 10,),
                            Text("POST",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500
                              ), 
                            ),
                            
                          ],
                        )),
                      ),
                    ],
          ),
              ),
  
            ],
          )
         
        ):
      Center(child: CircularProgressIndicator())
      ),
    );
  }

  void getUserData()async{
    _CurrentUser.uid=await getCurrentUser();
    final uid=_CurrentUser.uid;
    print('current user $uid');
    Database db=Database(uid: uid);
    _CurrentUser=await db.getUser();
    setState(() {
      initialization=true;
    });
  }
  Future<String> getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    return result;
  }



  //Post page widget
  Widget PostingPage(){
  return DraggableScrollableSheet(
    
    initialChildSize:0.9,
    minChildSize: 0.5,
    maxChildSize: 1,
    builder: (_,controller)=>Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50)
        ),
      ),
      //user list view so that it will be scrollable and assign the controller from drabblescrollablesheet

      child: Column(
        children: [
          SizedBox(height: 50,),
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
              vertical: 10,
              horizontal: 20
            ),
            height:MediaQuery.of(context).size.height*0.5,
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
              onPressed: (){
                if(_ispickImage){
                  print('Posted text: ${_postText.text}');
                  if(_postImage.path.isEmpty)
                  {
                    print('No picture');
                  }
                  else{
                    print('Has a picture');
                  }
                }
                else{
                 print('Posted text: ${_postText.text}');
                }
              },
              child:Text("POST") ,
          ))
        ],
      ),
  ));
  }
}


