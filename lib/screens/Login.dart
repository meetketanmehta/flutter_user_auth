import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as https;
import 'package:dart_casing/dart_casing.dart';
import 'dart:convert';
import 'package:flutter_user_auth/flutter_user_auth.dart';
import 'package:flutter_user_auth/widgets/BackButton.dart';
import 'package:flutter_user_auth/widgets/EntryField.dart';
import 'package:flutter_user_auth/widgets/Logo.dart';
import 'package:flutter_user_auth/widgets/SubmitButton.dart';
import 'package:flutter_user_auth/screens/SignUp.dart';
import 'package:flutter_user_auth/res/values/Strings.dart';

class Login extends StatefulWidget {
  final bool showSignUpButton;
  Login({this.showSignUpButton});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static String emailIdTitle = "Email Id";
  static String passwordTitle = "Password";

  String loginMessage = Strings.EMPTY_STRING;
  final _formKey = GlobalKey<FormState>();
  var inputs = new Map<String, String>();
  bool _isProcessing = false;

  void _loginWithEmail() async {
    setState(() {
      loginMessage = Strings.EMPTY_STRING;
    });
    FocusScope.of(context).unfocus();
    bool isValid = _formKey.currentState.validate();
    if (!isValid) return;

    _formKey.currentState.save();
    String emailIdInput = inputs[emailIdTitle];
    String passwordInput = inputs[passwordTitle];

    setState(() {
      _isProcessing = true;
    });
    var response = await https.post(UserAuth.authConfig.loginConfig.endPoint,
        body: jsonEncode({
          Casing.camelCase(emailIdTitle): emailIdInput,
          Casing.camelCase(passwordTitle): passwordInput
        }));
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await UserAuth.saveAuthToken(responseBody[Strings.AUTH_TOKEN]);
      Toast.show(Strings.LOGGED_IN_MESSAGE, context);
      Navigator.pop(context);
      return;
    }
    final String message = responseBody[Strings.MESSAGE];
    if (response.statusCode == 400) {
      setState(() {
        _isProcessing = false;
        loginMessage = message;
      });
      return;
    }
    Navigator.pop(context);
    Toast.show(message, context);
  }

  void _onSave(String title, String input) {
    inputs[title] = input;
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  // TODO: Make Facebook button rounded and add Google button
  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  // TODO: Take input from UserAuth LoginConfig
  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        EntryFieldWidget(
          title: emailIdTitle,
          validationFunction: EntryFieldValidator.emailIdValidator,
          onSave: _onSave,
        ),
        EntryFieldWidget(
          title: passwordTitle,
          isPassword: true,
          validationFunction: EntryFieldValidator.passwordValidator,
          onSave: _onSave,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blue,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isProcessing
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  onChanged: () {
                    setState(() {
                      loginMessage = Strings.EMPTY_STRING;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: SizedBox(),
                              ),
                              Logo(),
                              SizedBox(
                                height: 50,
                              ),
                              _emailPasswordWidget(),
                              SizedBox(
                                height: 50,
                                child: loginMessage.isNotEmpty
                                    ? Center(
                                        child: Text(
                                          loginMessage,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 15),
                                        ),
                                      )
                                    : null,
                              ),
                              SubmitButtonWidget(
                                onTap: _loginWithEmail,
                                title: 'Login',
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.centerRight,
                                child: Text('Forgot Password ?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ),
                              _divider(),
                              _facebookButton(),
                              Expanded(
                                flex: 2,
                                child: SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: (widget.showSignUpButton) ? _createAccountLabel() : null ,
                        ),
                        Positioned(top: 40, left: 0, child: BackButtonWidget()),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
