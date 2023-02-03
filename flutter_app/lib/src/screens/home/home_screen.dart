import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flask_login/src/repositories/auth_repository.dart';
import 'package:flutter_flask_login/src/repositories/network/responses/profile_response.dart';
import 'package:flutter_flask_login/src/screens/home/profile_bloc.dart';
import 'package:flutter_flask_login/src/utils/service_locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile()),
      child: HomeScreenBuilder(),
    );
  }
}

class HomeScreenBuilder extends StatefulWidget {
  const HomeScreenBuilder({Key key}) : super(key: key);

  @override
  _HomeScreenBuilderState createState() => _HomeScreenBuilderState();
}

class _HomeScreenBuilderState extends State<HomeScreenBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent, Colors.deepPurple],
            ),
            borderRadius: BorderRadius.circular(10.0)),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (_, state) {
            if (state is ProfileLoading) return _buildLoadingWidget();
            if (state is ProfileError) return _buildErrorWidget(state.error);
            if (state is ProfileSuccess)
              return _buildProfileWidget(state.profileResponse);
            return Center();
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Home Screen'),
      actions: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: onLogoutPressed,
              child: Row(
                children: [
                  Text("Log out"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.exit_to_app, color: Colors.white),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              child: Icon(Icons.settings),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SizedBox(
              width: 20,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: TextStyle(color: Colors.white),
          ),
          ElevatedButton(
            child: Text("Try Again"),
            onPressed: () {
              BlocProvider.of<ProfileBloc>(context).add(LoadProfile());
            },
          )
        ],
      ),
    );
  }

  Widget _buildProfileWidget(ProfileResponse profileResponse) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 100.0,
          ),
        ),
        getRow(
          "username",
          profileResponse.username,
        ),
        getRow(
          "fullname",
          profileResponse.fullname,
        ),
        getRow(
          "email",
          profileResponse.email,
        ),
        getRow(
          "Login Counts",
          profileResponse.loginCounts.toString(),
        )
      ],
    );
  }

  Widget getRow(String label, String string) {
    double fontSiz = 16;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Opacity(
        opacity: 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label + ":",
              style: TextStyle(color: Colors.white, fontSize: fontSiz),
            ),
            Spacer(),
            Text(
              string,
              style: TextStyle(color: Colors.white, fontSize: fontSiz),
            ),
          ],
        ),
      ),
    );
  }

  void onLogoutPressed() async {
    var authRepo = serviceLocator.get<AuthRepository>();
    await authRepo.logout();

    // Go to Landing screen
    Navigator.pushReplacementNamed(context, "/landing");
  }
}
