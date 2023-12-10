import 'package:flutter/material.dart';

Future<void> dialogShow({context, title, content, actions}) async {
  await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: actions,
        );
      });
}

void dialogClose(context) {
  Navigator.of(context).pop();
}
