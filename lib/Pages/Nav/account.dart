// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bunamedia/Pages/services/pref.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({ Key? key }) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with AutomaticKeepAliveClientMixin{
  String CurrentUser='';
  Future<String> getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    print(result);
    CurrentUser=result;
    return CurrentUser;
  }

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future:getCurrentUser(),
          builder:(context, snapshot){
            if(snapshot.connectionState==ConnectionState.done)
            {
              return Profile(snapshot.data.toString());
            }else{
              return CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }

  Widget Profile(String user){
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
                  backgroundColor:Colors.orange,
                  child: Text("Profile"),
                  radius: 70,
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
            height: MediaQuery.of(context).size.height*0.3 ,
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
}