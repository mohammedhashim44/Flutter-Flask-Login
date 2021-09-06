import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRoute extends StatefulWidget {
  @override
  SettingsRouteState createState() => SettingsRouteState();
}

class SettingsRouteState extends State<SettingsRoute> {
  SharedPreferences sharedPreferences;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var URLController = TextEditingController();

  String formURL = "";

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String settingURL =
        sharedPreferences.getString("URL") ?? "http://192.168.1.1:5000";
    URLController.text = settingURL;
  }

  void save() async {
    formKey.currentState.save();
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("URL", formURL);

    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text("Saved"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Row(
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.chevron_left),
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                ),
                Text("Settings"),
              ],
            )),
            body: Container(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "URL",
                          textAlign: TextAlign.left,
                        ),
                        TextFormField(
                          controller: URLController,
                          onSaved: (value) => formURL = value,
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text("Save"),
                          onPressed: save,
                        )
                      ],
                    )))));
  }
}
