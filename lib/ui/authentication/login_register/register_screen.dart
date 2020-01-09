import 'package:flutter/material.dart';
import 'package:flutter_chat_share/ui/authentication/login_register/widgets/login_form.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: AuthenticationForm(authEvent: AuthEvent.signUp),
    );
  }
}
