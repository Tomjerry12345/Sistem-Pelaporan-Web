import 'package:admin/models/Data.dart';
import 'package:admin/services/firebase_services.dart';
import 'package:admin/values/output_utils.dart';
import 'package:admin/values/position_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../constants.dart';

class TableData extends StatefulWidget {
  const TableData({
    Key? key,
  }) : super(key: key);

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
                        (index) => demoDataRow(data[index], context, fs, setState, _controller),
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

DataRow demoDataRow(QueryDocumentSnapshot<Map<String, dynamic>> snap, context, fs,
    void Function(VoidCallback fn) setState, _controller) {
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
                  await showDialog<void>(
                      context: context,
                      builder: (context) {
                        if (data.typeFile == "video") {
                          setState(() {
                            _controller = VideoPlayerController.networkUrl(Uri.parse(data.file))
                              ..initialize().then((_) {});
                          });
                        }

                        return AlertDialog(
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(data.jenisLaporan),
                              V(32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        child: CircleAvatar(child: Text("A")),
                                      ),
                                      H(16),
                                      Text(data.nama)
                                    ],
                                  ),
                                  Text(data.tanggal)
                                ],
                              ),
                              V(24),
                              Text(
                                data.deskripsi,
                              ),
                              V(16),
                              // Center(
                              //   child: Container(
                              //     width: 300,
                              //     height: 150,
                              //     child: data.typeFile == "image"
                              //         ? Image.network(data.file)
                              //         : Text("Video"),
                              //   ),
                              // ),
                              Center(
                                child: Container(
                                  width: 300,
                                  height: 150,
                                  child: data.typeFile == "image"
                                      ? Image.network(data.file)
                                      : _controller != null
                                          ? AspectRatio(
                                              aspectRatio: _controller.value.aspectRatio,
                                              child: VideoPlayer(_controller),
                                            )
                                          : Text("Kosong"),
                                ),
                              ),
                              V(16),
                              data.typeFile == "video"
                                  ? Center(
                                      child: ElevatedButton(
                                          child: _controller.value.isPlaying
                                              ? Text("Pause video")
                                              : Text("Play video"),
                                          onPressed: () {
                                            setState(() {
                                              _controller.value.isPlaying
                                                  ? _controller.pause()
                                                  : _controller.play();
                                            });
                                          }),
                                    )
                                  : Container(),
                              V(16),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        child: Text("Verifikasi laporan"),
                                        onPressed: () async {
                                          try {
                                            showLoaderDialog(context);
                                            await fs.updateDataSpecifictDoc(
                                                "laporan", id, {"type": "keluar"});
                                            // navigatePush(const LaporanScreen(), isRemove: true);
                                          } catch (e) {
                                            showToast(e);
                                            closeDialog(context);
                                          }
                                        })),
                              )),
                            ],
                          ),
                        );
                      });
                },
                child: Text("Detail")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {},
                  child: Text("Verifikasi")),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget TextDialog(title) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Text(title),
  );
}
