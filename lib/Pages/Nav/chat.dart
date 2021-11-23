// ignore_for_file: prefer_const_constructors

import 'package:bunamedia/Pages/services/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final CUser cuser,user;
  const ChatPage({ Key? key,required this.cuser,required this.user }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(CurrentUser:cuser,Chatter: user);
}

class _ChatPageState extends State<ChatPage> {
  CollectionReference ChatRoom = FirebaseFirestore.instance.collection('ChatRoom');
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  int size=0;
  List<messages> allMessage=[];
  bool Messageinit=false;
  final CUser CurrentUser,Chatter;
  TextEditingController text_controller=TextEditingController();
  _ChatPageState({required this.CurrentUser,required this.Chatter});
  final formkey=GlobalKey<FormState>();
  ScrollController _scrollController=ScrollController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadChats();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    text_controller.dispose();
    print('Everything Desposed');
  }
  @override
  Widget build(BuildContext context) {  
    
    return Scaffold(
appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage:NetworkImage(
                Chatter.profile
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Chatter.username
                ),
                Text(
                  'online',
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.videocam_outlined,
                size: 28,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.call,
                size: 28,
              ),
              onPressed: () {})
        ],
        elevation: 0,
      ),
    

      body:GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child:ChatBuilder(),)
              ),
              Container(
                  child: TextField(
                    controller: text_controller,
                  ),
              ),
      
              Container(
                child: MaterialButton(
                  onPressed: ()async{
                    final sendingText=text_controller.text;
                    text_controller.clear();
                    print(sendingText);
                    if(sendingText.isNotEmpty){
                      final referenceUserChat=users.doc(CurrentUser.uid).collection('Chatters');
                      final referenceChatterChat=users.doc(Chatter.uid).collection('Chatters');
                      final result=await referenceUserChat.where('ChatterID',isEqualTo: Chatter.uid).get();
                      if(result.docs.isEmpty){
                        //create a chatroom id and get refrence
                        final Roomref=await ChatRoom.doc();
                        //set the created data so that it will have data and will be created
                        await Roomref.set({'Created':DateTime.now(),'user1':CurrentUser.uid,'user2':Chatter.uid});
                        //Take that ChatroomID to the user collection and set it chatter doc
                        referenceUserChat.doc(Chatter.uid).set({'ChatterID':Chatter.uid,'ChatterRef':Roomref});
                        //Set it to Chatter profile
                        referenceChatterChat.doc(CurrentUser.uid).set({'ChatterID':CurrentUser.uid,'ChatterRef':Roomref});
                        Roomref.collection('Chats').doc().set({'Sender':CurrentUser.uid,'Text':sendingText,'Time':DateTime.now()});
                      }else{
                        DocumentReference Roomref=result.docs[0].data()['ChatterRef'];
                        final refs=await Roomref.collection('Chats').get();
                          print(refs.size);
                        Roomref.collection('Chats').doc().set({'Sender':CurrentUser.uid,'Text':sendingText,'Time':DateTime.now()});
                        await LoadChats();
                      }
                    }
                  },
                  child: Icon(FontAwesomeIcons.paperPlane),
                ),
              )
            ],
          ),
        ),
      ),
      
    );
  }

  Future<void> LoadChats()async{
    final referenceUserChat=users.doc(CurrentUser.uid).collection('Chatters');
    final referenceChatterChat=users.doc(Chatter.uid).collection('Chatters');
    final result=await referenceUserChat.where('ChatterID',isEqualTo: Chatter.uid).get();
    DocumentReference Roomref=result.docs[0].data()['ChatterRef'];
    if(result.docs.isEmpty){
      size=0;
      setState(() {
        print(allMessage.length);
        Messageinit=true;
      });
    }
    else{
      final res=await Roomref.collection('Chats').orderBy('Time').get();
      print(res.size);
      size=res.size;
      print(res.docs[0].data());
      res.docs.forEach((element){
          String userID=element.data()['Sender'];
          String text=element.data()['Text'];
          Timestamp time=element.data()['Time'];
          time.toDate();
          allMessage.add(messages(userID: userID, message: text, time:time.toDate()));
      });
      setState(() {
        print(allMessage.length);
        Messageinit=true;
      });

    }
  }


  Widget ChatBuilder(){
      return Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height*0.2,
              child:Messageinit==false?Container(
                child: Center(child: Text('Loading...'),),
              ):
              Container(
                child: size==0?Container(
                  child: Text('Say Something'),
                ):
                Container(
                  child:ListView.builder(
                    reverse: true,
                    itemCount: size,
                    itemBuilder: (context,index){
                    return Text(allMessage[index].message,style: TextStyle(fontSize: 30),);
                  },
                )
              ),
              
      ));

  }
}