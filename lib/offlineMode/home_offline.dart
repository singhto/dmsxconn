import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psinsx/models/insx_sqlite_model.dart';
import 'package:psinsx/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeOffline extends StatefulWidget {
  @override
  _HomeOfflineState createState() => _HomeOfflineState();
}

class _HomeOfflineState extends State<HomeOffline> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Position currentPosion;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  String nameUser, userEmail, userImge, userId;

   bool statusSQLite;

  @override
  void initState() {
    super.initState();
    readUserInfo();
    checkSQLit();
  }

     Future<Null> checkSQLit() async {
    List<InsxSQLiteModel> insxSQLiteModels = await SQLiteHelper().readSQLite();
    if (insxSQLiteModels.length == 0) {
      // read from api
      statusSQLite = true;
      //findLatLng();

      print('true');
    } else {
      statusSQLite = false;
      //findLatLng();
      print('false');
    }
  }

    Future<Null> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      nameUser = preferences.getString('staffname');
      userEmail = preferences.getString('user_email');
      userImge = preferences.getString('user_img');
      userId = preferences.getString('id');
    });
  }
  

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosion = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(
        16.757236153810187,
        101.21631881355364,
      ),
      zoom: 14.4746);
  @override
  Widget build(BuildContext context) {

   
    return Scaffold(
  
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              // setState(() {
              //   bottomPaddingOfMap = 50.0;
              // });

              locatePosition();
            },
          ),
        ],
      ),
    );
  }
}
