import 'package:admin/values/excel_utils.dart';
import 'package:admin/values/output_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late final List<QueryDocumentSnapshot<Map<String, dynamic>>>? allData;

  void onClickDetail(data, id) {
    setState(() {
      this.data = data;
      this.id = id;
    });
  }

  void onClickBack() {
    if (data != null) {
      setState(() {
        this.data = null;
        this.id = null;
      });
    }
  }

  void onExportData() {
    final excelUtils = ExcelUtils();
    excelUtils.createSheet(0);
    excelUtils.title("A1", "Nama");
    excelUtils.title("B1", "Jenis laporan");
    excelUtils.title("C1", "Deskripsi");

    for (var i = 2; i < allData!.length; i++) {
      var objData = allData![i - 2].data();
      excelUtils.body("A$i", objData["nama"]);
      excelUtils.body("B$i", objData["jenis_laporan"]);
      excelUtils.body("C$i", objData["deskripsi"]);
      logO("i", m: i);
      logO("objData", m: objData);
    }

    excelUtils.save("laporan.xlsx");
  }

  @override
  Widget build(BuildContext context) {
    void getAllData(List<QueryDocumentSnapshot<Map<String, dynamic>>>? d) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          allData = d;
        });
      });
    }

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            HeaderComponent(
              title: "Laporan Masuk",
              onClickBack: onClickBack,
              onClickExportData: onExportData,
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
                          ? TableData(
                              onClickDetail: onClickDetail,
                              onGetAllData: getAllData,
                            )
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
