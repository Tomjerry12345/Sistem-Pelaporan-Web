import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../components/header/header_component.dart';

import '../../models/Data.dart';
import 'components/table_data.dart';

class ListUserScreen extends StatefulWidget {
  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  Data? data;
  String? id;

  void onClickDetail(data, id) {
    setState(() {
      this.data = data;
      this.id = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            HeaderComponent(
              title: "User",
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      TableData(onClickDetail: onClickDetail),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
