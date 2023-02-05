import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:psinsx/models/insx_check_model.dart';
import 'package:url_launcher/url_launcher.dart';

class InsxShowDataCheck extends StatefulWidget {
  final InsxCheckModel insxCheckModels;
  final bool fromMap;
  InsxShowDataCheck({Key key, this.insxCheckModels, this.fromMap})
      : super(key: key);

  @override
  _InsxShowDataCheckState createState() => _InsxShowDataCheckState();
}

class _InsxShowDataCheckState extends State<InsxShowDataCheck> {
  InsxCheckModel insxCheckModels;
  File file;
  String urlImage;
  Location location = Location();
  double lat, lng;
  bool fromMap;

  @override
  void initState() {
    insxCheckModels = widget.insxCheckModels;
    fromMap = widget.fromMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100,
          title: Text('บันทึกข้อมูล'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            nameCus(),
            ca(),
            peaNo(),
            writeId(),
            address(),
            imgDate(),
            showLocation(),
            SizedBox(height: 30),
            groupImage(),
          ],
        ),
      ),
    );
  }

  Widget imgDate() => GestureDetector(
        onTap: () async {
          print('click click:::');
          String url = insxCheckModels.ptcInsx;
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'ไม่พบ $url';
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  'ดำเนินการเมื่อ :',
                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  '${insxCheckModels.imgDate}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget showLocation() => GestureDetector(
        onTap: () async {
          print('click click:::');
          String url = insxCheckModels.ptcInsx;
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'ไม่พบ $url';
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  'แผนที่ :',
                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  '${insxCheckModels.ptcInsx}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget nameCus() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                'ชื่อ-สกุล :',
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                '${insxCheckModels.cusName}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      );

  Widget ca() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'CA :',
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxCheckModels.ca}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget peaNo() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'PEA :',
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxCheckModels.peaNo}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget writeId() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'Invoice :',
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxCheckModels.invoiceNo}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget address() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'มือถือ :',
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              child: Text(
                '${insxCheckModels.cusTel}',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      );

  Widget groupImage() => Container(
        child: Image.network(
          insxCheckModels.imageInsx,
          height: 250,
          fit: BoxFit.cover,
        ),
      );
}
