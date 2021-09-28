import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class API extends StatefulWidget {
  @override
  APIState createState() => APIState();
}

class APIState extends State<API> {

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final formKey = GlobalKey<FormState>();
    SharedPreferences sharedPreferences;

    var success = false;
    Map<String,Map<String,String>> messages ;

    String username ;
    String fullname ;
    String password ;
    String email ;

    String appBarTitle = "" ;
    String URL = "";
    String URLSuffix = "" ;

    bool apiCall = false;


    String dialogHead = "";
    String dialogMessage = "";

    dynamic responseData ;


    @override
  void initState() {
    super.initState();

    loadURL();
  }
    void loadURL() async{
      sharedPreferences = await SharedPreferences.getInstance() ;
      String settingURL = sharedPreferences.getString("URL") ?? "http://192.168.1.1:5000/API/" ;
      setState(() {
        URL = settingURL + URLSuffix ;
      });
    }

    void submit() async {
      print("$URL") ;
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        process();
      }
    }

    // Show or hide the progress indicator
    void progressIndicator(bool status) {
      // If it was calling the api and now it's false
      // that means the request has completed , and so , close the dialog
      if (apiCall == true && status == false)
        Navigator.pop(context);
      setState(() {
        apiCall = status;
      });
      showIndicator();
    }

    void showIndicator() {
      if (apiCall) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return Dialog(
              child: Container(
                  height: 100.0,
                  child: new Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new CircularProgressIndicator(),
                        new Text("Loading"),
                      ],
                    ),
                  )),
            );
          },
        );
      }
    }


    Future<http.Response> getResponse(String url, Map<String, String> body) async {
      var response =
      await http.post(url, body: body);
      return response;
    }

    void getWidget() {}

    onSuccess(){
    }

    void onDialogPressed(){
    }


    Map<String,String> getBody(){
    }

    void process() async {
      var body = getBody();
      progressIndicator(true);
      var response ;
      var connected = true ;
      try{
        response = await getResponse(URL, body);
      }
      catch(e){
        connected = false ;
      }
      progressIndicator(false);
      if(connected){
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          var status = jsonResponse['status']['type'];
          if (status == 'failure') {
            setState(() {
              dialogHead = messages["failure"]["dialogHead"] ;
              dialogMessage = jsonResponse['status']['message'];
              success = false ;
            });
            showAlertDialog();
            print(body) ;
            print(response.body) ;
          } else {
            responseData = jsonResponse;
            onSuccess();
          }
        }
      } else {
        setState(() {
          dialogHead = "Connection Error";
          dialogMessage = "Check connection and try again";
        });
        showAlertDialog();
      }
    }


    void showAlertDialog() {
      /*showDialog(
        context: context,
        child: new AlertDialog(
          title: Text(dialogHead),
          content: Text(dialogMessage),
          actions: [
            new FlatButton(
              child: const Text("Ok"),
              onPressed: onDialogPressed
            ),
          ],
        ),
      );*/
    }

    Widget getForm(){
    }

    @override
    Widget build(BuildContext context) {
      return new MaterialApp(

        home: new Scaffold(

          //resizeToAvoidBottomPadding: false,
          key: scaffoldKey,
          appBar: new AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(appBarTitle) ,
                InkWell(
                  child: Icon(Icons.settings),
                  onTap: (){
                    Navigator.pushNamed(context, '/settings') ;
                  },
                )
              ],
            )
          ),
          body: new Center(
            child: getForm()
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      );
    }
}
