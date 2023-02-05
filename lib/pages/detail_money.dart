import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:psinsx/models/dmsx_model.dart';
import 'package:psinsx/widgets/show_text.dart';

class DetaliMoney extends StatefulWidget {
  final List<Dmsxmodel> dmsxModels;
  const DetaliMoney({
    Key key,
    @required this.dmsxModels,
  }) : super(key: key);

  @override
  State<DetaliMoney> createState() => _DetaliMoneyState();
}

class _DetaliMoneyState extends State<DetaliMoney> {
  var dmsxModels = <Dmsxmodel>[];
  var fourDigis = <String>[];
  Map<String, int> map = {};
  double totel = 0, percent = 0;
  String percentStr, totelStr;

  Map<String, String> mapTH = {};

  @override
  void initState() {
    super.initState();
    dmsxModels = widget.dmsxModels;

    mapTH['WMMI'] = 'ต่อมิเตอร์แล้ว';
    mapTH['WMMR'] = 'ถอดมิเตอร์แล้ว';
    mapTH['FUCN'] = 'ต่อสายแล้ว';
    mapTH['FURM'] = 'ปลดสายแล้ว';
    mapTH['WMST'] = 'ผ่อนผันครั้งที่ 1';
    mapTH['WMS2'] = 'ผ่อนผันครั้งที่ 2';
    initData();
  }

  void initData() {
    var images = <String>[];

    for (var item in dmsxModels) {
      String string = item.images;

      print('##6jul string == $string');

      if (string.isNotEmpty) {
        string = string.substring(1, string.length - 1);
        if (string.contains(',')) {
          var results = string.split(',');
          for (var item in results) {
            images.add(item.trim().substring(0, 4));
          }
        } else {
          images.add(string.trim().substring(0, 4));
        }
      }
    } // for

    print('##6jul images ==>> $images');

    // การหา array ของรายการที่ไม่ซ้ำกัน และจำนวนที่ซ้ำ

    for (var item in images) {
      if (map.isEmpty) {
        map[item] = 1;
        fourDigis.add(item);
      } else {
        if (map[item] == null) {
          map[item] = 1;
          fourDigis.add(item);
        } else {
          map[item] = map[item] + 1;
        }
      }
    }

    // print('##6jul map แบบไม่ซ้ำ ก่อน check WMST WMS2 ==>> $map');

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

    // print('##6jul map แบบไม่ซ้ำ หลัง check WMST WMS2 ==>> $map');

    print('##6jul fourDigis ==>> $fourDigis');

    //การหา total

    Map<String, int> mapPrices = {};
    mapPrices['WMMI'] = 35;
    mapPrices['WMMR'] = 35;
    mapPrices['FUCN'] = 20;
    mapPrices['FURM'] = 20;
    mapPrices['WMST'] = 5;
    mapPrices['WMS2'] = 5;

    for (var item in fourDigis) {
      print('##6jul ส่วนของ $item ===> ${map[item] * mapPrices[item]}');

      totel = totel + (map[item] * mapPrices[item]);
    }

    NumberFormat numberFormatTotel = NumberFormat('##0.00', 'en_US');
    totelStr = numberFormatTotel.format(totel);

    //การหาเปอร์เซ็นต์

    if (map['WMST'] != null) {
      if (map['WMST'] != 1) {
        map['WMST']--;
      }
    }

    if (map['WMS2'] != null) {
      if (map['WMS2'] != 1) {
        map['WMS2']--;
      }
    }

    var keyPercents = [
      'WMMR',
      'FURM',
      'WMST',
      'WMS2',
    ];
    double grandTotle = 0;

    for (var item in keyPercents) {
      int totleInt = map[item] ?? 0;
      double totleDou = totleInt.toDouble();
      grandTotle = grandTotle + totleDou;
    }

    int wmmrInt = map['WMMR'] ?? 0;
    int furmInt = map['FURM'] ?? 0;
    int sumInt = wmmrInt + furmInt; //have Problem
    double sumDou = sumInt.toDouble();

    percent = sumDou / grandTotle * 100;

    NumberFormat numberFormat = NumberFormat('##0.00', 'en_US');
    percentStr = numberFormat.format(percent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('ผลงานดำเนินการ')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //showIncome(),
            Divider(
              color: Color.fromARGB(255, 237, 237, 234),
            ),
            ShowText(text: 'ประสิทธิภาพ'),
            ShowText(
              text: '$percentStr',
              textStyle: TextStyle(fontSize: 60),
            ),
            ShowText(text: '%'),
            Divider(
              color: Color.fromARGB(255, 237, 237, 234),
            ),
            listFourDigis(),
          ],
        ),
      ),
    );
  }

  Column showIncome() {
    return Column(
      children: [
        ShowText(text: 'รายได้วันนี้'),
        ShowText(
          text: totelStr,
          textStyle: TextStyle(fontSize: 60),
        ),
        ShowText(text: 'บาท'),
      ],
    );
  }

  Widget listFourDigis() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: fourDigis.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(left: 100),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ShowText(
                text: mapTH[fourDigis[index]],
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowText(
                text: map[fourDigis[index]].toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
