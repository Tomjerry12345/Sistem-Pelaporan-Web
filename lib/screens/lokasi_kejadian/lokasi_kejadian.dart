import 'dart:async';
import 'dart:convert';
import 'package:admin/services/firebase_services.dart';
import 'package:admin/values/algorithm_dijkstra.dart';
import 'package:admin/values/output_utils.dart';
import 'package:admin/values/position_utils.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import "package:http/http.dart" as http;

class LokasiKejadianScreen extends StatefulWidget {
  @override
  State<LokasiKejadianScreen> createState() => _LokasiKejadianScreenState();
}

class _LokasiKejadianScreenState extends State<LokasiKejadianScreen> {
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  List<Map<String, dynamic>>? userData;

  var listRoute = [];

  final fs = FirebaseServices();

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast("Location services are disabled. Please enable the services");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast("Location permissions are denied");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showToast(
          "Location permissions are permanently denied, we cannot request permissions.");
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      getDistance(position);
    }).catchError((e) {
      logO("e", m: e);
    });
    positionStream();
  }

  StreamSubscription<Position> positionStream() {
    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (position != null) {
        getDistance(position);
      }
    });
  }

  void getDistance(Position position) async {
    try {
      final listUserLoc = await fs.getDataCollection("laporan");

      final List<Map<String, dynamic>> listDatauser = [
        {
          "nama": "admin",
          "jenis_laporan": "",
          "tanggal": "",
          "lokasi": LatLng(position.latitude, position.longitude),
          "jarak": 0.0
        },
      ];

      for (var userData in listUserLoc) {
        var targetLatitude = userData["lokasi"]["latitude"];
        var targetLongitude = userData["lokasi"]["longitude"];

        var url =
            "https://api.tomtom.com/routing/1/calculateRoute/${position.latitude},${position.longitude}:$targetLatitude,$targetLongitude/json?key=$apiKey&maxAlternatives=0";

        var result = await http.get(Uri.parse(url));
        var res = json.decode(result.body)['routes'];

        var routes = [];

        for (var e in res) {
          var points = e["legs"][0]["points"];
          routes.add(points);
        }

        var distance = algorithmDijkstra(routes);

        listDatauser.add({
          "nama": userData["nama"],
          "jenis_laporan": userData["jenis_laporan"],
          "tanggal": userData["tanggal"],
          "lokasi": LatLng(targetLatitude, targetLongitude),
          "jarak": distance
        });
      }

      setState(() {
        userData = listDatauser;
      });
    } catch (e) {
      showToast(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    const padding = 50.0;

    return SafeArea(
        child: userData != null
            ? Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      bounds: LatLngBounds.fromPoints(userData!
                          .map((uData) => uData["lokasi"] as LatLng)
                          .toList()),
                      boundsOptions: FitBoundsOptions(
                        padding: EdgeInsets.only(
                          left: padding,
                          top: padding + MediaQuery.of(context).padding.top,
                          right: padding,
                          bottom: padding,
                        ),
                      ),
                    ),
                    nonRotatedChildren: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                          markers: userData!.map((uData) {
                        int idx = userData!.indexOf(uData);

                        return Marker(
                            point: uData["lokasi"],
                            width: 35,
                            height: 35,
                            builder: (context) => Icon(
                                  Icons.location_pin,
                                  color: idx == 0 ? Colors.blue : Colors.red,
                                  size: 24,
                                ),
                            anchorPos: AnchorPos.align(AnchorAlign.top));
                      }).toList()),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SingleChildScrollView(
                      child: Container(
                        height: 300,
                        child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            final value = userData![i];

                            final jarak = value["jarak"] as double;
                            if (i > 0) {
                              return Card(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {},
                                  child: ListTile(
                                    leading: CircleAvatar(child: Text("A")),
                                    title: Text(value["nama"]),
                                    subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(value["nama"]),
                                          V(8),
                                          Text(
                                              "${jarak.toStringAsFixed(2)} km"),
                                        ]),
                                    // trailing: Icon(Icons.arrow_right),
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                          itemCount: userData?.length,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
