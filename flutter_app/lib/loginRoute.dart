import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert' as convert;
import 'API.dart';

class LoginRoute extends API {
  @override
  LoginRouteState createState() => LoginRouteState();
}

class LoginRouteState extends APIState {


  String URL ;
  String URLSuffix = "login" ;
  String appBarTitle = "Login" ;

  var messages = {
    "success" : {"dialogHead":"","dialogMessage":""} ,
    "failure" : {"dialogHead" : "Login error"}
  } ;

  @override
  void onDialogPressed() {
    if(success == false)
      Navigator.pop(context) ;
  }

  @override
  onSuccess() async {
    // When login success, save the data ,
    // navigate to ProfilePage
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", true);

    sharedPreferences.setString("username", responseData["data"]["user"]["username"]);
    sharedPreferences.setString("fullname", responseData["data"]["user"]["fullname"]);
    sharedPreferences.setString("email", responseData["data"]["user"]["email"]);


    Navigator.pushReplacementNamed(context, '/profile') ;
  }

  @override
  Map<String, String> getBody() {
    return {"username": username, "password": password};
  }

  @override
  Widget getForm() {
    return new Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(32.0),
          child: new Column(
            children: <Widget>[
              new SizedBox(
                height: 80.0,
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Username"),
                  validator: (value) {
                    return value.isNotEmpty ? null : "Empty Username";
                  },
                  onSaved: (val) => username = val,
                ),
              ),
              new SizedBox(
                height: 90.0,
                child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) {
                      return value.isNotEmpty ? null : "Empty Password";
                    },
                    onSaved: (val) => password = val),
              ),
              new RaisedButton(
                onPressed: super.submit ,
                child: Text("Login"),
              ),
              new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("New usre ? "),
                      new InkWell(
                        onTap: (){
                          Navigator.pushReplacementNamed(context, "/register") ;
                        },
                        child: new Text(
                          "Register now",
                          style: new TextStyle(color: Colors.blueAccent),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        )
    );
  }

}
