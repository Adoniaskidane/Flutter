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

class _NetworkState extends State<Network> with AutomaticKeepAliveClientMixin{
  CUser _CurrentUser=CUser();
  bool initialization=false;
  TextEditingController search_controller=TextEditingController();
  CUser SearchedUsers=CUser();
  late Database db;

  //list of chats
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference ChatRoom = FirebaseFirestore.instance.collection('ChatRoom');
  List<LastMessage> messageuser=[];
  int currentTap=0;
  bool turncolor=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();

  }


  @override
  Widget build(BuildContext context) {
    super.build(context); 
    //oldMessageLoad();
    return Scaffold(


      body: SafeArea(
        child:Column(
          children: [
            Expanded(
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

                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*.819,
                        child:Column(
                          children: [
                            Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            height: MediaQuery.of(context).size.height*0.08,
                            width:  MediaQuery.of(context).size.width,
                            child: TextField(
                              controller: search_controller,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText:"Search username",
                              ),
                              style: TextStyle(fontSize: 18),
                              onChanged: (value){
                                SearchUsers(value);
                              },
                            ),
                          ),
                          Container(
                            child: Stack(children: [
                            search_controller.text.isEmpty?Container():
                            Container(
                              color: Colors.pink,
                          child: GestureDetector(
                          child: UserExplore(SearchedUsers),
                          onTap: (){
                            print('${_CurrentUser.username} and ${SearchedUsers.username}');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(cuser: _CurrentUser, user: SearchedUsers)));
                          },
                        ),
                      ),




                            ],),
                          ),
                          initialization==true?
                            buildMessage():
                            CircularProgressIndicator() 
                            ,
                          ],
                        ) ,
                      ),
                    ),


                ],
              ),
            ),

    

          ],
        ),
      ),
      /*
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
              Expanded(child: Column(
                children: [
                Container(
                  //color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      height: MediaQuery.of(context).size.height*0.08,
                      width:  MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: search_controller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText:"Search username",
                        ),
                        style: TextStyle(fontSize: 18),
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
                      ),
                  buildMessage(),
                ],
              ),)
              //if userData not initialized
              :Center(child: CircularProgressIndicator(),)
          ],
        ),
      )*/
    );
  }


 void getUserData()async{
    _CurrentUser.uid=await getCurrentUser();
    final uid=_CurrentUser.uid;
    db=Database(uid: uid);
    _CurrentUser=await db.getUser();
    await oldMessageLoad();
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




  Future<bool> oldMessageLoad()async{
      final referenceUserChat=users.doc(_CurrentUser.uid).collection('Chatters');
      final refSnapshots=await referenceUserChat.get(); 
      List<LastMessage> localmessageuser=[];
      if(refSnapshots.docs.isEmpty){
        return false;
      }else{
        final refdata=refSnapshots.docs;
        for(int i=0;i<refSnapshots.docs.length;i++){
        DocumentReference ref=refdata[i].data()['ChatterRef'];
        String ChatterID=refdata[i].data()['ChatterID'];
        final Querysnapshot=await ref.collection('Chats').limit(1).orderBy('Time',descending: true).get();
        //print(ChatterID);
        String uuid=Querysnapshot.docs[0].get('Sender');
        String mes=Querysnapshot.docs[0].get('Text');
        Timestamp time=Querysnapshot.docs[0].get('Time');

        messages lastmessage=messages(userID: uuid, message: mes, time: time.toDate());
        CUser ChatUser=(await db.BuildEachUser(ChatterID))!;
        localmessageuser.add(LastMessage(chatter: ChatUser,lastMessage: lastmessage));
        //Create messages and users profile and added to the list, if you can put them both together in List
      }
      messageuser=localmessageuser;
      messageuser.sort((a,b)=>b.lastMessage.time.compareTo(a.lastMessage.time));
        return true;      
      }
      
  }


  Widget buildMessage(){
    return Expanded(
      child: Container(
       height: MediaQuery.of(context).size.height*.739,
       width: MediaQuery.of(context).size.width,
  
        child: ListView.builder(
          itemCount: messageuser.length,
          itemBuilder: (context,index){
            final current=messageuser[index];
            return GestureDetector(
              
              onTapDown: (value){
                currentTap=index;
                turncolor=true;
                setState(() {
                  
                });
              },
              onTapUp: (value){
                turncolor=false;
                setState(() {
                  
                });
              },
              onTap: ()async{
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(cuser: _CurrentUser, user:messageuser[index].chatter)));
              await oldMessageLoad(); 
              setState(() {
                
              });
              
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 20),
                color:index==currentTap && turncolor?Colors.blue:Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            CircleAvatar(
                            backgroundImage: NetworkImage(current.chatter.profile),
                            radius: 25, 
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(current.chatter.username,
                                style: TextStyle(fontSize: 20),),
                                SizedBox(height: 10,),
                                Container(
                                  width: MediaQuery.of(context).size.width*.6,
                                  child: Text(current.lastMessage.message,overflow: TextOverflow.ellipsis,))
                              ],
                            ),
                          ],
                        ),
            
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(current.lastMessage.time.toString().substring(11,16)),
                        ),
                      ],
                    ),
            
                    Divider()
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}