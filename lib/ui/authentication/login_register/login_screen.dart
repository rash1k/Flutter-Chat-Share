import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/ui/authentication/login_register/widgets/login_form.dart';

import 'bloc/bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider<LoginRegisterBloc>(
        create: (context) => LoginRegisterBloc(),
        child: AuthenticationForm(authEvent: AuthEvent.signIn),
      ),
    );
  }
}
