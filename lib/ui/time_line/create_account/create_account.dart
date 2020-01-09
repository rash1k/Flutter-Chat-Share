import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/ui/time_line/bloc/bloc.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String _userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: buildAppBar(context, title: 'Set up your profile'),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 16),
          Text(
            'Create a user name',
            style: TextStyle(fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                onSaved: (String val) => _userName = val,
                validator: _validator,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User name',
                  labelStyle: TextStyle(fontSize: 15),
                  hintText: 'Must be at least 3 characters',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: onSubmitForm,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onSubmitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      BlocProvider.of<TimeLineBloc>(context)
          .add(SaveUserInFireStore(_userName));
    }
  }

  String _validator(String value) {
    if (value.trim().length < 3 || value.isEmpty) {
      return 'User name too short';
    } else if (value.trim().length > 12) {
      return 'User name too long';
    } else {
      return null;
    }
  }
}
