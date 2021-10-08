import 'package:firebase_auth/firebase_auth.dart';

class UserAuthentication{

  final FirebaseAuth _firebaseAuth;
  UserAuthentication(this._firebaseAuth);

  Future<bool> SignUp(String email,String password) async{
    try{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password); 
    return true;
    }on FirebaseException catch(e){
      print(e.message);
      return false;
    }
  }
  Future<bool> SignIn(String email,String password) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return true;
    }on FirebaseException catch(e){
      print(e.message);
      return false;
    }
  }

}


class validator{
  
}