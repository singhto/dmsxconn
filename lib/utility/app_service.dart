import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:psinsx/models/image_upload_model.dart';
import 'package:psinsx/utility/app_controller.dart';
import 'package:psinsx/utility/my_dialog.dart';
import 'package:psinsx/widgets/widget_text_button.dart';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> processChooseMultiImage({required BuildContext context}) async {
    if (appController.xFiles.isNotEmpty) {
      appController.xFiles.clear();
      appController.nameFiles.clear();
    }

    await ImagePicker().pickMultiImage().then((value) async {
      print('จำนวนภาพที่เลือก ${value.length}');

      for (var element in value) {
        String nameImage = basename(element.path);

        print('##4aug nameImage==> $nameImage');

// ASGD = เริ่มงดจ่ายไฟ
// WMMI = ต่อมิเตอร์แล้ว  * 35
// WMMR = ถอดมิเตอร์แล้ว * 35
// FUCN = ต่อสายแล้ว * 20
// FURM = ปลดสายแล้ว * 20
// WMST = ผ่อนผันครั้งที่ 1 * 10
// WMS2 = ผ่อนผันครั้งที่ 2 * 10

        var conditions = <String>[
          'ASGD',
          'WMMI',
          'WMMR',
          'FUCN',
          'FURM',
          'WMST',
          'WMS2',
        ];

        if (nameImage.contains('_')) {
          bool response =
              await checkNameImage(nameImage: nameImage); //true ชื่อซ้ำ

          if (!response) {
            var string = nameImage.split('_');
            if (string.isNotEmpty) {
              String fourDigi = string[0].substring(0, 4);

              print('##4aug fourDigi == $fourDigi');

              if (conditions.contains(fourDigi)) {
                appController.xFiles.add(element);
                appController.nameFiles.add(nameImage);
              }
            }
          }
        }
      } //for

      if (appController.xFiles.isNotEmpty) {
        MyDialog(context: context).normalDialot(
            title: 'คุณได้เลือกภาพ',
            subTitle: 'จำนวน ${appController.xFiles.length} รายการ',
            contentWidget: SizedBox(
              width: 400,
              child: GridView.builder(
                physics: const ScrollPhysics(),
                itemCount: appController.xFiles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) => Image.file(
                  File(appController.xFiles[index].path),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            firstButton: WidgetTextButton(
              label: 'upLoad',
              pressFunc: () async {
                Get.back();

                for (var i = 0; i < appController.xFiles.length; i++) {
                  String urlAPIsave =
                      'https://www.dissrecs.com/apipsinsx/saveImageJob.php';

                  File file = File(appController.xFiles[i].path);

                  Map<String, dynamic> map = {};
                  map['file'] = await dio.MultipartFile.fromFile(file.path,
                      filename: appController.nameFiles[i]);

                  dio.FormData formData = dio.FormData.fromMap(map);

                  var responseUpload =
                      await dio.Dio().post(urlAPIsave, data: formData);

                  print('##4aug = $reactive');

                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String? id = preferences.getString('id');

                  String urlApiInsert =
                      'https://www.dissrecs.com/apipsinsx/insertImageJob.php?isAdd=true&image_name=${appController.nameFiles[i]}&user_id=$id';

                      await dio.Dio().get(urlApiInsert).then((value) {
                        Get.snackbar('สำเร็จ!', 'คุณอัพโหลดภาพสำเร็จแล้ว');
                      });
                }
              },
            ));
      } else {
        Get.snackbar('ไม่ถูกต้อง', 'คุณเลือกภาพไม่ถูกต้อง');
      }
    });
  }

  Future<bool> checkNameImage({required String nameImage}) async {
    String path = 'https://www.dissrecs.com/apipsinsx/readAllImageUpload.php';

    bool response = false; //ชื่อไม่ซ้ำ ใช้ได้

    var result = await dio.Dio().get(path);

    for (var element in json.decode(result.data)) {
      ImageUploadModel model = ImageUploadModel.fromMap(element);

      if (nameImage == model.image_name) {
        response = true;
      }
    }

    return response;
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Future<String> processUpload(
      {required File file,
      required String urlAPI,
      required String pathImage}) async {
    String? result;

    String nameFile = 'image${Random().nextInt(1000000)}.jpg';
    Map<String, dynamic> map = {};
    map['file'] =
        await dio.MultipartFile.fromFile(file.path, filename: nameFile);
    dio.FormData data = dio.FormData.fromMap(map);
    await dio.Dio().post(urlAPI, data: data).then((value) async {
      result = '$pathImage/$nameFile';
    });

    return result ?? '';
  }

  Future<File> processTakePhoto({required ImageSource source}) async {
    File file;
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    file = File(result!.path);
    return file;
  }

  Future<void> processFindLocation({required BuildContext context}) async {
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

  void openPermission({required BuildContext context}) {
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
