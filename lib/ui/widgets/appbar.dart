import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context,
    {void onPressed(), bool isAppTitle = false, String title}) {
  return AppBar(
    actions: <Widget>[
      IconButton(icon: Icon(Icons.exit_to_app), onPressed: onPressed)
    ],
    title: Text(
      isAppTitle ? title : 'Flutter Share',
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? 'Signatra' : '',
        fontSize: isAppTitle ? 50 : 22,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
