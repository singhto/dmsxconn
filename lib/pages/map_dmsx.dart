import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psinsx/models/dmsx_befor_image_model.dart';
import 'package:psinsx/models/dmsx_model.dart';
import 'package:psinsx/models/security_model.dart';
import 'package:psinsx/pages/detail_money.dart';
import 'package:psinsx/pages/dmsx_list_page.dart';
import 'package:psinsx/utility/app_controller.dart';
import 'package:psinsx/utility/app_service.dart';
import 'package:psinsx/utility/my_calculate.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_dialog.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:psinsx/utility/my_utility.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:psinsx/widgets/show_proogress.dart';

import 'package:path/path.dart' as path;
import 'package:psinsx/widgets/show_tetle.dart';
import 'package:psinsx/widgets/show_text.dart';
import 'package:psinsx/widgets/widget_icon_button.dart';
import 'package:psinsx/widgets/widget_text_button.dart';
import 'package:psinsx/widgets/widget_text_rich.dart';
import 'package:qrscan/qrscan.dart';
import 'package:url_launcher/url_launcher.dart';

class Mapdmsx extends StatefulWidget {
  @override
  _MapdmsxState createState() => _MapdmsxState();
}

class _MapdmsxState extends State<Mapdmsx> {
  Completer<GoogleMap> _controller = Completer();

