// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print
import 'dart:convert';
import 'package:bunamedia/Pages/Nav/account.dart';
import 'package:bunamedia/Pages/Nav/explore.dart';
import 'package:bunamedia/Pages/Nav/home.dart';
import 'package:bunamedia/Pages/Nav/network.dart';
import 'package:bunamedia/Pages/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String CurrentUser="";
  void keepLoggedOut()async{
    Userpreference pref=Userpreference();
    await pref.removeUserpreference();
  }
  void getCurrentUser() async{
    Userpreference pref=Userpreference();
    final result= await pref.getUserprefrerence();
    print(result);
    CurrentUser=result;
    setState(() {
      print("SetState");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("HomePage init");
    getCurrentUser();
    print("HomePage init Done");
    } 
      PageController _pageController=PageController();
      List<Widget> _screens=[Home(),Network(),Explore(),Account()];
      int currentPage=0;

      void _onpagechanged(int index){
        setState(() {
          currentPage=index;
          print("Setting the state");
        });
      }
      void _onpagetab(int index){
        print(index);
          _pageController.jumpToPage(index);
      }

    @override
    Widget build(BuildContext context) {
      print('Homepage Build');
    final res=(ModalRoute.of(context)?.settings.arguments);
    print("-----------");
    return Scaffold(
      body:PageView(
        controller:_pageController ,
        children:_screens,
        onPageChanged: _onpagechanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        onTap: _onpagetab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.braille,color: currentPage==0?Colors.blue:Colors.grey[600],),
            title: Text("Home",style: TextStyle(color: currentPage==0?Colors.blue:Colors.grey[600]),)
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.comments,color: currentPage==1?Colors.blue:Colors.grey[600]),
            title: Text("Market",style: TextStyle(color: currentPage==1?Colors.blue:Colors.grey[600]),)
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.users,color: currentPage==2?Colors.blue:Colors.grey[600],),
            title: Text("Explore",style: TextStyle(color: currentPage==2?Colors.blue:Colors.grey[600]))
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: currentPage==3?Colors.blue:Colors.grey[600],),
            title: Text("Account",style: TextStyle(color: currentPage==3?Colors.blue:Colors.grey[600]))
          ),
        ],
      ),
      drawer: Drawer(
        child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HomePage of $CurrentUser"),
            ElevatedButton(
              onPressed: (){
                keepLoggedOut();
                Navigator.pushReplacementNamed(context,'/');
              },
              child:Text("SignOut"),
            )
          ],
        ),
      ),
      ),
    );
  }
}