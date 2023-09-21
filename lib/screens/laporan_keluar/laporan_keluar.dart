import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../components/header/header_component.dart';
import 'components/table_data.dart';

class LaporanKeluarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            HeaderComponent(
              title: "Laporan Keluar",
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
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
