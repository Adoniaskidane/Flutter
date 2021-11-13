// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables
import 'package:bunamedia/Pages/services/db.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({ Key? key }) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore>  with AutomaticKeepAliveClientMixin{
  bool current=false;
  late String _CurrentUser;
  late Database db;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context); 
    
    return Scaffold(
      body:SafeArea(
      child: Container(
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
              current==true?Container(
                height: MediaQuery.of(context).size.height*0.8197,
                child: Container(
                  child:Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      child: ListView.builder(
                        itemCount: db.Collection_users.length,
                        itemBuilder:(context,index){
                          print(db.Collection_users.length);
                          CUser user=db.Collection_users[index];
                          print('From explore ${user.profile}');
                          return UserExplore(user);
                        })),
                ),):CircularProgressIndicator()
              ]
            )
          )
        )
    );
  }

  Future<String> getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    print(result);
    _CurrentUser=result;
    db=Database(uid: _CurrentUser);
    await db.retriveUserData();
    await db.getCollectionUsers(10);
    current=true;
    setState(() {
    });
    return result;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;



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