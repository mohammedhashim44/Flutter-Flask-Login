import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String message;

  const AppDialog(
    this.title,
    this.titleColor,
    this.message, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
        ),
      ),
      content: Text(message),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Ok",
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String message;

  const SuccessDialog(this.message, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog("Success", Colors.green, message);
  }
}

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog(this.message, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog("Error", Colors.red, message);
  }
}

class AppLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Please wait ...",
      ),
      //content: new Text("Loading"),
      content: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Text("Loading"),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    );
  }
}
