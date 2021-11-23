// ignore_for_file: prefer_const_constructors
import 'package:bunamedia/Pages/Nav/chat.dart';
import 'package:bunamedia/Pages/services/db.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Network extends StatefulWidget {
  const Network({ Key? key }) : super(key: key);

  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  CUser _CurrentUser=CUser();
  bool initialization=false;
  TextEditingController search_controller=TextEditingController();
  CUser SearchedUsers=CUser();
  late Database db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Column(
          children: [
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
              initialization==true?
              Center(child: Column(
                children: [
                Container(
                      height: MediaQuery.of(context).size.height*0.1,
                      width:  MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: search_controller,
                        onChanged: (value){
                          SearchUsers(value);
                        },
                      ),
                    ),
                  search_controller.text.isEmpty?Container():
                  Container(
                    child: GestureDetector(
                      child: UserExplore(SearchedUsers),
                      onTap: (){
                        print('${_CurrentUser.username} and ${SearchedUsers.username}');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(cuser: _CurrentUser, user: SearchedUsers)));
                      },
                    ),
                  )
                ],
              ),)
              //if userData not initialized
              :Center(child: CircularProgressIndicator(),)
          ],
        ),
      )
    );
  }


    void getUserData()async{
    _CurrentUser.uid=await getCurrentUser();
    final uid=_CurrentUser.uid;
    db=Database(uid: uid);
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

  Future<void> SearchUsers(String username)async{
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.snapshots().forEach((element) async{
      element.docs.forEach((element) async{
        String name=element.get('Username');
        if(name.toLowerCase().contains(username.toLowerCase())){
          SearchedUsers=(await db.BuildEachUser(element.id))!;print(name);
          setState(() {
            
          });
        }
      });
    });
  }







  Widget UserExplore(CUser Mediauser)
  {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(Mediauser.profile),
                  ),
                  SizedBox(width: 10,),
                  Text(Mediauser.username),
                ],
              ),

              ElevatedButton(
                onPressed: (){

                },
                child:Row(
                  children: [
                    Text('Link',style:TextStyle(fontSize: 20,letterSpacing: 2),),
                    SizedBox(width: 5,),
                    Icon(FontAwesomeIcons.userFriends),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Divider(color: Colors.black,height: 2,),
        ],
      ),
    );
  }
}