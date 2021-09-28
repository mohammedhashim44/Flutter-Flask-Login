import 'package:flutter/material.dart';
import 'package:flutter_flask_login/src/repositories/settings_repository.dart';
import 'package:flutter_flask_login/src/utils/service_locator.dart';
import '../repositories/network/api_repository.dart';
import '../utils/service_locator.dart';
import '../widgets/dialogues.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  var settingsRepo = serviceLocator.get<SettingsRepository>();

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    String url = await settingsRepo.getSavedURL();
    urlController.text = url;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            title: Row(
          children: <Widget>[
            InkWell(
              child: Icon(Icons.chevron_left),
              onTap: () => Navigator.pop(context),
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
                  controller: urlController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return "Field can't be empty";
                    return null;
                  },
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildSaveButton(),
                      _buildTestConnectionButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return RaisedButton(
      color: Colors.blue,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      textColor: Colors.white,
      child: Text(
        "Save",
      ),
      onPressed: onSaveButtonClicked,
    );
  }

  Widget _buildTestConnectionButton() {
    return RaisedButton(
      color: Colors.blue,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      textColor: Colors.white,
      child: Text(
        "Test Connection",
      ),
      onPressed: onTestConnectionClicked,
    );
  }

  void onSaveButtonClicked() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      String url = urlController.text;

      await settingsRepo.saveURL(url);

      // Update dio url
      var apiRepo = serviceLocator.get<ApiRepository>();
      apiRepo.updateBaseUrl(url);

      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Saved"),
        ),
      );

      FocusScope.of(context).unfocus();
    }
  }

  void onTestConnectionClicked() async {
    var apiRepo = serviceLocator.get<ApiRepository>();
    var x = await apiRepo.testConnection();
    if (x == true) {
      showDialog(
        context: context,
        builder: (context) {
          return SuccessDialog("Connection is working");
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog("Connection Error\nPlease check server and url!");
        },
      );
    }
  }
}
