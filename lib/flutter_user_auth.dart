library flutter_user_auth;

import 'package:flutter/material.dart';
import 'screens/Login.dart';
import 'screens/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'res/values/Strings.dart';

class UserAuth {
  static AuthConfig authConfig;
  static bool isLogged = false;

  static Future<void> initialize (AuthConfig authConfig) async{
    UserAuth.authConfig = authConfig;
    String authToken = await getAuthToken();
    if(authToken == null)
      isLogged = false;
    else
      isLogged = true;
  }

  static Future<void> login(BuildContext context) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  static Future<void> signUp(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  static Future<void> logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Strings.AUTH_TOKEN);
    isLogged = false;
  }

  static Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(Strings.AUTH_TOKEN);
    return authToken;
  }

  static Future<void> saveAuthToken(String authToken) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Strings.AUTH_TOKEN, authToken);
    isLogged = true;
  }
}

class LoginConfig {
  String endPoint;
  var params = <String>[];

  LoginConfig({
    @required this.endPoint,
    this.params = const ['Email Id', 'Password'],
  });
}

class RegisterConfig {
  String endPoint;
  String userType;
  var params = <String>[];

  RegisterConfig({
    @required this.endPoint,
    @required this.userType,
    this.params = const ['Name, Mobile Number, Email Id, Password'],
  });
}

class AuthConfig {
  LoginConfig loginConfig;
  RegisterConfig registerConfig;
  bool saveUser;
  Widget logo;

  AuthConfig({
    @required this.loginConfig,
    @required this.registerConfig,
    this.saveUser = true,
    this.logo,
  });
}
