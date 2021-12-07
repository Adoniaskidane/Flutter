// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bunamedia/Pages/services/reaction.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final CUser currentuser;
  const UserProfile({ Key? key, required this.currentuser}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState(user: currentuser);
}

class _UserProfileState extends State<UserProfile> {
  final CUser user;
  bool loaded=false;
  late UserReaction _userReaction;
  late String backgroundImg;
  List<UserPost> mypost=[];

  _UserProfileState({required this.user});
  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("BunaMedia",
                    style :TextStyle(
                      color: Colors.white,
                      fontFamily: 'Times',
                      fontSize: 20
                    ),
                  ),
          centerTitle: true,
      ),
      body:SafeArea(
        child: Column(
          children: [
            loaded==true?CustomBody():
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),      
    );
  }

  Widget CustomBody(){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*.815,
        child: ListView(
          children: [
            HeaderPage(),
            UsernameLabel(user.first+' '+user.last),
            personalPost()
          ],
        ),
    );
  }

    Widget UsernameLabel(String name){
    return   Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height*.05,
                width:  MediaQuery.of(context).size.width,
                color: Colors.black87,
                child: Text(name,
                    style :TextStyle(
                      color: Colors.white,
                      fontFamily: 'Times',
                      fontSize: 20
                    ),
                  ),
              );
  }

    Widget HeaderPage(){
    return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red,
                  child: Image(image:NetworkImage(backgroundImg),fit: BoxFit.fitWidth,),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width*0.3,
                  top:MediaQuery.of(context).size.height*0.05 ,
                  child: CircleAvatar(
                    backgroundImage:NetworkImage(user.profile) ,
                    radius: 70,
                  ),
                ),
              ],
    );
  }



   Widget personalPost(){
    return  Container(
        //color: Colors.orange,
          child:ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: mypost.length,
              itemBuilder:(context,index){
                final currentdata=mypost[index];
                return CustomCard(currentdata,index);
              }
            ),
          
        
      );;
  }

Widget CustomCard(UserPost currentdata,index){
    return Container(
    //height:MediaQuery.of(context).size.height*0.5,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Divider(color: Colors.black,),
          HeaderProfile(currentdata.profile),
          GestureDetector(
            onDoubleTap: ()async{
                      await _userReaction.ReactingMethod(currentdata.postId,currentdata.uid,'Heart');
                     ReactionData reactionData=await _userReaction.reactionData(currentdata.postId,currentdata.uid);
                     currentdata.reaction=reactionData;
                     setState(() {
                       //print(currentdata.reaction.hearted);
                       //print(reactionData.hearted);
                     });
            },
            child: Container(
              width: MediaQuery.of(context).size.width*1,
              child: currentdata.isImage?
              Container(
              height: MediaQuery.of(context).size.height*0.5,
              width:MediaQuery.of(context).size.width,
              child: Image(image:NetworkImage(currentdata.imgUrl),fit: BoxFit.cover,)):
              Container(),
            ),
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
  Future<void>  getUserData()async{
    backgroundImg =await backgroundURL();
    _userReaction=UserReaction(user:user.uid);
    mypost=await getFeedingData(5);
    setState(() {
      loaded=true;
    });
   }


  Future<String> backgroundURL()async{
     String url;
      final refpersonal = FirebaseStorage.instance.ref().child(user.uid).child('BackgroundProfile').child('BackgroundProfile');
      final refdefault = FirebaseStorage.instance.ref().child('Defalut').child('background1.png');
      final data=await FirebaseStorage.instance.ref().child(user.uid).child('BackgroundProfile').listAll();
      if(data.items.isNotEmpty){
        var url = await refpersonal.getDownloadURL();
        return url;
      }else{
        var url = await refdefault.getDownloadURL();
        return url;
      }
   }

Future<List<UserPost>> getFeedingData(int size)async{
    CollectionReference userdata = FirebaseFirestore.instance.collection('Users').doc(user.uid).collection('Post');
    List<UserPost> userposts=[];

    final value=await userdata.limit(size).orderBy('Time',descending: true).get();
    for(int i=0;i<value.size;i++){
      UserPost post;
      final b=value.docs[i];
      final postid=value.docs[i].id;
      print(b.data());
      final isImage=b.get('isImage');
      final isText=b.get('isText');
      final time=b.get('Time');
      Timestamp t=time;
      DateTime newtime=t.toDate();
      UserReaction reaction=UserReaction(user:user.uid);
      ReactionData reactionData=await reaction.reactionData(postid,user.uid);
      post=UserPost(isImage: isImage,isText: isText,time: newtime,profile: user,reaction: reactionData);
      post.uid=user.uid;
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
    return userposts;
  }

}





