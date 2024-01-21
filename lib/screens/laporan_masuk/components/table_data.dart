import 'package:admin/components/textfield/textfield_component.dart';
import 'package:admin/models/Data.dart';
import 'package:admin/services/firebase_services.dart';
import 'package:admin/values/dialog_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../values/output_utils.dart';

class TableData extends StatefulWidget {
  final void Function(dynamic d, dynamic id)? onClickDetail;
  final void Function(List<QueryDocumentSnapshot<Map<String, dynamic>>>? d)? onGetAllData;
  const TableData({Key? key, this.onClickDetail, this.onGetAllData}) : super(key: key);

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  final fs = FirebaseServices();

  final txtAlasanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fs.getDataStreamCollection("laporan"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            if (widget.onGetAllData != null) widget.onGetAllData!(data);
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
                            data[index], context, widget.onClickDetail),
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

  DataRow demoDataRow(QueryDocumentSnapshot<Map<String, dynamic>> snap, context,
      void Function(dynamic d, dynamic id)? onClickDetail) {
    final id = snap.id;
    final data = Data.fromJson(snap.data());

    return DataRow(
      cells: [
        DataCell(Text(data.nama)),
        DataCell(Text(data.jenisLaporan)),
        DataCell(data.deskripsi.length > 30
            ? Text(data.deskripsi.substring(0, 30) + "...")
            : Text(data.deskripsi)),
        DataCell(
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (onClickDetail != null) onClickDetail(data, id);
                  },
                  child: Text("Detail")),
              data.konfirmasi
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            try {
                              dialogShow(
                                  title: "Alasan",
                                  context: context,
                                  content: Container(
                                    width: 200,
                                    child: TextfieldComponent(
                                      controller: txtAlasanController,
                                      size: 14,
                                      maxLines: 4,
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          await fs.updateDataSpecifictDoc(
                                              "laporan", id, {
                                            "konfirmasi": false,
                                            "message_tolak":
                                                txtAlasanController.text
                                          });
                                          setState(() {
                                            txtAlasanController.text = "";
                                          });
                                          dialogClose(context);
                                        },
                                        child: Text("Kirim"))
                                  ]);
                            } catch (e) {
                              showToast(e);
                            }
                          },
                          child: Text("Verifikasi")),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}
