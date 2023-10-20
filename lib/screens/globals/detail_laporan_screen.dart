import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';
import '../../models/Data.dart';
import '../../services/firebase_services.dart';
import '../../values/output_utils.dart';
import '../../values/position_utils.dart';

class DetailLaporanScreen extends StatefulWidget {
  final Data data;
  final String id;
  const DetailLaporanScreen({required this.data, required this.id});

  @override
  State<DetailLaporanScreen> createState() => _DetailLaporanScreenState();
}

class _DetailLaporanScreenState extends State<DetailLaporanScreen> {
  final fs = FirebaseServices();

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print(widget.data.typeFile);
    print(widget.data.file);
    if (widget.data.typeFile == "video") {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.data.file))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });

      print(_controller.value.aspectRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.jenisLaporan,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      V(32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(child: Text(widget.data.nama[0].toUpperCase())),
                              ),
                              H(16),
                              Text(widget.data.nama)
                            ],
                          ),
                          Text(widget.data.tanggal)
                        ],
                      ),
                      V(24),
                      Text(widget.data.deskripsi),
                      V(32),
                      Center(
                        child: Container(
                          width: 600,
                          height: 300,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                      // Center(
                      //   child: Container(
                      //     width: 600,
                      //     height: 300,
                      //     child: widget.data.typeFile == "image"
                      //         ? Image.network(widget.data.file)
                      //         : AspectRatio(
                      //             aspectRatio: _controller.value.aspectRatio,
                      //             child: VideoPlayer(_controller),
                      //           ),
                      //   ),
                      // ),
                      V(16),
                      widget.data.typeFile == "video"
                          ? Center(
                              child: Container(
                                child: ElevatedButton(
                                    child: Text(
                                        _controller.value.isPlaying ? "Pause video" : "Play video"),
                                    onPressed: () {
                                      setState(() {
                                        _controller.value.isPlaying
                                            ? _controller.pause()
                                            : _controller.play();
                                      });
                                    }),
                              ),
                            )
                          : Container(),
                      V(32),
                      Center(
                        child: Container(
                            width: 300,
                            child: ElevatedButton(
                                child: Text("Verifikasi laporan"),
                                onPressed: () async {
                                  try {
                                    showLoaderDialog(context);
                                    await fs.updateDataSpecifictDoc(
                                        "laporan", widget.id, {"type": "keluar"});
                                    // navigatePush(const LaporanScreen(), isRemove: true);
                                  } catch (e) {
                                    showToast(e);
                                    closeDialog(context);
                                  }
                                })),
                      )
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
