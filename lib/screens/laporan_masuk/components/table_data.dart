import 'package:admin/models/Data.dart';
import 'package:admin/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../constants.dart';
import '../../../values/navigate_utils.dart';
import '../../../values/output_utils.dart';
import '../../globals/detail_laporan_screen.dart';
import '../../main/main_screen.dart';

class TableData extends StatefulWidget {
  final void Function(dynamic d, dynamic id)? onClickDetail;
  const TableData({Key? key, this.onClickDetail}) : super(key: key);

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  @override
  Widget build(BuildContext context) {
    final fs = FirebaseServices();

    VideoPlayerController? _controller;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fs.getDataQueryStream("laporan", "type", "masuk"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data?.docs;

            return Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Recent Files",
                  //   style: Theme.of(context).textTheme.titleMedium,
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columnSpacing: defaultPadding,
                      // minWidth: 600,
                      columns: [
                        DataColumn(
                          label: Text("Nama"),
                        ),
                        DataColumn(
                          label: Text("Jenis Laporan"),
                        ),
                        DataColumn(
                          label: Text("Deskripsi"),
                        ),
                        DataColumn(
                          label: Text("Action"),
                        ),
                      ],
                      rows: List.generate(
                        data!.length,
                        (index) => demoDataRow(
                            data[index], context, fs, widget.onClickDetail),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return CircularProgressIndicator();
        });
  }
}

DataRow demoDataRow(QueryDocumentSnapshot<Map<String, dynamic>> snap, context,
    fs, void Function(dynamic d, dynamic id)? onClickDetail) {
  final id = snap.id;
  final data = Data.fromJson(snap.data());

  return DataRow(
    cells: [
      DataCell(Text(data.nama)),
      DataCell(Text(data.jenisLaporan)),
      DataCell(Text(data.deskripsi)),
      DataCell(
        Row(
          children: [
            ElevatedButton(
                onPressed: () async {
                  if (onClickDetail != null) onClickDetail(data, id);
                },
                child: Text("Detail")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    try {
                      await fs.updateDataSpecifictDoc(
                          "laporan", id, {"type": "keluar"});
                    } catch (e) {
                      showToast(e);
                    }
                  },
                  child: Text("Verifikasi")),
            ),
          ],
        ),
      ),
    ],
  );
}
