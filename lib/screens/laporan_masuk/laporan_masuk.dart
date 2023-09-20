import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../components/header/header_component.dart';

import '../../models/Data.dart';
import '../globals/detail_laporan_screen.dart';
import 'components/table_data.dart';

class LaporanMasukScreen extends StatefulWidget {
  @override
  State<LaporanMasukScreen> createState() => _LaporanMasukScreenState();
}

class _LaporanMasukScreenState extends State<LaporanMasukScreen> {
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
              title: "Laporan Masuk",
              onClickBack: data == null
                  ? null
                  : () {
                      setState(() {
                        this.data = null;
                        this.id = null;
                      });
                    },
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      data == null
                          ? TableData(onClickDetail: onClickDetail)
                          : DetailLaporanScreen(data: data!, id: id!),
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
