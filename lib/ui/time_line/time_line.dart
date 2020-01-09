import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/ui/authentication/authentication_bloc/auth_bloc.dart';
import 'package:flutter_chat_share/ui/authentication/authentication_bloc/auth_event.dart';
import 'package:flutter_chat_share/ui/time_line/bloc/bloc.dart';
import 'package:flutter_chat_share/ui/widgets/appbar.dart';

import 'create_account/create_account.dart';

class TimeLineScreen extends StatefulWidget {
  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,
          isAppTitle: true,
          title: 'Time Line',
          onPressed: () =>
              BlocProvider.of<AuthBloc>(context).add(LoggedOutEvent())),
      body: BlocBuilder<TimeLineBloc, TimeLineState>(
        builder: (context, TimeLineState state) {
          if (state is UserExistsState) {
            return state.isUserExists
                ? _buildTimeLine()
                : CreateAccountScreen();
          }

          if (state is SaveUserInFireStore) {
            return _buildTimeLine();
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildTimeLine() {
    return Container(
      child: Text('Empty'),
    );
  }
}
