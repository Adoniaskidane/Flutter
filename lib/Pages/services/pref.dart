import 'package:shared_preferences/shared_preferences.dart';
class Userpreference{
  Future<String> getUserprefrerence()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final result=preferences.getString("identification")??"NoData";
    return result;
  }
  setUserprefrerence(String value)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final result=preferences.setString("identification",value);
    print("Prefernce set to: "+ value);
    return result;
  }
  removeUserpreference() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final result=preferences.get("identification");
    print(result);
    preferences.remove("identification");
    return result;
  }

}