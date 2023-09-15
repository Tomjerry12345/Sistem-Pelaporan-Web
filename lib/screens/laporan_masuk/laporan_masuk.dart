import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../components/header/header_component.dart';

import 'components/sub_header.dart';
import 'components/table_data.dart';

class LaporanMasukScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            HeaderComponent(
              title: "Laporan Masuk",
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // SubHeader(),
                      // SizedBox(height: defaultPadding),
                      TableData(),
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
