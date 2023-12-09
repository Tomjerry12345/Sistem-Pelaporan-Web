import 'package:admin/models/DataUser.dart';
import 'package:admin/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../../../constants.dart';

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

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fs.getDataQueryStream("user", "type", "user"),
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
                          label: Text("NIK"),
                        ),
                        DataColumn(
                          label: Text("Jenis Kelamin"),
                        ),
                        DataColumn(
                          label: Text("Email"),
                        ),
                        DataColumn(
                          label: Text("No Telepon"),
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
  final data = DataUser.fromJson(snap.data());

  return DataRow(
    cells: [
      DataCell(Text(data.nama)),
      DataCell(Text(data.nik)),
      DataCell(Text(data.jenisKelamin)),
      DataCell(Text(data.email)),
      DataCell(Text(data.noTelepon)),
    ],
  );
}
