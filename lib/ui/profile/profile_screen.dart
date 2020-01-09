import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';
import 'package:flutter_chat_share/ui/profile/bloc.dart';
import 'package:flutter_chat_share/ui/widgets/appbar.dart';

import 'edit/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'Profile', isAppTitle: true),
      body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (_, ProfileState state) {
        if (state is FetchProfileInfoState) {
          return ListView(
            children: <Widget>[
              _buildProfileHeader(context, state.user),
              Divider(height: 0.0),
//              _buildProfilePosts(),
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context, FireStoreUser user) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileHeaderTopSection(context, user),
          _buildProfileHeaderBottomSection(user),
        ],
      ),
    );
  }

//---------------------------Top Section----------------------------------------
  Widget _buildProfileHeaderTopSection(
      BuildContext context, FireStoreUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: CachedNetworkImageProvider(user.photoUrl),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildCountSection('posts', 0),
                  _buildCountSection('followers', 0),
                  _buildCountSection('following', 0),
                ],
              ),
              _buildProfileButton(context, user),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildCountSection(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
              color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildProfileButton(BuildContext context, FireStoreUser profileUser) {
    final textStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    return RaisedButton(
      color: Colors.blue,
      child: Text('Edit profile', style: textStyle),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: () {
        Navigator.pushNamed(
          context,
          EditProfileScreen.ROUTE,
          arguments: <String, dynamic>{
            'bloc': BlocProvider.of<ProfileBloc>(context),
            'profileUser': profileUser
          },
        );
      },
    );
  }

//---------------------------Bottom Section-------------------------------------
  Widget _buildProfileHeaderBottomSection(FireStoreUser user) {
    var fontWeight = FontWeight.bold;
    var fontSize = 16.0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(user.userName,
              style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
          Text(user.displayName, style: TextStyle(fontWeight: fontWeight)),
          Text(user.bio),
        ],
      ),
    );
  }
}