  GoogleMapController? mapController;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(14.813808171680567, 100.96669116372476),
    zoom: 6,
  );

  bool load = true;
  Map<MarkerId, Marker> markers = {};
  Map<MarkerId, Marker> greenMarkers = {};
  Map<MarkerId, Marker> pubpleMarkers = {};
  Map<MarkerId, Marker> showMarkers = {};
  LatLng? startMapLatLng;

  String? statusText;
  List<String> titleStatuss = [];

  bool checkAmountImagebol = true; //true show เลือกรูป

  List<Dmsxmodel> dmsxModels = [];

  bool showDirction = false; // ไม่แสดงปุ่ม
  double? latDirection, lngDirection;
  int? indexDirection;

  bool? haveData; //true == haveData

  int amountGreen = 0;
  int amountPubple = 0;
  bool? greenStatus, pubpleStatus = false;

  var groupNameImages = <String>[];

  double total = 0;

  bool displayIconTakePhoto = true;

  @override
  void initState() {
    super.initState();
    readDataApi();
    AppService().processFindLocation(context: context);
  }

  void procressAddMarker(Dmsxmodel dmsxmodel, int index) {
    double hueDouble;

    switch (dmsxmodel.readNumber) {
      case 'ดำเนินการแล้ว':
        hueDouble = 0;
        greenStatus = false;
        pubpleStatus = false;
        break;
      case 'ต่อกลับแล้ว':
        hueDouble = 60;
        greenStatus = false;
        pubpleStatus = false;
        break;
      default:
        {
          hueDouble = 120;
          amountGreen++;
          greenStatus = true;
          pubpleStatus = false;
        }

        break;
    }

    switch (dmsxmodel.statusTxt) {
      case 'ให้ต่อมิเตอร์':
        hueDouble = 300;
        amountPubple++;
        pubpleStatus = true;
        break;
      case 'ให้ต่อสาย':
        hueDouble = 300;
        amountPubple++;
        pubpleStatus = true;
        break;
      case 'ต่อสายแล้ว':
        hueDouble = 60;
        pubpleStatus = false;
        break;
      case 'ต่อมิเตอร์แล้ว':
        hueDouble = 60;
        pubpleStatus = false;
        break;
    }

    MarkerId markerId = MarkerId(dmsxmodel.id!);
    Marker marker = Marker(
      onTap: () {
        indexDirection = index;

        checkDisplayIconTakePhoto(dmsxmodel: dmsxModels[indexDirection!]);

        print(
            '##6mar dmsxModel status --> ${dmsxModels[indexDirection!].status}');
        print(
            '###5feb dmsxModel statusText --> ${dmsxModels[indexDirection!].statusTxt}');

        latDirection = double.parse(dmsxmodel.lat!.trim());
        lngDirection = double.parse(dmsxmodel.lng!.trim());

        if (dmsxModels[indexDirection!].image_befor_wmmr!.isEmpty) {
          // takePhotoSpecial();
        }

        showDirction = true;
        setState(() {});
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(hueDouble),
      infoWindow: InfoWindow(
        onTap: () {
          print(
            ' click lat = $latDirection , $lngDirection',
          );
        },
        title: '${dmsxmodel.employeeId}',
        snippet: 'PEA : ${dmsxmodel.peaNo}',
      ),
      markerId: markerId,
      position: LatLng(
        double.parse(dmsxmodel.lat!.trim()),
        double.parse(
          dmsxmodel.lng!.trim(),
        ),
      ),
    );

    markers[markerId] = marker;
    if (greenStatus!) {
      greenMarkers[markerId] = marker;
    }
    if (pubpleStatus!) {
      pubpleMarkers[markerId] = marker;
    }
  }

  Future<void> readDataApi() async {
    print('#### readDataApi Work');

    if (markers.isNotEmpty) {
      markers.clear();
      greenMarkers.clear();
      pubpleMarkers.clear();
      amountGreen = 0;
      amountPubple = 0;
      total = 0;
    }

    await MyUtility().findUserId().then(
      (value) async {
        if (dmsxModels.isNotEmpty) {
          dmsxModels.clear();
        }
        String path =
            'https://www.dissrecs.com/apipsinsx/getDmsxWherUser.php?isAdd=true&user_id=$value';

        print('###1feb path ==>>> $path');

        await dio.Dio().get(path).then(
          (value) {
            setState(() {
              load = false;
            });
            if (value.toString() != 'null') {
              int index = 0;
              var images = <String>[];
              for (var item in json.decode(value.data)) {
                Dmsxmodel dmsxmodel = Dmsxmodel.fromMap(item);

                print(
                    '###1may dmsxmodel.status,  ====>>> ${dmsxmodel.dataStatus} ${dmsxmodel.refnoti_date}');

                String string = dmsxmodel.images!;
                if (string.isNotEmpty) {
                  string = string.substring(1, string.length - 1);

                  if (string.contains(',')) {
                    var result = string.split(',');
                    for (var i = 0; i < result.length; i++) {
                      images.add(result[i].trim());
                    }
                  } else {
                    images.add(string.trim());
                  }
                }

                ///if

                dmsxModels.add(dmsxmodel);
                print('#id == ${dmsxmodel.id}');

                setState(
                  () {
                    haveData = true;
                    procressAddMarker(dmsxmodel, index);
                    load = false;
                  },
                );
                index++;
              }

              var groupForDigi = <String>[];

              print('####30April images ===>>> $images');

              Map<String, double> map = {};

              for (var item in images) {
                String string = item.substring(0, 4);
                //print('###30April string $string');

                if (map.isEmpty) {
                  map[string] = 1.0;
                } else {
                  if (map[string] == null) {
                    map[string] = 1.0;
                  } else {
                    map[string] = map[string]! + 1.0;
                  }
                }

                if (groupForDigi.isEmpty) {
                  groupForDigi.add(string);
                } else {
                  bool status = true;
                  for (var item2 in groupForDigi) {
                    if (string == item2) {
                      status = false;
                    }
                  }
                  if (status) {
                    groupForDigi.add(string);
                  }
                }
              }

              // print('##6jul  groubFourDigi ==>> $groupForDigi');

              // if (map['WMST'] != null) {
              //   if (map['WMST'] != 1) {
              //     map['WMST']--;
              //   }
              // }

              // if (map['WMS2'] != null) {
              //   if (map['WMS2'] != 1) {
              //     map['WMS2']--;
              //   }
              // }

              print('##6jul  map ==>> $map');

              Map<String, double> mapPrices = {};
              mapPrices['WMMI'] = 35.0;
              mapPrices['WMMR'] = 35.0;
              mapPrices['FUCN'] = 20.0;
              mapPrices['FURM'] = 20.0;
              mapPrices['WMST'] = 5.0;
              mapPrices['WMS2'] = 5.0;

              for (var item4 in groupForDigi) {
                total = total + (map[item4]! * mapPrices[item4]!);
              }

              print('##6jul total ==>>> $total');

              // other
              showMarkers = markers;
              setState(() {});
            } else {
              setState(() {
                haveData = false;
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('position ->> ${appController.positions.length}');
          return Scaffold(
            body: ((load) &&
                    (appController.positions.isNotEmpty) &&
                    (haveData != null))
                ? ShowProgress()
                : haveData ?? false
                    ? showDataMap(appController: appController)
                    : const SizedBox(),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
            ),
          );
        });
  }

  Stack showDataMap({required AppController appController}) {
    return Stack(
      children: [
        buildMap(),
        buildMoney(),
        buildControl(),
        buildControlGreen(),
        buildControlPubple(),
        buildSearchButton(),
        showDirction ? buildDirction(appController: appController) : SizedBox(),
      ],
    );
  }

  // Positioned buildSearchButton() {
  //   return Positioned(
  //     top: 10,
  //     child: InkWell(
  //       onTap: (() => newSearch()),
  //       child: Card(
  //         color: Colors.black.withOpacity(0.5),
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             children: [
  //               Icon(Icons.search),
  //               Text(
  //                 'ค้นหา',
  //                 style: TextStyle(fontSize: 10),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Positioned buildSearchButton() {
    return Positioned(
      top: 10,
      child: Container(
        constraints: BoxConstraints(minWidth: 60),
        height: 70,
        child: InkWell(
          onTap: () => newSearch(),
          child: Card(
            color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search),
                    // Text(
                    //   amountGreen.toString(),
                    //   style: TextStyle(fontSize: 10),
                    // ),
                    Text(
                      'ค้นหา',
                      style: TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildMoney() {
    return Positioned(
      top: 10,
      left: 60,
      child: Container(
        constraints: BoxConstraints(minWidth: 60),
        height: 70,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetaliMoney(
                  dmsxModels: dmsxModels,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.black.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.read_more_rounded),
                    //Text('$total ฿'),
                    Text('ผลดำเนินการ', style: TextStyle(fontSize: 8)),
                    //Text('ประสิทธิภาพ', style: TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildControlGreen() {
    return Positioned(
      top: 150,
      child: Container(
        constraints: BoxConstraints(minWidth: 60),
        height: 80,
        child: InkWell(
          onTap: () {
            setState(() {
              showMarkers = greenMarkers;
            });
          },
          child: Card(
            color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pin_drop, color: Colors.green),
                    Text(
                      amountGreen.toString(),
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      'รอดำเนินการ',
                      style: TextStyle(fontSize: 6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildControlPubple() {
    return Positioned(
      top: 230,
      child: Container(
        constraints: BoxConstraints(minWidth: 60),
        height: 80,
        child: InkWell(
          onTap: () {
            setState(() {
              showMarkers = pubpleMarkers;
            });
          },
          child: Card(
            color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.pin_drop,
                      color: Colors.purple,
                    ),
                    Text(
                      amountPubple.toString(),
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      'ให้ต่อกลับ',
                      style: TextStyle(fontSize: 6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container showNodata() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ไม่พบข้อมูลครับ',
              style: TextStyle(fontSize: 26.0),
            ),
            TextButton(
                onPressed: () {
                  launchURLloadWork();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const ShowWebView(url: 'https://dissrecs.com/index.php',),
                  //   ),
                  // );
                },
                child: Text('คลิก! ดึงข้อมูลงานงดจ่ายไฟ'))
          ],
        ),
      ),
    );
  }

  Future<Null> launchURLloadWork() async {
    final url = 'https://www.dissrecs.com/index.php';
    await launch(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Unable to open URL $url');
      // throw 'Could not launch $url';
    }
  }

  Column buildDirction({required AppController appController}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ShowText(text: 'สาย: ${dmsxModels[indexDirection!].line}'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShowText(text: 'ca: ${dmsxModels[indexDirection!].ca}'),
                    WidgetIconButton(
                      iconData: Icons.copy,
                      pressFunc: () {
                        Clipboard.setData(
                            ClipboardData(text: dmsxModels[indexDirection!].ca!));
                        print('copy success');
                      },
                    )
                  ],
                ),
            
                ShowTitle(
                  title: MyCalculate().canculateDifferance(
                      statusDate: dmsxModels[indexDirection!].dataStatus!,
                      refNotification: dmsxModels[indexDirection!].refnoti_date!),
                ),
                ShowText(
                    text: 'ล่าสุด: ${dmsxModels[indexDirection!].statusTxt}'),
                ((dmsxModels[indexDirection!].statusTxt == 'ต่อมิเตอร์แล้ว') ||
                        (dmsxModels[indexDirection!].statusTxt == 'ต่อสายแล้ว'))
                    ? WidgetIconButton(
                        iconData: Icons.qr_code,
                        pressFunc: () async {
                          MyDialog(context: context).normalDialot(
                            title: 'เลือกวิธีบันทึกบาร์โค้ด',
                            subTitle: 'กรุณาเลือกวิธีการบันทึก SerialNo',
                            firstButton: WidgetTextButton(
                              label: 'แสกนบาร์โค้ด',
                              pressFunc: () async {
                                Navigator.pop(context);
                                try {
                                  await Permission.camera.status
                                      .then((value) async {
                                    if (value.isDenied) {
                                      await Permission.camera
                                          .request()
                                          .then((value) {
                                        if (value.isGranted) {
                                          //ok
                                        } else {
                                          //cameraoff
                                        }
                                      });
                                    } else {
                                      //ok
                                      var result = await scan();
                                      if (reactive != null) {
                                        print('result --> $result');

                                        resultDialog(result!,
                                            indexDirection: indexDirection!);
                                      }
                                    }
                                  });
                                } catch (e) {
                                  print('error--> $e');
                                }
                              },
                            ),
                            secondButton: WidgetTextButton(
                                label: 'พิมพ์ตัวเลข',
                                pressFunc: () {
                                  Navigator.pop(context);

                                  String? result;

                                  MyDialog(context: context).normalDialot(
                                      title: 'กรอกตัวเลข',
                                      subTitle: '',
                                      contentWidget: TextFormField(
                                        onChanged: ((value) {
                                          result = value.trim();
                                        }),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      firstButton: WidgetTextButton(
                                        label: 'บันทึก',
                                        pressFunc: () {
                                          if (result!.isNotEmpty) {
                                            Navigator.pop(context);
                                            print('reult --> $result');
                                            resultDialog(result!,
                                                indexDirection: indexDirection!);
                                          }
                                        },
                                      ));
                                }),
                          );
                        },
                        edgeInsetsGeometry: EdgeInsets.symmetric(horizontal: 4),
                      )
                    : const SizedBox(),
                Row(
                  children: [
                    ShowText(text: 'ชื่อ:'),
                    ShowText(text: dmsxModels[indexDirection!].cusName!),
                  ],
                ),

                ShowText(text: dmsxModels[indexDirection!].address!),
                buildImages(dmsxModels[indexDirection!].images!),
                // Row(
                //   children: [
                //     ShowText(
                //         text:
                //             '${dmsxModels[indexDirection].lat}, ${dmsxModels[indexDirection].lng}'),
                //     WidgetIconButton(
                //       iconData: Icons.edit,
                //       pressFunc: () {
                //         final keyForm = GlobalKey<FormState>();

                //         TextEditingController textEditingController =
                //             TextEditingController();

                //         MyDialog(context: context).normalDialot(
                //             title: 'แก้ไข',
                //             subTitle: 'แก้ไขพิกัด',
                //             contentWidget: Form(
                //               key: keyForm,
                //               child: TextFormField(
                //                 controller: textEditingController,
                //                 validator: (value) {
                //                   if (value.isEmpty) {
                //                     return 'มีช่องว่าง';
                //                   }
                //                   if (!(value.contains(','))) {
                //                     return 'lat และ lng ต้องมี , คั่น ';
                //                   } else {
                //                     return null;
                //                   }
                //                 },
                //                 decoration: InputDecoration(
                //                     errorStyle: TextStyle(
                //                         color: Colors.amber, fontSize: 14),
                //                     filled: true,
                //                     border: InputBorder.none),
                //               ),
                //             ),
                //             firstButton: WidgetTextButton(
                //               label: 'แก้ไข',
                //               pressFunc: () {
                //                 if (keyForm.currentState.validate()) {
                //                   List<String> string =
                //                       textEditingController.text.split(',');

                //                   try {
                //                     double lat = double.parse(string[0].trim());
                //                     double lng = double.parse(string[0].trim());

                //                     Get.back();
                //                   } catch (e) {
                //                     Get.snackbar(
                //                         'Eror', 'อักษรไม่สามารถทำเป็นจำนวนได้',
                //                         backgroundColor: Colors.red.shade700,
                //                         colorText: Colors.white);
                //                   }
                //                 }
                //               },
                //             ));
                //       },
                //     )
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          //print('== Tel');
                          final tel =
                              'tel:${dmsxModels[indexDirection!].tel!.trim()}';
                          if (await canLaunch(tel)) {
                            await launch(tel);
                          } else {
                            throw 'Cannot Phone';
                          }
                        },
                        child: ShowText(text: 'โทร')),
                    ElevatedButton(
                      onPressed: () async {
                        final url =
                            'https://www.google.com/maps/search/?api=1&query=$latDirection, $lngDirection';
                        await launch(url);
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print('Unable to open URL $url');
                          // throw 'Could not launch $url';
                        }
                      },
                      child: Text('นำทาง'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var permissionStorage = await Permission.storage.status;

                        // if (permissionStorage.isDenied) {
                        //   print('##18aug permisionSrot');

                        //   MyDialog(context: context).normalDialot(
                        //       title: 'พื้นที่จัดเก็บปิดใช้งานอยู่',
                        //       subTitle: 'กรุณาอนุญาติแอพ',
                        //       firstButton: WidgetTextButton(
                        //         label: 'ไปอนุญาตแอพ',
                        //         pressFunc: () async {
                        //           navigator.pop();
                        //           // openAppSettings();

                        //           await Permission.storage.request();

                        //         },
                        //       ));
                        // } else {
                        double latDou =
                            double.parse(dmsxModels[indexDirection!].lat!);
                        double lngDou =
                            double.parse(dmsxModels[indexDirection!].lng!);

                        if (appController.positions.isNotEmpty) {
                          Position position = appController.positions.last;

                          print(
                              '##18aug You Click Her latDou = $latDou lngDou = $lngDou');

                          print('##18aug posion= $position');

                          double distance = AppService().calculateDistance(
                              position.latitude,
                              position.longitude,
                              latDou,
                              lngDou);

                          print('##18aug distance= $distance');

                          NumberFormat numberFormat =
                              NumberFormat('##0.0#', 'en_US');

                          String distanceStr = numberFormat.format(distance);

                          processTakePhoto(
                              dmsxmodel: dmsxModels[indexDirection!],
                              source: ImageSource.gallery,
                              distance: distanceStr,
                              position: position);
                        }
                        // }
                      },
                      child: ShowText(text: 'เลือกรูป'),
                    ),
                    displayIconTakePhoto
                        ? WidgetIconButton(
                            iconData: Icons.warning_outlined,
                            pressFunc: () async {
                              MyDialog(context: context).normalDialot(
                                  title: 'ถ่ายภาพสภาพมิเตอร์',
                                  subTitle:
                                      'คำแนะนำ: หากต้องการเก็บหลักฐานสภาพแวดล้อมของมิเตอร์ก่อนดำเนินการ กรุณาถ่ายภาพ',
                                  firstButton: WidgetTextButton(
                                    label: 'ถ่ายภาพ',
                                    pressFunc: () async {
                                      navigator?.pop();
                                      var perCamera =
                                          await Permission.camera.status;

                                      if (perCamera.isDenied) {
                                        //Call Permision

                                        MyDialog(context: context).normalDialot(
                                            title: 'กล้องปิดใช้งานอยู่',
                                            subTitle: 'กรุณาอนุญาติแอพ',
                                            firstButton: WidgetTextButton(
                                              label: 'ไปอนุญาตแอพ',
                                              pressFunc: () {
                                                navigator?.pop();
                                                openAppSettings();
                                              },
                                            ));
                                      } else {
                                        var result =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.camera,
                                          maxWidth: 800,
                                          maxHeight: 800,
                                        );

                                        if (result != null) {
                                          File file = File(result.path);

                                          String urlUpload =
                                              'https://www.dissrecs.com/apipsinsx/saveFileBeforDmsx.php';
                                          String nameFile =
                                              '${dmsxModels[indexDirection!].ca}_${dmsxModels[indexDirection!].dataStatus}.jpg';
                                          Map<String, dynamic> map = {};
                                          map['file'] =
                                              await dio.MultipartFile.fromFile(
                                                  file.path,
                                                  filename: nameFile);
                                          dio.FormData formData =
                                              dio.FormData.fromMap(map);
                                          await dio.Dio()
                                              .post(urlUpload, data: formData)
                                              .then((value) async {
                                            String urlImage =
                                                'https://www.dissrecs.com/apipsinsx/uploadBeforDmsx/$nameFile';
                                            print('##29jan --> $urlImage');

                                            String urlInsert =
                                                'https://www.dissrecs.com/apipsinsx/insertDataBeforDmsx.php?isAdd=true&ca=${dmsxModels[indexDirection!].ca}&pea_on=${dmsxModels[indexDirection!].peaNo}&image_name=$urlImage&user_id=${dmsxModels[indexDirection!].userId}';
                                            await dio.Dio()
                                                .get(urlInsert)
                                                .then((value) {
                                              // Navigator.pop(context);

                                              checkDisplayIconTakePhoto(
                                                  dmsxmodel: dmsxModels[
                                                      indexDirection!]);
                                            });
                                          });
                                        }
                                      }
                                    },
                                  ));
                            },
                          )
                        : const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> resultDialog(String result,
      {required int indexDirection}) async {
    String path =
        'https://www.dissrecs.com/apipsinsx/getSecurityWhereSerialNo.php?isAdd=true&serial_no=$result';

    var response = await Dio().get(path);
    if (response.toString() == 'null') {
      //code readed false
      MyDialog(context: context)
          .normalDialot(title: 'เลขผิด', subTitle: 'ไม่มีเลข Security นี้');
    } else {
      //code readed true
      MyDialog(context: context).normalDialot(
          title: 'SecurityNo : $result',
          subTitle: '',
          contentWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              WidgetTextRich(head: 'ca', value: dmsxModels[indexDirection].ca!),
              WidgetTextRich(
                  head: 'ใบสั่ง', value: dmsxModels[indexDirection].notice!),
              WidgetTextRich(
                  head: 'pea', value: dmsxModels[indexDirection].peaNo!),
              WidgetTextRich(
                  head: 'ชื่อ', value: dmsxModels[indexDirection].cusName!),
            ],
          ),
          firstButton: WidgetTextButton(
            label: 'บันทึก',
            pressFunc: () async {
              for (var element in json.decode(response.data)) {
                SecurityModel model = SecurityModel.fromMap(element);
                print('##31mar secutityModel readed --> ${model.toMap()}');

                Map<String, dynamic> map = model.toMap();
                map['notice'] = dmsxModels[indexDirection].notice;
                map['ca'] = dmsxModels[indexDirection].ca;
                map['pea_no'] = dmsxModels[indexDirection].peaNo;
                map['user_id'] = dmsxModels[indexDirection].userId;

                print('##31mar map ==> $map');

                model = SecurityModel.fromMap(map);

                String urlApi =
                    'https://www.dissrecs.com/apipsinsx/editSecurityWhereSerialNo.php?isAdd=true&serial_no=${model.serial_no}&notice=${model.notice}&ca=${model.ca}&pea_no=${model.pea_no}&user_id=${model.user_id}';
                await Dio().get(urlApi).then((value) {
                  Fluttertoast.showToast(msg: 'อัพเดทสำเร็จ');
                  Navigator.pop(context);
                });
              }
            },
          ));
    }
  }

  void takePhotoSpecial() {
    print(
        '###5feb statusText after takePhoto --> ${dmsxModels[indexDirection!].statusTxt}');

    if (dmsxModels[indexDirection!].statusTxt == 'ถอดมิเตอร์แล้ว') {
      MyDialog(context: context).normalDialot(
          title: 'สถานะ : ถอดมิเตอร์แล้ว',
          subTitle:
              'หลังจาก ถอดมิเตอร์แล้ว ให้ถ่ายภาพแป้นที่ติดตั้งมิเตอร์เพื่อเป็นหลักฐานการ เขียนเลข PEA และเลขอ่านหน่วยให้ชัดเจน',
          firstButton: WidgetTextButton(
            label: 'ถ่ายภาพ',
            pressFunc: () async {
              // Navigator.pop(context);
              File file = await AppService()
                  .processTakePhoto(source: ImageSource.camera);
              if (file != null) {
                Navigator.pop(context);
                MyDialog(context: context).normalDialot(
                    title: 'รูปภาพหลัง ถอดมิเตอร์',
                    subTitle:
                        'มั่นใจว่าได้ภาพที่ชัดเจนแล้วนะ กดอัพโหลดได้เลยครับ',
                    contentWidget: SizedBox(
                      width: 300,
                      height: 200,
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      ),
                    ),
                    firstButton: WidgetTextButton(
                      label: 'อัพโหลดภาพ',
                      pressFunc: () async {
                        MyDialog(context: context).processDialog();

                        String urlApi =
                            'https://www.dissrecs.com/apipsinsx/saveFileBeforWmmr.php';
                        String pathImage =
                            'https://www.dissrecs.com/apipsinsx/uploadBeforWmmr';

                        await AppService()
                            .processUpload(
                                file: file,
                                urlAPI: urlApi,
                                pathImage: pathImage)
                            .then(
                          (value) async {
                            String urlImage = value;
                            print('###5feb urlImage -->> $urlImage');

                            String urlApi =
                                'https://www.dissrecs.com/apipsinsx/insertBeforWmnr.php?isAdd=true&docId=${dmsxModels[indexDirection!].docID}&ca=${dmsxModels[indexDirection!].ca}&pea_on=${dmsxModels[indexDirection!].peaNo}&image_name=$urlImage&image_date=${dmsxModels[indexDirection!].dataStatus}&user_id=${dmsxModels[indexDirection!].userId}';
                            await dio.Dio().get(urlApi).then((value) {
                              readDataApi();
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: 'อัพโหลดสำเร็จ');
                            });
                          },
                        );
                      },
                    ));
              } else {}
            },
          ));
    }
  }

  Widget buildImages(String strings) {
    if (strings.isEmpty) {
      return SizedBox();
    } else {
      var image = strings.substring(1, strings.length - 1);
      var images = image.split(',');

      var widgets = <Widget>[];
      for (var item in images) {
        print('@@===> ${MyConstant.domainImage}${item.trim()}');
        widgets.add(
          Container(
            margin: EdgeInsets.all(8),
            width: 100,
            height: 80,
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => MyStyle().showLogo(),
              imageUrl: '${MyConstant.domainImage}${item.trim()}',
              fit: BoxFit.cover,
            ),
          ),
        );
      }

      return Row(
        children: widgets,
      );
    }
  }

  Future<Null> launchURL() async {
    final url = 'https://www.dissrecs.com';
    await launch(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Unable to open URL $url');
      // throw 'Could not launch $url';
    }
  }

  Widget buildControl() => Positioned(
        top: 80,
        child: InkWell(
          onTap: () {
            setState(() {
              showMarkers = markers;
            });
          },
          child: Container(
            width: 60,
            height: 70,
            child: Card(
              color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        size: 12,
                      ),
                      Text(
                        markers.length.toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        'ทั้งหมด',
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void newSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DmsxListPage(dmsxModels: dmsxModels),
      ),
    ).then((value) {
      var result = value;
      for (var item in result) {
        Dmsxmodel dmsxmodel = item;
        print('lat == ${dmsxmodel.lat}');

        if (!((dmsxmodel.lat == '0') || (dmsxmodel.lng == '0'))) {
          LatLng latlng =
              LatLng(double.parse(dmsxmodel.lat!), double.parse(dmsxmodel.lng!));
          mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: latlng, zoom: 16)));
        } else {
          Fluttertoast.showToast(msg: 'ไม่พบหมุด');
        }
      }
      readDataApi();
    });
  }

  GoogleMap buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        _controller.complete();
      },
      onTap: (argument) {
        setState(() {
          showDirction = false;
        });
      },
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(showMarkers.values),
    );
  }

  Future<void> processAddImage(Dmsxmodel dmsxmodel) async {
    print('# image ${dmsxmodel.images}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ชื่อ-สกุล: ${dmsxmodel.cusName}',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
              Text(
                'สถานะล่าสุด: ${dmsxmodel.statusTxt}',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
              Text(
                'สาย: ${dmsxmodel.line}',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                'ca: ${dmsxmodel.ca}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'PEA : ${dmsxmodel.peaNo}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'ที่อยู่ : ${dmsxmodel.address}',
                style: TextStyle(fontSize: 12),
              ),
              dmsxmodel.images!.isEmpty ? SizedBox() : showListImages(dmsxmodel),
            ],
          ),
        ),
        actions: [
          checkAmountImagebol
              ? TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    processTakePhoto(
                        dmsxmodel: dmsxmodel,
                        source: ImageSource.gallery,
                        distance: null,
                        position: null)
                        ;
                  },
                  child: Text('เลือกรูป'),
                )
              : SizedBox(),
          TextButton(
            onPressed: () {
              checkAmountImagebol = true;
              Navigator.pop(context);
            },
            child: Text('ปิด'),
          ),
        ],
      ),
    );
  }

  Widget createListStatus(StateSetter mySetState) {
    List<Widget> widgets = [];

    for (var item in titleStatuss) {
      widgets.add(RadioListTile(
        title: Text(
          item,
          style: TextStyle(fontSize: 14),
        ),
        value: item,
        groupValue: statusText,
        onChanged: (value) {
          mySetState(() {
            statusText = value;
            print('statusText = $statusText');
          });
          setState(() {
            showUpload = true;
          });
        },
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  bool showUpload = false; // false Non Show Button Upload

  Future<void> processTakePhoto(
      {required Dmsxmodel dmsxmodel,
      ImageSource? source,
       String? distance,
       Position? position}) async {
    try {
      print('##14dec processTakePhoto Work');
      // var re = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: ['png'],
      //   // allowedExtensions: ['jpg', 'jpeg', 'png', 'heic'],
      // );

      // File file = File(re.files.single.path);

      var result = await ImagePicker().pickImage(source: ImageSource.gallery);
      File file = File(result!.path);
      print('###14 filePateh = ${file.path}');

      print('@@dmsx filePath = ${file.path}');

      setState(() {});

      var namePath = file.path;
      var string = namePath.split('/');
      var nameImage = string.last;

      print('@@dmsx nameImage = $nameImage');

      nameImage = nameImage.substring(0, 4);
      nameImage = converNameImage(nameImage);

      switch (dmsxmodel.statusTxt!.trim()) {
        case 'เริ่มงดจ่ายไฟ':
          titleStatuss = MyConstant.statusTextsNonJay;
          break;
        case 'ขอผ่อนผันครั้งที่ 1':
          titleStatuss = MyConstant.statusTextsWMST1;
          break;
        case 'ขอผ่อนผันครั้งที่ 2':
          titleStatuss = MyConstant.statusTextsWMST2;
          break;
        case 'ปลดสายแล้ว':
          titleStatuss = MyConstant.statusTextsFURM;
          break;
        case 'ถอดมิเตอร์แล้ว':
          titleStatuss = MyConstant.statusTextsWMMR;
          break;
        case 'ให้ต่อสาย':
          titleStatuss = MyConstant.statusTextsFUCM;
          break;
        case 'ให้ต่อมิเตอร์':
          titleStatuss = MyConstant.statusTextsWMSTT;
          break;

        case 'คำสั่งให้ถอดมิเตอร์':
          titleStatuss = MyConstant.statusTextsTodd;
          break;

        default:
          titleStatuss = MyConstant.statusTextsJay;
          break;
      }

      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ชื่อ-สกุล: ${dmsxmodel.cusName}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'PEA: ${dmsxmodel.peaNo}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'สถานะล่าสุด: ${dmsxmodel.statusTxt}',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  Text(
                    position == null ? '' : 'พิกัดเครื่อง: ${position.latitude} ${position.longitude}',
                    style: TextStyle(fontSize: 12),
                  ),
                  distance == null
                      ? const SizedBox()
                      : Text(
                          'ระยะห่าง : $distance กม.',
                          style: TextStyle(fontSize: 12),
                        ),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(file),
                  ShowText(
                    text: nameImage,
                    textStyle: MyConstant().h2Style(),
                  ),
                  //createListStatus(setState),
                ],
              ),
            ),
            actions: [
              //showUpload ? buttonUpImage(context, file, dmsxmodel) : SizedBox(),
              position == null ? SizedBox()   : buttonUpImage(context, file, dmsxmodel,
                  position: position, distanceStr: distance ?? ''),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          );
        }),
      );
    } catch (e) {}
  }

  Widget buttonUpImage(BuildContext context, File file, Dmsxmodel dmsxmodel,
      {required Position position, required String distanceStr}) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context);
        String nameWithoutExtension = path.basenameWithoutExtension(file.path);
        var name = nameWithoutExtension.split("_");
        var code = name[0].substring(4, name[0].length);

        print('dmsx name[0] = ${name[0]}');

        print('30jan  dmsxdel.ca == ${dmsxmodel.ca}, ');

        print('dmsx code = $code');

        if ((code.trim() != dmsxmodel.ca!.trim()) &&
            (code.trim() != dmsxmodel.peaNo!.trim())) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('รูปภาพไม่ถูกต้อง'),
              content: const Text('กรุณาตรวจสอบไฟล์ภาพอีกครั้ง'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'ปิด'),
                  child: const Text('ปิด'),
                ),
              ],
            ),
          );
        } else {
          String nameFile = path.basename(file.path);
          print('##6mar nameFile = $nameFile');
          print('##6mar nameFile บน servver = ${dmsxmodel.images}');

          if (dmsxmodel.images?.isEmpty ?? true) {
            await processUploadAndEdit(file, nameFile, dmsxmodel,
                position: position, distanceStr: distanceStr);
          } else {
            String string = dmsxmodel.images!;
            string = string.substring(1, string.length - 1);
            List<String> images = string.split(',');
            int i = 0;
            for (var item in images) {
              images[i] = item.trim();
              i++;
            }

            print('30jan images ===> $images');

            bool dulucapeImage = false;

            for (var item in images) {
              if (nameFile.trim() == item.trim()) {
                dulucapeImage = true;
              }
            }

            print('30jan dulucapImage === $dulucapeImage');

            if (!dulucapeImage) {
              await processUploadAndEdit(file, nameFile, dmsxmodel,
                  position: position, distanceStr: distanceStr);
            } else {
              //รูปซ้ำ
              print('รูปซ้ำ');
              normalDialog(context, 'รูปซ้ำครับ');
            }
          }
        } //end if
      },
      child: Text('อัพโหลด'),
    );
  }

  Future<void> processUploadAndEdit(
      File file, String nameFile, Dmsxmodel dmsxmodel,
      {required Position position, required String distanceStr}) async {
    String pathUpload = 'https://www.dissrecs.com/apipsinsx/saveImageCustomer.php';

    Map<String, dynamic> map = {};
    map['file'] =
        await dio.MultipartFile.fromFile(file.path, filename: nameFile);
    dio.FormData data = dio.FormData.fromMap(map);

    await dio.Dio().post(pathUpload, data: data).then((value) async {
      print('# === value for upload ==>> $value');

      List<String> images = [];
      var listStatus = <String>[];

      print('@@ statusText === $statusText');

      if (dmsxmodel.images!.isEmpty) {
        images.add(nameFile);
      } else {
        String string = dmsxmodel.images!;
        string = string.substring(1, string.length - 1);
        images = string.split(',');
        int index = 0;
        for (var item in images) {
          images[index] = item.trim();
          index++;
        }
        images.add(nameFile);

        String statusTextCurrent = dmsxmodel.statusTxt!;
        statusTextCurrent =
            statusTextCurrent.substring(1, statusTextCurrent.length - 1);
        listStatus = statusTextCurrent.split(',');
        int i = 0;
        for (var item in listStatus) {
          listStatus[i] = item.trim();
          i++;
        }
        listStatus.add(statusText!);
      }

      String readNumber = 'ดำเนินการแล้ว';

      if (dmsxmodel.readNumber!.isEmpty) {
        readNumber = 'ดำเนินการแล้ว';
      } else {
        readNumber = 'ต่อกลับแล้ว';
      }

      print('@@ listStatus === $listStatus');

      String apiEditImages =
          'https://www.dissrecs.com/apipsinsx/editDmsxWhereId.php?isAdd=true&id=${dmsxmodel.id}&images=${images.toString()}&status_txt=$statusText&readNumber=$readNumber&latMobile=${position.latitude}&lngMobile=${position.longitude}&distaneMobile=$distanceStr';

      await dio.Dio().get(apiEditImages).then((value) {
        print('value update == $value');
        readDataApi().then((value) {
          // takePhotoSpecial();
        });
      });
    });
  }

  Widget showListImages(Dmsxmodel dmsxmodel) {
    print('##### image ==> ${dmsxmodel.images}');
    List<Widget> widgets = [];

    String string = dmsxmodel.images!;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    print('### strings ==> $strings');

    for (var item in strings) {
      widgets.add(
        Container(
          height: 180,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: CachedNetworkImage(
                imageUrl: '${MyConstant.domainImage}${item.trim()}',
                //fit: BoxFit.cover,
                placeholder: (context, url) => ShowProgress(),
                errorWidget: (context, url, error) => SizedBox(),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: widgets,
    );
  }

  void checkAmountImage(String images) {
    String string = images;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    if (strings.length >= 2) {
      setState(() {
        checkAmountImagebol = false;
      });
    }
  }

  String converNameImage(String nameImage) {
    switch (nameImage) {
      case 'ASGD':
        statusText = 'เริ่มงดจ่ายไฟ';
        return statusText!;
        break;
      case 'WMMI':
        statusText = 'ต่อมิเตอร์แล้ว';
        return statusText!;
        break;
      case 'WMMR':
        statusText = 'ถอดมิเตอร์แล้ว';
        return statusText!;
        break;
      case 'FUCN':
        statusText = 'ต่อสายแล้ว';
        return statusText!;
        break;
      case 'FURM':
        statusText = 'ปลดสายแล้ว';
        return statusText!;
        break;
      case 'WMST':
        statusText = 'ผ่อนผันครั้งที่ 1';
        return statusText!;
        break;
      case 'WMS2':
        statusText = 'ผ่อนผันครั้งที่ 2';
        return statusText!;
        break;
      default:
        {
          statusText = 'รูปภาพไม่ถูกต้อง';
          return statusText!;
        }
    }
  }

  Future<void> checkDisplayIconTakePhoto(
      {required Dmsxmodel dmsxmodel}) async {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String currentDateTime = dateFormat.format(dateTime);
    print('##29jan currentDateTime $currentDateTime');

    String urlAPI =
        'https://www.dissrecs.com/apipsinsx/getDmsxBeforImage.php?isAdd=true&ca=${dmsxmodel.ca}';
    await dio.Dio().get(urlAPI).then((value) {
      if (value.toString() == 'null') {
        displayIconTakePhoto = true;
      } else {
        for (var element in json.decode(value.data)) {
          DmsxBeforImageModel model = DmsxBeforImageModel.fromMap(element);

          print('##29jan --->> dmsxModel ${model.toMap()}');

          if (model.ca == dmsxmodel.ca) {
            displayIconTakePhoto = false;
          }
        }
      }
      setState(() {});
    });
  }
}

// ASGD = เริ่มงดจ่ายไฟ
// WMMI = ต่อมิเตอร์แล้ว  * 35
// WMMR = ถอดมิเตอร์แล้ว * 35
// FUCN = ต่อสายแล้ว * 20
// FURM = ปลดสายแล้ว * 20
// WMST = ผ่อนผันครั้งที่ 1 * 10
// WMS2 = ผ่อนผันครั้งที่ 2 * 10

// ( FURM + FUCN + WMMR + WMST + WMS2 ) - (WMST + WMS2) 
