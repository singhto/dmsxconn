import 'package:flutter/material.dart';

class MyCalculate {
  
    String canculateDifferance(
      {@required String statusDate, @required String refNotification}) {
    String result;

      var stringsStatus = statusDate.split('-');
    int yearStatus = int.parse(stringsStatus[0]);
    int monthStatus = int.parse(stringsStatus[1]);
    int dayStatus = int.parse(stringsStatus[2]);
    DateTime statusDateTime = DateTime(yearStatus, monthStatus, dayStatus);

    var stringsrefNoti = refNotification.split('-');
    int yearRef = int.parse(stringsrefNoti[0]);
    int monthRef = int.parse(stringsrefNoti[1]);
    int dayRef = int.parse(stringsrefNoti[2]);
    DateTime refDateTime = DateTime(yearRef, monthRef, dayRef);
    
    var differance = statusDateTime.difference(refDateTime).inDays;
    result = differance.toString();
    result = 'เกินกำหนด : $result วัน';

    return result;
  }
}