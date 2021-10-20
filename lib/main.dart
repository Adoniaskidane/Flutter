import 'package:bunamedia/Pages/authentication/signin.dart';
import 'package:bunamedia/Pages/authentication/signup.dart';
import 'package:bunamedia/Pages/homepage.dart';
import 'package:bunamedia/Pages/loadpage.dart';
import 'package:bunamedia/Pages/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //When the app start user will land on Welcome Page.
      initialRoute: '/',
      routes: {
        '/welcome': (context) => const WelcomPage(),
        '/':(context) => const LoadScreen(),
        '/home':(context)=>const HomePage(),
        '/SignIn':(context)=>const SignInPage(),
        '/SignUp':(context)=>const SignUpPage(),
      },
    );
  }
}

