import 'package:admin/values/output_utils.dart';
import 'package:flutter/material.dart';

class Logic {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  void onLogin(context, void Function(dynamic isLogin)? onClickLogin) {
    final username = this.username.text;
    final password = this.password.text;

    print(username + " " + password);

    if (username == "admin" && password == "55555") {
      onClickLogin!(false);
      // navigatePush(context, MainScreen(), isRemove: true);
    } else {
      onClickLogin!(true);
      showToast("Username atau kata sandi salah");
    }
  }
}
