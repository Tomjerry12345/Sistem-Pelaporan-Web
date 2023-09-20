import 'package:flutter/material.dart';

navigatePush(context, page, {isRemove = false}) {
  if (isRemove) {
    return Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => page), (Route route) => false);
  } else {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

navigatePop(context, {data}) {
  Navigator.pop(context, data);
}
