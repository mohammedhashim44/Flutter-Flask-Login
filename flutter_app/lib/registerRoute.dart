import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'API.dart';

class RegisterRoute extends API {
  @override
  RegisterRouteState createState() => RegisterRouteState();
}

class RegisterRouteState extends APIState {

  String URL ;
  String URLSuffix = "register" ;

  String appBarTitle = "Registration" ;

  var messages = {
    "success" : {"dialogHead":"Registration completed",
                  "dialogMessage":"You can now log in"} ,
    "failure" : {"dialogHead" : "Registration error"}
  } ;


  @override
  onSuccess() async {
    // When registration success, display message
    // then navigate to login page

    setState(() {
      dialogHead = messages["success"]["dialogHead"] ;
      dialogMessage = messages["success"]["dialogMessage"] ;
      success = true ;
    });
    showAlertDialog();
    //Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void onDialogPressed() {
    if(success){
      // Close the dialoge
      Navigator.pop(context) ;

      //Route to login page
      Navigator.pushReplacementNamed(context, '/login') ;
    }
    else{
      Navigator.pop(context) ;
    }
  }

  @override
  Map<String, String> getBody() {
    return {"username": username,"fullname":fullname, "password": password, "email": email};
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
                height: 80.0,
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Fullname"),
                  validator: (value) {
                    return value.isNotEmpty ? null : "Empty Fullname";
                  },
                  onSaved: (val) => fullname = val,
                ),
              ),
              new SizedBox(
                height: 80.0,
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) {
                    return value.isNotEmpty ? null : "Empty email";
                  },
                  onSaved: (val) => email = val,
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
                onPressed: super.submit,
                child: Text("Register"),
              ),
              new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Already registered ? "),
                      new InkWell(
                        onTap: (){
                          Navigator.pushReplacementNamed(context, "/login") ;
                        },
                        child: new Text(
                          "Log in now",
                          style: new TextStyle(color: Colors.blueAccent),

                        ),
                      )
                    ],
                  ))
            ],
          ),
        )) ;
  }
}