import 'package:flutter_user_auth/flutter_user_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as https;
import 'package:dart_casing/dart_casing.dart';
import 'dart:convert';
import 'package:flutter_user_auth/widgets/BackButton.dart';
import 'package:flutter_user_auth/widgets/EntryField.dart';
import 'package:flutter_user_auth/widgets/Logo.dart';
import 'package:flutter_user_auth/widgets/SubmitButton.dart';
import 'package:flutter_user_auth/screens/Login.dart';
import 'package:flutter_user_auth/res/values/Strings.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static String nameTitle = "Name";
  static String mobileNumberTitle = "Mobile Number";
  static String emailIdTitle = "Email Id";
  static String passwordTitle = "Password";

  String signUpMessage = Strings.EMPTY_STRING;

  final _formKey = GlobalKey<FormState>();
  var inputs = Map<String, String>();
  bool isProcessing = false;

  void _registerWithEmail() async {
    setState(() {
      signUpMessage = Strings.EMPTY_STRING;
    });
    FocusScope.of(context).unfocus();
    bool isValid = _formKey.currentState.validate();
    if (!isValid) return;

    _formKey.currentState.save();
    String nameInput = inputs[nameTitle];
    String emailIdInput = inputs[emailIdTitle];
    String mobileNumberInput = inputs[mobileNumberTitle];
    String passwordInput = inputs[passwordTitle];

    setState(() {
      isProcessing = true;
    });
    var response = await https.post(UserAuth.authConfig.registerConfig.endPoint,
        body: jsonEncode({
          "userType": UserAuth.authConfig.registerConfig.userType,
          Casing.camelCase(nameTitle): nameInput,
          Casing.camelCase(emailIdTitle): emailIdInput,
          Casing.camelCase(mobileNumberTitle): mobileNumberInput,
          Casing.camelCase(passwordTitle): passwordInput
        }));
    Map<String, dynamic> responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      await UserAuth.saveAuthToken(responseBody[Strings.AUTH_TOKEN]);
      Toast.show(Strings.REGISTERED_MESSAGE, context);
      Navigator.pop(context);
      return;
    }
    String message = responseBody[Strings.MESSAGE];
    if (response.statusCode == 400) {
      setState(() {
        isProcessing = false;
        signUpMessage = message;
      });
      return;
    }
    Navigator.pop(context);
    Toast.show(message, context);
  }

  void _onSave(String title, String input) {
    inputs[title] = input;
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Text(
              'Login',
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

  // TODO: Take input from UserAuth RegisterConfig
  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        EntryFieldWidget(
          title: nameTitle,
          validationFunction: EntryFieldValidator.emptyValidator,
          onSave: _onSave,
        ),
        EntryFieldWidget(
          title: mobileNumberTitle,
          isNumber: true,
          validationFunction: EntryFieldValidator.mobileNumberValidator,
          onSave: _onSave,
        ),
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: isProcessing
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    signUpMessage = Strings.EMPTY_STRING;
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
                              child: signUpMessage.isNotEmpty
                                  ? Center(
                                      child: Text(
                                        signUpMessage,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            SubmitButtonWidget(
                              onTap: _registerWithEmail,
                              title: 'Register Now',
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _loginAccountLabel(),
                      ),
                      Positioned(top: 40, left: 0, child: BackButtonWidget()),
                    ],
                  ),
                ),
              )));
  }
}
