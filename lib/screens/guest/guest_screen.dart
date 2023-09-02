import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class GuestScreen extends StatelessWidget {
  const GuestScreen({super.key});

  static const routeName = "guest";

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Chat App',
      theme: LoginTheme(
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold
        ),
        pageColorDark: Colors.blue,
        pageColorLight: Colors.blue.shade300
      ),
      logo: const AssetImage('assets/images/chat.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      scrollable: true,
      hideForgotPasswordButton: true,
      userValidator: (value){
        if(value == null || !value.contains("@")){
          return 'Please enter a valid email address';
        }
        return null;
      },

      passwordValidator: (value){
        if(value == null || value.length < 5){
          return "Please must be at least 5 chars";
        }
        return null;
      },

      onSubmitAnimationCompleted: () {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(
          //builder: (context) => DashboardScreen(),
        //));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}