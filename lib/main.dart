import 'package:bunamedia/Pages/homepage.dart';
import 'package:bunamedia/Pages/signin.dart';
import 'package:bunamedia/Pages/signup.dart';
import 'package:bunamedia/Pages/welcomepage.dart';
import 'package:flutter/material.dart';

void main() {
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
      //home: const WelcomPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomPage(),
        '/home':(context)=>const HomePage(),
        '/SignIn':(context)=>const SignInPage(),
        '/SignUp':(context)=>const SignUpPage(),
      },
    );
  }
}

