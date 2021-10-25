// ignore_for_file: prefer_const_constructors

import 'package:bunamedia/Pages/services/pref.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({ Key? key }) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore>  with AutomaticKeepAliveClientMixin{
  bool current=false;

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
      body:current==true?Center(
        child:Text("Explore Page"),
      ):CircularProgressIndicator() ,
    );
  }

  Future<String> getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    print(result);

    current=true;
    setState(() {
    });
    return result;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}