import 'package:shared_preferences/shared_preferences.dart';

class MyUtility {

  Future<String> findUserId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');
    print('workername === $workername');
    String userId = preferences.getString('id');

    return userId;
  }
  
}