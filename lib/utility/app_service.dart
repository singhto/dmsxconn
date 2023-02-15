import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:psinsx/utility/app_controller.dart';
import 'package:psinsx/utility/my_dialog.dart';
import 'package:psinsx/widgets/widget_text_button.dart';

class AppService {

  AppController appController = Get.put(AppController());

  Future<String> processUpload(
      {@required File file, @required String urlAPI, @required String pathImage}) async {
    String result;

    String nameFile = 'image${Random().nextInt(1000000)}.jpg';
    Map<String, dynamic> map = {};
    map['file'] = await dio.MultipartFile.fromFile(file.path, filename: nameFile);
    dio.FormData data = dio.FormData.fromMap(map);
    await dio.Dio().post(urlAPI, data: data).then((value) async {
      result = '$pathImage/$nameFile';
    });

    return result;
  }

  Future<File> processTakePhoto({@required ImageSource source}) async {
    File file;
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    file = File(result.path);
    return file;
  }

  Future<void> processFindLocation({@required BuildContext context}) async {
    bool locatonServiceEnble = await Geolocator.isLocationServiceEnabled();
    LocationPermission locationPermission;

    print('###5feb lacationService -->> $locatonServiceEnble');

    if (locatonServiceEnble) {
      //open Service
      locationPermission = await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.deniedForever) {
        //Not Permision
        openPermission(context: context);
      } else {
        //unKnow ?
        if (locationPermission == LocationPermission.denied) {
          // Denied
          locationPermission = await Geolocator.requestPermission();
          if ((locationPermission != LocationPermission.always) &&
              (locationPermission != LocationPermission.whileInUse)) {
            openPermission(context: context);
          } else {
            Position position = await Geolocator.getCurrentPosition();
            appController.positions.add(position);
          }
        } else {
          //Alway, OneLnUse
          Position position = await Geolocator.getCurrentPosition();
          appController.positions.add(position);
        }
      }
    } else {
      //close Service

      MyDialog(context: context).normalDialot(
          title: 'Off Service Location',
          subTitle: 'Pleas Open Service',
          secondButton: WidgetTextButton(
            label: 'Open Service',
            pressFunc: () async {
              await Geolocator.openLocationSettings();
              exit(0);
            },
          ));
    }
  }

  void openPermission({@required BuildContext context}) {
    MyDialog(context: context).normalDialot(
        title: 'Off Permission',
        subTitle: 'Please OpenPermission',
        secondButton: WidgetTextButton(
          label: 'Open Permission',
          pressFunc: () async {
            await Geolocator.openAppSettings();
            exit(0);
          },
        ));
  }
}
