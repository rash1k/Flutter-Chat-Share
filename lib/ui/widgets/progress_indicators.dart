import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCircularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}

Widget buildLinearProgress(double progressUpload) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(bottom: 10),
    child: LinearProgressIndicator(
      backgroundColor: Colors.limeAccent[400],
      value: progressUpload,
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}
