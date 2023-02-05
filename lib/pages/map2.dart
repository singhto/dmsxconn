import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/pages/insx_edit.dart';
import 'package:psinsx/pages/insx_page.dart';
import 'package:psinsx/pages/map.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:psinsx/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMap2 extends StatefulWidget {
  @override
  _MyMap2State createState() => _MyMap2State();
}

class _MyMap2State extends State<MyMap2> {
  double lat, lng;
  LatLng startMapLatLng;
  List<InsxModel2> insxModel2s = [];
  List<InsxModel2> insxModelForEdits = [];

  bool statusProcessEdit = false;

  GoogleMapController mapController;

  int greenInt = 0, yellowInt = 0, blueInt = 0, redInt = 0;

  LatLng latLngGreen, latLngYellow, latLngBlue, latLngRed;

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> myReadAPI() async {
    if (insxModel2s.isNotEmpty) {
      greenInt = 0;
      yellowInt = 0;
      blueInt = 0;
      redInt = 0;
      insxModel2s.clear();
      insxModelForEdits.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');

    String url =
        'https://www.pea23.com/apipsinsx/getInsxWhereUser.php?isAdd=true&worker_name=$workername';

    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          InsxModel2 model2 = InsxModel2.fromMap(item);
          insxModel2s.add(model2);
        }
        print('##5june ขนาดของ insxModel2 == ${insxModel2s.length}');
        // myAllMarker();
        setState(() {});
      }
    });
  }

  Set<Marker> myAllMarker() {
    List<Marker> markers = [];
    List<double> hues = [80.0, 60.0, 150.0, 20.0];

    Marker userMarker = Marker(
        markerId: MarkerId('idUser'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: 'คุณอยู่ที่นี่'),
        icon: BitmapDescriptor.defaultMarkerWithHue(300));

    for (var item in insxModel2s) {
      Marker marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
            calculageHues(item.noti_date, item)),
        markerId: MarkerId('id${item.id}'),
        position: LatLng(double.parse(item.lat), double.parse(item.lng)),
        infoWindow: InfoWindow(
          title: item.cus_name,
          snippet: '${item.write_id} PEA:${item.pea_no}',
          onTap: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => InsxEdit(
                insxModel2: item,
                fromMap: true,
              ),
            );
            Navigator.push(context, route).then(
              (value) {
                print('##4june Back Form insx');
                myReadAPI();
              },
            );
          },
        ),
      );
      markers.add(marker);
    }
    return markers.toSet();
  }

  double calculageHues(String notidate, InsxModel2 insxModel2) {
    List<double> hues = [80.0, 60.0, 200.0, 20.0];
    List<String> strings = notidate.split(" ");
    List<String> dateTimeInts = strings[0].split('-');
    DateTime notiDateTime = DateTime(
      int.parse(dateTimeInts[0]),
      int.parse(dateTimeInts[1]),
      int.parse(dateTimeInts[2]),
    );

    DateTime currentDateTime = DateTime.now();
    int diferDate = currentDateTime.difference(notiDateTime).inDays;
    double result; //green

    if (diferDate >= 7) {
      result = hues[3]; //red 20
      redInt++;
      latLngRed =
          LatLng(double.parse(insxModel2.lat), double.parse(insxModel2.lng));
    } else if (diferDate >= 3) {
      result = hues[2]; //blue 150
      blueInt++;
      latLngBlue =
          LatLng(double.parse(insxModel2.lat), double.parse(insxModel2.lng));
    } else if (diferDate >= 1) {
      result = hues[1]; // yellow 60
      yellowInt++;
      latLngYellow =
          LatLng(double.parse(insxModel2.lat), double.parse(insxModel2.lng));
    } else {
      greenInt++;
      result = hues[0];
      latLngGreen =
          LatLng(double.parse(insxModel2.lat), double.parse(insxModel2.lng));
    }
    return result;
  }

  Future<Null> findLatLng() async {
    bool enableServiceLocation = await Geolocator.isLocationServiceEnabled();

    if (enableServiceLocation) {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          lat = 16.753188;
          lng = 101.203616;
          startMapLatLng = LatLng(16.753188, 101.203616);
          myReadAPI();
        });
      } else if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission().then((value) async {
          if (value == LocationPermission.deniedForever) {
            setState(() {
              lat = 16.753188;
              lng = 101.203616;
              startMapLatLng = LatLng(16.753188, 101.203616);
              myReadAPI();
            });
          } else {
            // find Lat, lng
            var position = await findPosition();
            setState(() {
              lat = position.latitude;
              lng = position.longitude;
              startMapLatLng = LatLng(lat, lng);
              myReadAPI();
            });
          }
        });
      } else {
        // find Lat, lng
        var position = await findPosition();
        setState(() {
          lat = position.latitude;
          lng = position.longitude;
          startMapLatLng = LatLng(lat, lng);
          myReadAPI();
        });
      }
    } else {
      normalDialog(context, 'โปรดให้สิทธิแผนที่ก่อน');
      setState(() {
        lat = 16.753188;
        lng = 101.203616;
        startMapLatLng = LatLng(16.753188, 101.203616);
        myReadAPI();
      });
    }
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lat == null ? MyStyle().showProgress() : buildGoogleMap(),
    );
  }

  int timeEdit = 0;

  Future<Null> editDataInsx2(InsxModel2 insxModel2) async {
    String url =
        'https://www.pea23.com/apipsinsx/editDataWhereInvoiceNo.php?isAdd=true&invoice_no=${insxModel2.invoice_no}';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
      } else {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด กรุณาลองใหม่');
      }
    });
  }

  Widget pinGreen() {
    return GestureDetector(
      onTap: () {
        return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsxPage(
                insxModel2s: insxModel2s,
              ),
            )).then((value) {
          InsxModel2 insxModel2 = value;
          print('##4june การกลับจาก insxPage ${insxModel2.cus_name} ');

          LatLng latLng = LatLng(
            double.parse(insxModel2.lat),
            double.parse(insxModel2.lng),
          );
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: latLng, zoom: 22)));
          myReadAPI();
        });
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 30,
                color: Color.fromARGB(255, 248, 245, 245),
              ),
            
              Text(
                '${insxModel2s.length}',
                style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 245, 241, 241),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          color: Color.fromARGB(255, 77, 73, 73)),
    );
  }

  Widget buildGoogleMap() {
    return Scaffold(
      body: Stack(
        children: [
          buildMainMap(),
          Positioned(
            top: 8,
            left: 10,
            child: pinGreen(),
          ),
          newCard(
              top: 80,
              left: 6,
              tapFunc: () {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: latLngGreen, zoom: 16)));
              },
              iconData: Icons.pin_drop,
              label: '$greenInt',
              color: Colors.green),
          newCard(
              top: 152,
              left: 6,
              tapFunc: () {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: latLngYellow, zoom: 16)));
              },
              iconData: Icons.pin_drop,
              label: '$yellowInt',
              color: Colors.yellow),
          newCard(
              top: 224,
              left: 6,
              tapFunc: () {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: latLngBlue, zoom: 16)));
              },
              iconData: Icons.pin_drop,
              label: '$blueInt',
              color: Colors.blue),
          newCard(
              top: 296,
              left: 6,
              tapFunc: () {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: latLngRed, zoom: 16)));
              },
              iconData: Icons.pin_drop,
              label: '$redInt',
              color: Colors.red),
          statusProcessEdit ? showProcessEdit() : SizedBox(),
        ],
      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.white,
        child: new Row(),
      ),
    );
  }

  Positioned newOffine() {
    return Positioned(
      top: 80,
      left: 10,
      child: InkWell(
        onTap: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MyMap(),
              ),
              (route) => false);
        },
        child: Card(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  Icons.pin_drop,
                  size: 30,
                ),
                ShowText(
                  text: 'ออฟไลน์',
                  textStyle: MyConstant().h5Style(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned newCard({
    @required double top,
    @required double left,
    @required Function() tapFunc,
    @required IconData iconData,
    @required String label,
    @required Color color,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: InkWell(
        onTap: tapFunc,
        child: Card(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  iconData,
                  size: 30,
                  color: color,
                ),
                ShowText(
                  text: label,
                  textStyle: MyConstant().h5Style(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showProcessEdit() => Center(
        child: Card(
          color: Colors.black,
          child: Container(
            width: 200,
            height: 150,
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(
                  'กำลังอัพโหลด เหลือ $timeEdit รายการ',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );

  GoogleMap buildMainMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: startMapLatLng,
        zoom: 8,
      ),
      onMapCreated: (controller) {
        mapController = controller;
      },
      markers: myAllMarker(),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }
}
