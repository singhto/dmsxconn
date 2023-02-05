import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:psinsx/models/insx_model2.dart';

class InsxShowDataSuccess extends StatefulWidget {
  final InsxModel2 insxModel2;
  final bool fromMap;
  InsxShowDataSuccess({Key key, this.insxModel2, this.fromMap})
      : super(key: key);

  @override
  _InsxShowDataSuccessState createState() => _InsxShowDataSuccessState();
}

class _InsxShowDataSuccessState extends State<InsxShowDataSuccess> {
  InsxModel2 insxModel2;
  File file;
  String urlImage;
  Location location = Location();
  double lat, lng;
  bool fromMap;

  @override
  void initState() {
    insxModel2 = widget.insxModel2;
    fromMap = widget.fromMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('อัพโหลดสมบูรณ์'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            nameCus(),
            ca(),
            peaNo(),
            writeId(),
            address(),
            showLocation(),
            SizedBox(height: 30),
            //groupImage(),
          ],
        ),
      ),
    );
  }

  Widget showLocation() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                'พนักงาน:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                '${insxModel2.worker_name}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );

  Widget nameCus() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                'ชื่อผู้ใช้ไฟ :',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                '${insxModel2.cus_name}',
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
                'CA:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.ca}',
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
                'PEA:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.pea_no}',
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
                'Line:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.write_id}',
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
                'ที่อยู่:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              child: Text(
                '${insxModel2.address}',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      );
}
