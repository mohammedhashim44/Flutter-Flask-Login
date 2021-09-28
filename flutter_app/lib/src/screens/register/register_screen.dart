import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flask_login/src/screens/register/register_bloc.dart';
import 'package:flutter_flask_login/src/widgets/dialogues.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: RegisterBuilderScreen(),
    );
  }
}

class RegisterBuilderScreen extends StatefulWidget {
  const RegisterBuilderScreen({Key key}) : super(key: key);

  @override
  _RegisterBuilderScreenState createState() => _RegisterBuilderScreenState();
}

class _RegisterBuilderScreenState extends State<RegisterBuilderScreen> {
  final formKey = GlobalKey<FormState>();

  var usernameController = TextEditingController();
  var fullNameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (_, state) async {
          // if error , show error dialog
          if (state is RegisterError) {
            showDialog(
              context: _,
              builder: (_) {
                return ErrorDialog(state.error);
              },
            );
          } else if (state is RegisterSuccess) {
            showDialog(
              context: _,
              builder: (_) {
                return SuccessDialog(
                    "You have been registered!\nYou can now log in :)");
              },
            ).then((value) {
              goToLoginScreen();
            });
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (_, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildForm(),
                  _buildButton(state),
                  _buildGoToLoginScreenSection(),
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

  Widget _buildAppBar() {
    return AppBar(
      title: Text("RegisterBuilder Screen"),
      actions: [
        InkWell(
          child: Icon(Icons.settings),
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
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
              decoration: InputDecoration(labelText: "Full Name"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return "Empty Field";
                return null;
              },
              controller: fullNameController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return "Empty Field";
                return null;
              },
              controller: emailController,
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

  Widget _buildButton(RegisterState state) {
    bool isDisabled = state is RegisterLoading;
    return RaisedButton(
      child: Text("Register"),
      onPressed: isDisabled ? null : onRegisterButtonPressed,
    );
  }

  Widget _buildGoToLoginScreenSection() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Already Register ? "),
          InkWell(
            onTap: goToLoginScreen,
            child: Text(
              "Login now",
              style: TextStyle(color: Colors.blueAccent),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBlocStateIndicator(RegisterState state) {
    if (state is RegisterLoading) return CircularProgressIndicator();
    return Container();
  }

  void onRegisterButtonPressed() {
    FocusScope.of(context).unfocus();

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      String username = usernameController.text;
      String fullname = fullNameController.text;
      String password = passwordController.text;
      String email = emailController.text;

      BlocProvider.of<RegisterBloc>(context).add(AttemptRegister(
        username,
        fullname,
        email,
        password,
      ));
    }
  }

  void goToLoginScreen() {
    Navigator.pushReplacementNamed(context, "/login");
  }
}
