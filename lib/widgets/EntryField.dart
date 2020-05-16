import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

typedef String Validator(String text);
typedef void ValidityUpdater(String text, bool isValid);
typedef void SaverFunction(String title, String input);

class EntryFieldWidget extends StatefulWidget {
  EntryFieldWidget({
    @required this.title,
    this.isPassword = false,
    this.isNumber = false,
    this.validationFunction = EntryFieldValidator.noValidator,
    this.onSave,
  });
  final String title;
  final bool isPassword;
  final bool isNumber;
  final Validator validationFunction;
  final SaverFunction onSave;
  @override
  _EntryFieldWidgetState createState() =>
      _EntryFieldWidgetState(obscureText: isPassword);
}

class _EntryFieldWidgetState extends State<EntryFieldWidget> {
  _EntryFieldWidgetState({
    this.obscureText,
  });
  bool obscureText;
  FocusNode _focusNode = FocusNode();
  GlobalKey<FormFieldState> key = new GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      key.currentState.validate();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: TextFormField(
        key: key,
        keyboardType:
            widget.isNumber ? TextInputType.numberWithOptions() : null,
        focusNode: _focusNode,
        obscureText: obscureText,
        textInputAction: TextInputAction.next,
        validator: widget.validationFunction,
        onSaved: (String input){
          widget.onSave(widget.title, input);
        },
        decoration: InputDecoration(
          labelText: widget.title,
          border: InputBorder.none,
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xfff3f3f4))),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          focusedErrorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          fillColor: Color(0xfff3f3f4),
          filled: true,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  })
              : null,
        ),
        onFieldSubmitted: (String text) {
          bool isValid = key.currentState.validate();
          if (isValid) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}

class EntryFieldValidator {
  static String emailIdValidator(String email) {
    bool valid = EmailValidator.validate(email);
    if (valid) return null;
    return "Please enter valid Email ID";
  }

  static String mobileNumberValidator(String phone) {
    if (int.tryParse(phone) != null && phone.length == 10) return null;
    return "Please enter valid Mobile number";
  }

  static String emptyValidator(String text) {
    if (text.isNotEmpty) return null;
    return "Required Field";
  }

  static String noValidator(String text) {
    return null;
  }

  static String passwordValidator(String password) {
    if (password.length < 8) {
      return "Password should be 8 characters long";
    }
    return null;
  }
}
