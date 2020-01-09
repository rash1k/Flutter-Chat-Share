import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/ui/authentication/authentication_bloc/bloc.dart';
import 'package:flutter_chat_share/ui/authentication/login_register/bloc/bloc.dart';

import '../register_screen.dart';

enum AuthEvent { signIn, signUp }

class AuthenticationForm extends StatefulWidget {
  final AuthEvent authEvent;

  const AuthenticationForm({
    Key key,
    @required this.authEvent,
  }) : super(key: key);

  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginRegisterBloc _loginRegisterBloc;

  bool _isSignIn;
  bool _obscurePassword = true;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool _isSubmitButtonEnabled(LoginRegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _isSignIn = widget.authEvent.index == AuthEvent.signIn.index;
    _loginRegisterBloc = BlocProvider.of<LoginRegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginRegisterBloc, LoginRegisterState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Login Failure ${state.errorMsg}'),
                    Icon(Icons.error)
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }

        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedInEvent());
        }
      },
      child: BlocBuilder<LoginRegisterBloc, LoginRegisterState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: FlutterLogo(
                      size: 200,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Email'),
                    autovalidate: false,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: _clickSuffixIcon,
                      ),
                    ),
                    obscureText: _obscurePassword,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildSubmitButton(state),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: _navigateAccountButton()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton(LoginRegisterState state) {
    return RaisedButton(
      shape: StadiumBorder(),
      child: Text(_isSignIn ? 'Login' : 'Create account'),
      onPressed: _isSubmitButtonEnabled(state) ? _onFormSubmitted : null,
    );
  }

  Widget _navigateAccountButton() {
    return FlatButton(
      child: Text(_isSignIn ? 'Create account' : 'Login'),
      onPressed: () {
        _isSignIn
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                          value: _loginRegisterBloc,
                          child: RegisterScreen(),
                        )))
            : Navigator.pop(context);
      },
    );
  }

  void _onEmailChanged() {
    _loginRegisterBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginRegisterBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    switch (widget.authEvent) {
      case AuthEvent.signIn:
        _loginRegisterBloc.add(
          LoginWithCredentialsPressed(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
        break;
      case AuthEvent.signUp:
        _loginRegisterBloc.add(
          SignUpWithCredentialsEvent(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
        break;
    }
  }

  void _clickSuffixIcon() {
    setState(() {
//      FocusScope.of(context).requestFocus(FocusNode());
      _obscurePassword = !_obscurePassword;
    });
  }
}
