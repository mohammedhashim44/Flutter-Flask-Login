import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flask_login/src/screens/login/login_bloc.dart';
import 'package:flutter_flask_login/src/widgets/dialogues.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: LoginScreenBuilder(),
    );
  }
}

class LoginScreenBuilder extends StatefulWidget {
  const LoginScreenBuilder({Key key}) : super(key: key);

  @override
  _LoginScreenBuilderState createState() => _LoginScreenBuilderState();
}

class _LoginScreenBuilderState extends State<LoginScreenBuilder> {
  final formKey = GlobalKey<FormState>();

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (_, state) {
          if (state is LoginError) {
            onLoginFailed(state);
          } else if (state is LoginSuccess) {
            onLoginSuccess();
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (_, state) {
            return Center(
              child: Column(
                children: [
                  _buildForm(),
                  _buildButton(state),
                  _buildRegisterSection(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildBlocStateIndicator(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Login States helpers
  void onLoginFailed(LoginError state) {
    showDialog(
      context: context,
      builder: (_) {
        return ErrorDialog(state.error);
      },
    );
  }

  void onLoginSuccess() {
    showDialog(
      context: context,
      builder: (_) {
        return SuccessDialog("You have been logged!");
      },
    ).then((value) {
      goToLandingScreen();
    });
  }

  /// Widgets
  ///
  Widget _buildAppBar() {
    return AppBar(
      title: Text("Login Screen"),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: InkWell(
            child: Icon(Icons.settings),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        )
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Username"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return "Empty Field";
                return null;
              },
              controller: usernameController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return "Empty Field";
                return null;
              },
              controller: passwordController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(LoginState state) {
    bool isDisabled = state is LoginLoading;
    return ElevatedButton(
      child: Text("Login"),
      onPressed: isDisabled ? null : onLoginPressed,
    );
  }

  Widget _buildRegisterSection() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("New user ? "),
          InkWell(
            onTap: goToRegisterScreen,
            child: Text(
              "Register now",
              style: TextStyle(color: Colors.blueAccent),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBlocStateIndicator(LoginState state) {
    if (state is LoginLoading) return CircularProgressIndicator();
    return Container();
  }

  void onLoginPressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      String username = usernameController.text;
      String password = passwordController.text;

      BlocProvider.of<LoginBloc>(context).add(AttemptLogin(username, password));
    }
  }

  void goToRegisterScreen() {
    Navigator.pushReplacementNamed(context, "/register");
  }

  void goToLandingScreen() {
    Navigator.pushReplacementNamed(context, "/landing");
  }
}
