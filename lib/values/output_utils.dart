import 'package:admin/values/position_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(msg) {
  Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void logO(t, {dynamic m = ""}) {
  m == "" ? print("[d] $t") : print("[d] $t: $m");
}

showLoaderDialog(context) {
  AlertDialog alert = AlertDialog(
    content: Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            child: SpinKitWave(
              color: Colors.black,
              size: 50.0,
            ),
          ),
          V(16),
          Container(
              child: Text(
            "Loading...",
            style: Theme.of(context).textTheme.titleLarge,
          )),
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

closeDialog(context) {
  Navigator.of(context, rootNavigator: true).pop();
}
