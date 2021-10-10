import 'package:shared_preferences/shared_preferences.dart';
class Userpreference{
  Future<String> getUserprefrerence()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final result=preferences.getString("UserName")??"NoData";
    return result;
  }
  setUserprefrerence(String value)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final result=preferences.setString("UserName",value);
    print("Prefernce set to: "+ value);
    return result;
  }
  removeUserpreference() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final result=preferences.get("UserName");
    print(result);
    preferences.remove("UserName");
    return result;
  }

}