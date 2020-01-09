import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';
import 'package:flutter_chat_share/ui/profile/bloc.dart';
import 'package:flutter_chat_share/ui/profile/edit/edit_profile_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Widget widget;

  switch (settings.name) {
    case EditProfileScreen.ROUTE:
      final Map<String, dynamic> argumentsMap = settings.arguments;
      final ProfileBloc profileBloc = argumentsMap['bloc'];
      final FireStoreUser profileUser = argumentsMap['profileUser'];

      widget = BlocProvider.value(
        value: profileBloc,
        child: EditProfileScreen(profileUser: profileUser),
      );
      break;
  }

  return MaterialPageRoute(builder: (context) => widget);
}
