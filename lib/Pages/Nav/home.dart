// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:bunamedia/Pages/Nav/posts.dart';
import 'package:bunamedia/Pages/services/auth.dart';
import 'package:bunamedia/Pages/services/db.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:bunamedia/Pages/services/reaction.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:bunamedia/Pages/services/user_img.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  CUser _CurrentUser=CUser();
  UserAuthentication _authentication=UserAuthentication(FirebaseAuth.instance);
  bool initialization=false;

  //Post content variables
  TextEditingController _postText=TextEditingController();
  late File _postImage;
  bool _ispickImage=false;
  UserImage _pickImage=UserImage();
  //For the feeding section variables 
  RefreshController refreshController=RefreshController();
  List<UserPost> userpost=[];
  int size=5;

  //Reaction
  late UserReaction _userReaction;


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
                        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(user: _CurrentUser,)));},
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

              //This is the feeding part of the page:
              
              Container(
                height:MediaQuery.of(context).size.height*0.699,
                //color: Colors.blue,
                child:SmartRefresher(
                  onLoading: ()async{
                        Database db=Database(uid: _CurrentUser.uid);
                        size+=5;
                        //print(size);
                        final currently=userpost.length;
                        userpost=await db.getFeedingData(size);
                        size=userpost.length;
                        if(currently==size){
                          refreshController.loadNoData();
                        }else{
                          refreshController.loadComplete();
                        }

                    setState(() {
                      
                    });
                  },
                  onRefresh: ()async{
                        Database db=Database(uid: _CurrentUser.uid);
                        size+=5;
                        final currently=userpost.length;
                        userpost=await db.getFeedingData(size);
                        size=userpost.length;
                        if(currently==size){
                          refreshController.refreshToIdle();
                        }else{
                          refreshController.refreshCompleted();
                        }
                    setState(() {
                      
                    });
                  },
                  controller: refreshController,
                  enablePullUp: true,
                  child: ListView.builder(
                    itemCount: userpost.length,
                    itemBuilder:(context,index){
                      final currentdata=userpost[index];
                      print(currentdata.reaction.isreacted);
                      //print('here  are the data: ${currentdata.postId}');
                      return CustomCard(currentdata,index);
          
                    }
                  ),
                ),
              )
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
    userpost=await db.getFeedingData(size);
    _userReaction=UserReaction(user: uid);
    setState(() {
      initialization=true;
    });
  }
  Future<String> getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    return result;
  }

  Widget CustomCard(UserPost currentdata,index){
    return Container(
    //height:MediaQuery.of(context).size.height*0.5,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Divider(color: Colors.black,),
          HeaderProfile(currentdata.profile),
          Container(
            width: MediaQuery.of(context).size.width*1,
            child: currentdata.isImage?
            Container(
            height: MediaQuery.of(context).size.height*0.5,
            child: Image(image:NetworkImage(currentdata.imgUrl),fit: BoxFit.cover,)):
            Container(),
          ),
          SizedBox(height: 10,),
          Container(
            child: currentdata.isText?
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child:Text(currentdata.text,
              style: TextStyle(
                fontSize: 18,
              ),
            )):
            Container(),
          ),
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentdata.time.toString().substring(11,16)),
                Text(currentdata.time.toString().substring(0,11)),
              ],
            ),
          ),
          ReactionButtons(currentdata, index),
          Divider(color: Colors.black,)
        ],
      ),
    );
  }

  Widget HeaderProfile(CUser user){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:NetworkImage(user.profile),
                ),
              ),
              SizedBox(width: 10,),
              Text(user.username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Icon(FontAwesomeIcons.chevronDown),
          )
        ],
      ),
    );
  }

  Widget ReactionButtons(UserPost currentdata,index){
       return     Container(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                Column(
                  children: [
                    MaterialButton(
                    child:Icon(FontAwesomeIcons.heart,color: Colors.red[200],),
                    minWidth: MediaQuery.of(context).size.width*.16,
                    color:currentdata.reaction.type=='Heart'? Colors.red:Colors.white,
                    elevation: 0,
                    onPressed: ()async{
                    await _userReaction.ReactingMethod(currentdata.postId,currentdata.uid,'Heart');
                     ReactionData reactionData=await _userReaction.reactionData(currentdata.postId,currentdata.uid);
                     currentdata.reaction=reactionData;
                     setState(() {
                       //print(currentdata.reaction.hearted);
                       //print(reactionData.hearted);
                     });
                    },
                    ),
                    Text(currentdata.reaction.hearted.toString()),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                    child:Icon(FontAwesomeIcons.heartBroken,color: Colors.red,),
                    minWidth: MediaQuery.of(context).size.width*.16,
                    color: currentdata.reaction.type=='heartBroken'?Colors.red[100]:Colors.white,
                    elevation: 0,
                    onPressed: ()async{
                    await _userReaction.ReactingMethod(currentdata.postId,currentdata.uid,'heartBroken');
                    ReactionData reactionData=await _userReaction.reactionData(currentdata.postId,currentdata.uid);
                     currentdata.reaction=reactionData;
                     setState(() {
                       
                     });
                    },
                    ),
                    Text(currentdata.reaction.heartBorken.toString()),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                    child:Icon(FontAwesomeIcons.smile,color: Colors.yellow,),
                    minWidth: MediaQuery.of(context).size.width*.16,
                    color: currentdata.reaction.type=='smile'?Colors.yellow[100]:Colors.white,
                    elevation: 0,
                    onPressed: ()async{
                      await _userReaction.ReactingMethod(currentdata.postId,currentdata.uid,'smile');
                      ReactionData reactionData=await _userReaction.reactionData(currentdata.postId,currentdata.uid);
                      currentdata.reaction=reactionData;               
                        setState(() {
                          
                        });}
                    ),
                    Text(currentdata.reaction.smile.toString()),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(child:Icon(FontAwesomeIcons.thumbsUp,color: Colors.green,),
                    minWidth: MediaQuery.of(context).size.width*.16,
                  color:currentdata.reaction.type=='thumbup'?Colors.green[100]:Colors.white,
                  elevation: 0,
                    onPressed: ()async{
                          await _userReaction.ReactingMethod(currentdata.postId,currentdata.uid,'thumbup');
                          ReactionData reactionData=await _userReaction.reactionData(currentdata.postId,currentdata.uid);
                          currentdata.reaction=reactionData;               
                            setState(() {
                              
                            });}
                    ),
                    Text(currentdata.reaction.thumbsUp.toString()),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                    child:Icon(FontAwesomeIcons.thumbsDown,color: Colors.black,),
                    minWidth: MediaQuery.of(context).size.width*.16,
                  color:currentdata.reaction.type=='thumbdown'? Colors.blue[100]:Colors.white,
                  elevation: 0,
                  onPressed: ()async{
                          await _userReaction.ReactingMethod(currentdata.postId,currentdata.uid,'thumbdown');
                          ReactionData reactionData=await _userReaction.reactionData(currentdata.postId,currentdata.uid);
                          currentdata.reaction=reactionData;               
                            setState(() {
                              
                            });
                    },
                    ),
                    Text(currentdata.reaction.thumbsDown.toString()),
                  ],
                ),
                MaterialButton(onPressed: (){},child:Icon(FontAwesomeIcons.comment,color: Colors.blue,),
                minWidth: MediaQuery.of(context).size.width*.16,),
              ],)
          );
  }
  

}


