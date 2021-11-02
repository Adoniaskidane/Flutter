
import 'package:buna/welcome_page.dart';
import 'package:flutter/material.dart';

class loadingPage extends StatefulWidget {
  const loadingPage({Key? key}) : super(key: key);

  @override
  _loadingPageState createState() => _loadingPageState();
}

class _loadingPageState extends State<loadingPage> {
  @override

  void initState() {
    var d = Duration(seconds: 5);
    // delayed 3 seconds to next page
    Future.delayed(d, () {
      // to next page and close this page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WelcomePage();
          },
        ),
            (route) => false,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
          ),
        ),
        child: Center(
          //child: SvgPicture.asset('assets/icons/chat.svg'),
          child: Image(image: AssetImage('assets/images/b.png'),)
        ),
      ),
    );
  }
}

