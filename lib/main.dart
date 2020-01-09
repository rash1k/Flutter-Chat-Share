import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/ui/splash/splash.dart';

import 'ui/authentication/authentication_bloc/bloc.dart';
import 'ui/authentication/authentication_bloc/delegate.dart';
import 'ui/authentication/login_register/login_screen.dart';
import 'ui/home/home.dart';
import 'utils/route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(
    BlocProvider<AuthBloc>(
      create: (_) => AuthBloc()..add(AppStartedEvent()),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.teal,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is UnInitializedState) {
            return SplashScreen();
          }
          if (state is AuthenticatedState) {
            return HomeScreen();
          }
          if (state is UnAuthenticatedState) {
            return LoginScreen();
          }
          return Container();
        },
      ),
      onGenerateRoute: generateRoute,
    );
  }
}
