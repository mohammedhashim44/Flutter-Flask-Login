import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRoute extends StatefulWidget {
  @override
  ProfileRouteState createState() => ProfileRouteState();
}

class ProfileRouteState extends State<ProfileRoute> {
  SharedPreferences sharedPreferences;

  String email ;
  String username ;
  String fullname ;

  @override
  void initState() {
    setData();
  }

  void setData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      username = sharedPreferences.getString("username") ?? "Error";
      fullname = sharedPreferences.getString("fullname") ?? "Error";
      email = sharedPreferences.getString("email") ?? "Error";

    });
  }

  void _logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", false);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget getRow(String string,double textSize , double opacity){
    return Opacity(
      opacity: opacity,
      child:  new Container(
        margin: const EdgeInsets.only(top: 20.0),
        child : new Text(string ,
          style: new TextStyle(
              color: Colors.white ,
              fontSize: textSize
          ),
        ),
      ),
    ) ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Route'),
        actions: <Widget>[
          new Row(
            children: <Widget>[
              Text("Log out"),
              new IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: _logout,
              )
            ],
          )
        ],
      ),
      body: new Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        decoration:  new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
                colors: [Colors.blueAccent, Colors.deepPurple],
                tileMode: TileMode.repeated),
            borderRadius: BorderRadius.circular(10.0)),
        alignment: FractionalOffset.center,
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            new Container(
               child: Icon(Icons.person ,
                 color: Colors.white,
                 size: 100.0,
               ),
            ),
            getRow(username, 30.0, 1.0),
            getRow(fullname, 15.0, 0.6),
            getRow(email, 15.0, 0.6)

          ],
        ),
      ),
    );
  }
}
