import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psinsx/models/insx_model2.dart';

class MyProcess {
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

  Future<Null> editDataInsx2(
      {@required InsxModel2 insxModel2,
      @required String distance,
      @required String work_image}) async {
    String url =
        'https://www.pea23.com/apipsinsx/editDataWhereInvoiceNo.php?isAdd=true&invoice_no=${insxModel2.invoice_no}&distance=$distance&work_image=$work_image';

    await Dio().get(url).then((value) {
      if (value.toString() != 'true') {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด กรุณาลองใหม่');
      }
    });
  }
}
