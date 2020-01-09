import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';
import 'package:flutter_chat_share/ui/authentication/authentication_bloc/auth_bloc.dart';
import 'package:flutter_chat_share/ui/authentication/authentication_bloc/auth_event.dart';
import 'package:flutter_chat_share/ui/profile/bloc.dart';

class EditProfileScreen extends StatefulWidget {
  static const ROUTE = 'edit_profile_screen';

  final FireStoreUser profileUser;

  const EditProfileScreen({Key key, @required this.profileUser})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _displayNameController.text = widget.profileUser.displayName;
    _bioController.text = widget.profileUser.bio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.green,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (_, state) {
          if (state is UpdateProfileInfoState) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Profile Updated!')));
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              radius: 50.0,
              backgroundImage:
                  CachedNetworkImageProvider(widget.profileUser.photoUrl),
            ),
            _buildDisplayNameField(),
            _buildBioField(),
            _buildUpdateButton(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty || value.trim().length < 3) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: _displayNameController,
      decoration: InputDecoration(
          labelText: 'Display Name', hintText: 'Update Display Name'),
    );
  }

  Widget _buildBioField() {
    return TextField(
      maxLength: 100,
      controller: _bioController,
      decoration: InputDecoration(labelText: 'Bio', hintText: 'Update Bio'),
    );
  }

  RaisedButton _buildUpdateButton() {
    final textStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20.0);

    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          BlocProvider.of<ProfileBloc>(context).add(
            UpdateProfileEvent(
              _displayNameController.text,
              _bioController.text,
            ),
          );

          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Processing Data')));
        }
      },
      child: Text(
        'Update profile',
        style: textStyle,
      ),
    );
  }

  FlatButton _buildLogoutButton() {
    final textStyle = TextStyle(color: Colors.red, fontSize: 20.0);

    return FlatButton.icon(
      onPressed: () => BlocProvider.of<AuthBloc>(context).add(LoggedOutEvent()),
      icon: Icon(
        Icons.cancel,
        color: Colors.red,
      ),
      label: Text(
        'Logout',
        style: textStyle,
      ),
    );
  }
}
