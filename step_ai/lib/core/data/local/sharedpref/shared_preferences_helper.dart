import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_ai/core/data/local/sharedpref/constants/preferences.dart';

class SharedPreferencesHelper{
  final SharedPreferences _sharedPreferences;

  SharedPreferencesHelper(this._sharedPreferences);

  //Login:----------------------------------------------------------------------
  Future<bool> get isLoggedIn async{
    return _sharedPreferences.getBool(Preferences.isLoggedIn) ?? false;
  }

  Future<bool> saveIsLoggedIn(bool value){
    return _sharedPreferences.setBool(Preferences.isLoggedIn, value);
  }

}