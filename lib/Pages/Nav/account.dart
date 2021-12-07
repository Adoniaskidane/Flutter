// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:bunamedia/Pages/services/auth.dart';
import 'package:bunamedia/Pages/services/db.dart';
import 'package:bunamedia/Pages/services/reaction.dart';
import 'package:bunamedia/Pages/services/user.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Account extends StatefulWidget {
  const Account({ Key? key }) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with AutomaticKeepAliveClientMixin{

  CUser user=CUser();
  late String backgroundImg;
  bool loaded=false;
  late File _image;
  late File _background;
  List<UserPost> mypost=[];
  final picker = ImagePicker();
  late UserReaction _userReaction;
  UserAuthentication _authentication=UserAuthentication(FirebaseAuth.instance);

  @override
  void initState(){
   getUserData(); 
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body:SafeArea(
        child: Column(
          children: [
            BunaLabel(),
            loaded==true?CustomBody()://BodyPage(user.uid,user.profile):
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
            personalButtons(),
            personalPost()
          ],
        ),
    );
  }

  Widget BunaLabel(){
    return   Container(
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
                  color: Colors.purple,
                  child: Image(image:NetworkImage(backgroundImg),fit: BoxFit.cover,),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width*0.3,
                  top:MediaQuery.of(context).size.height*0.05 ,
                  child: CircleAvatar(
                    backgroundImage:NetworkImage(user.profile) ,
                    radius: 70,
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width*0.4,
                  top:MediaQuery.of(context).size.height*0.2 ,
                  child: ElevatedButton(
                    onPressed: ()async{
                      EditPicture();
                     /*print("pressed");
                      await getImage();
                      await uploadImage();
                      //await loadImage();
                      await getUserData();
                      setState((){      

                      });*/
                    },
                    child: Icon(FontAwesomeIcons.camera),
                  ),
                ),


                Positioned(
                  left: MediaQuery.of(context).size.width*0.8,
                  top:MediaQuery.of(context).size.height*0.02 ,
                  child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width*0.1,
                  height: MediaQuery.of(context).size.height*0.1,
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    color: Colors.white,
                    onPressed: (){
                      EditingBox();
                      //EditPicture();
                    },
                    child: Icon(Icons.settings,size: 35,)
                  ),
                ),
              
              /*Positioned(
                left: MediaQuery.of(context).size.width*0.1,
                top:MediaQuery.of(context).size.height*0.3,
                child:MaterialButton(
                  height: 30,
                  minWidth: 30,
                  color: Colors.white,
                  onPressed: ()async{
                    await getBackgroundImage();
                    await uploadBackgroundImage();
                    await getUserData();
                    setState((){
              
                    });

                  },
                  child:Icon(FontAwesomeIcons.image) ,
                ), 
              )*/
              ],
    );
  }


  Widget personalButtons(){
    return Container(
      //color: Colors.orange,
      child: Row(
        children: [
              Expanded(
                child: MaterialButton(
                  height: 50,
                  color: Colors.blueAccent[400],
                  onPressed: (){},
                  child:Text("Link") ,
                ),
              ),
              MaterialButton(
                  height: 50,
                  color: Colors.blueAccent[400],
                  onPressed: (){},
                  child:Text("Term and Condition") ,
                ),
              
              Expanded(
                child: MaterialButton(
                  height:50,
                  color: Colors.red,
                    onPressed: ()async{
                      final result=await _authentication.SignOut();
                      if(result){
                        keepLoggedOut();
                        Navigator.pushReplacementNamed(context,'/');
                      }
                    },
                    child:Text("SignOut"),
                  ),
              )
        ],
      ),
    );
  }

//list view need work
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
          
        
      );
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











  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  //Helper Functions
  Future<String> getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    user.uid=result;
    return result;
  }


  //Profile Images
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
    catch (e){
        print('unable to pick picture');
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


  //Background Image
  Future getBackgroundImage() async {
    final ImagePicker _picker=ImagePicker();
    try{
      final image=await _picker.pickImage(source:ImageSource.gallery);
      if(image==null){
        print("pick Image");
      }
      else{
        _background=File(image.path);
      }    
    }on PlatformException catch (e){
        print("Failed to pick image");
      }
    catch (e){
        print('unable to pick picture');
    }
  }

  Future<bool> uploadBackgroundImage() async{
    FirebaseStorage firebaseStorage=FirebaseStorage.instance;
    
    try{
    Reference storageref=firebaseStorage.ref().child(user.uid).child('BackgroundProfile').child('BackgroundProfile');
    UploadTask uploadTask=storageref.putFile(_background);
    TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => true);
     return true;
    }on FirebaseException catch (e){
      return false;
    }
  }

  void keepLoggedOut()async{
    Userpreference pref=Userpreference();
    await pref.removeUserpreference();
  }


  Future<void>  getUserData()async{
    user.uid=await getCurrentUser();
    Database db=Database(uid: user.uid);
    user=await db.getUser();
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
      final refdefault = FirebaseStorage.instance.ref().child('Defalut').child('profile.png');
      final data=await FirebaseStorage.instance.ref().child(user.uid).child('BackgroundProfile').listAll();
      if(data.items.isNotEmpty){
        var url = await refpersonal.getDownloadURL();
        return url;
      }else{
        var url = await refdefault.getDownloadURL();
        return url;
      }
   }


void EditingBox(){
  showDialog(
  context: context,
  builder: (BuildContext context){
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height*0.1,
            child: EditingBoxBody()
          ),

          Positioned(
            top: MediaQuery.of(context).size.height*0.01,
            left:  (MediaQuery.of(context).size.width*.4)-70,
            child:Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profile),
                radius: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
);
}

Widget EditingBoxBody(){
  return Container(
      width: MediaQuery.of(context).size.width*.8,
      height: MediaQuery.of(context).size.height*.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.15,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
          ),
          InfoContainer('Username', user.username),
          InfoContainer('FirstLast', user.first+" "+user.last),
          InfoContainer('Email',user.email),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.red,
                onPressed: (){Navigator.pop(context);},
                child: Text('Cancel',
                style: TextStyle(
                  fontSize: 25,
                ),
                ),
                height: 50,
                minWidth: 120,
              ),
            MaterialButton(
                color: Colors.green[600],
                onPressed: (){},
                child: Text('Edit',
                style: TextStyle(
                  fontSize: 25,
                ),
                ),
                height: 50,
                minWidth: 120,
              ),
            ],
          )
        ],
      ),
  );
}


Widget InfoContainer(key,value){
  return  Container(
            //color:Colors.orange,
            height: MediaQuery.of(context).size.height*.1,
            width:  MediaQuery.of(context).size.width,
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(value,
                  style: TextStyle(
                    fontSize:25,
                  ),
                  )
                ]
              ),
            ) ,
          );
}


void EditPicture(){
  showDialog(
  context: context,
  builder: (BuildContext context){
    return Dialog(
      child:Container(
        height: MediaQuery.of(context).size.height*0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              height: MediaQuery.of(context).size.height*.15,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: ()async{
                      Navigator.pop(context);
                      await getImage();
                      await uploadImage();
                      //await loadImage();
                      await getUserData();
                      setState((){      

                      });
              },
              child: Text('Profile',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),

            MaterialButton(
              height: MediaQuery.of(context).size.height*.15,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: ()async{
                    Navigator.pop(context);
                    await getBackgroundImage();
                    await uploadBackgroundImage();
                    await getUserData();
                    setState((){
              
                    });
              },
              child: Text('Background',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            MaterialButton(
              color:Colors.red,
              height: MediaQuery.of(context).size.height*.1,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('Back',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      )
    );
  }
);


}

}