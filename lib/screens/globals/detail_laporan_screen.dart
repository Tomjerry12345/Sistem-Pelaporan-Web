import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../components/header/header_component.dart';
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
    if (widget.data.typeFile == "video") {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.data.file))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    // VideoPlayerController _controller = VideoPlayerController.networkUrl(Uri.parse(
    //     "https://firebasestorage.googleapis.com/v0/b/sistem-pelaporan-8e835.appspot.com/o/laporan%2FVID-20230813-WA0001.mp4?alt=media&token=aa37f5ea-7517-403d-b8b6-7d4b80411565"))
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
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
                    children: [
                      Text(widget.data.jenisLaporan),
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
                              Text(widget.data.nama)
                            ],
                          ),
                          Text(widget.data.tanggal)
                        ],
                      ),
                      V(24),
                      Text(widget.data.deskripsi),
                      V(16),
                      Center(
                        child: Container(
                          width: 300,
                          height: 150,
                          child: widget.data.typeFile == "image"
                              ? Image.network(widget.data.file)
                              : AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                        ),
                      ),
                      V(16),
                      widget.data.typeFile == "video"
                          ? Container(
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
                            )
                          : Container(),
                      V(16),
                      Container(
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
                              }))
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
