import 'package:flutter/material.dart';

typedef void SubmitFunction();

class SubmitButtonWidget extends StatelessWidget {
  SubmitButtonWidget({
    @required this.onTap,
    this.title = "Default Title",
  });
  final SubmitFunction onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}