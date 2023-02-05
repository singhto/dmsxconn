import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/utility/custom_dialog.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:flutter/services.dart';
import 'package:psinsx/utility/my_process.dart';
import 'package:psinsx/utility/sqlite_helper.dart';

class InsxEditOld extends StatefulWidget {
  final InsxModel2 insxModel2;
  final bool fromMap;
  InsxEditOld({Key key, this.insxModel2, this.fromMap}) : super(key: key);

  @override
  _InsxEditOldState createState() => _InsxEditOldState();
}

class _InsxEditOldState extends State<InsxEditOld> {
  InsxModel2 insxModel2;
  File file;
  String urlImage;
  Location location = Location();
  double lat, lng;
  bool fromMap;
  String distanceStr;

  double distanceDou;

  @override
  void initState() {
    // TODO: implement initState

    insxModel2 = widget.insxModel2;
    fromMap = widget.fromMap;
    findLatLng();
  }

  Row showDistance() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ระยะห่าง:',
            style: TextStyle(fontSize: 26),
          ),
        ),
        Text(
          '$distanceStr เมตร',
          style: TextStyle(fontSize: 26),
        ),
      ],
    );
  }

  void myCalculateDistance() {
    double lat2Dou = double.parse(insxModel2.lat);
    double lng2Dou = double.parse(insxModel2.lng);

    distanceDou =
        MyProcess().calculateDistance(lat, lng, lat2Dou, lng2Dou) * 1000;

    NumberFormat numberFormat = NumberFormat('#0.00', 'en_US');
    distanceStr = numberFormat.format(distanceDou);
  }

  void checkDistanceDiaiog(double distanceDou) {
    if (distanceDou > 200) {
      CustomDialog().actionDialog(
          context: context,
          title: 'เกินระยะ',
          subTitle: 'ระยะห่างเกิน $distanceStr เมตร',
          label: 'ลุยต่อ',
          pressFunc: () {
            Navigator.pop(context);
            editDataInsx(insxModel2);
          },
          label2: 'กลับ',
          pressFucn2: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
    }
  }

  Future<Null> findLatLng() async {
    Position position = await findPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
    myCalculateDistance();
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('บันทึกข้อมูล'),
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
            showLocation(),
            showDistance(),
            SizedBox(height: 80),
            groupImage(),
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
                'พิกัดผู้ใช้ไฟ:',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 14),
            child: Text(
              '${insxModel2.lat}, ${insxModel2.lng}',
              style: TextStyle(fontSize: 12, color: Colors.red),
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
                'ชื่อ-สกุล:',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 14),
              child: Text(
                '${insxModel2.cus_name}',
                style: TextStyle(fontSize: 12),
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
                style: TextStyle(fontSize: 12),
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
          IconButton(
            icon: Icon(Icons.copy_outlined),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: "${insxModel2.ca}"));
              Fluttertoast.showToast(msg: 'คัดลอก ${insxModel2.ca}');
              print(insxModel2.ca);
            },
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
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${insxModel2.pea_no}',
                  style: TextStyle(fontSize: 12),
                ),
                IconButton(
                  icon: Icon(Icons.copy_outlined),
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: "Gis ${insxModel2.pea_no}"));
                    Fluttertoast.showToast(
                        msg: 'คัดลอก Gis ${insxModel2.pea_no}');
                    print(insxModel2.pea_no);
                  },
                ),
              ],
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
                'สายจดหน่วย:',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.write_id}',
              style: TextStyle(fontSize: 12),
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
                style: TextStyle(fontSize: 12),
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

  Widget groupImage() => ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      onPressed: () {
        checkDistanceDiaiog(distanceDou);
        //confirmDialog();
      },
      icon: Icon(
        Icons.lock_open,
        color: Colors.white,
      ),
      label: Text(
        'บันทึกข้อมูล',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ));

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คุณแน่ใจหรือว่า จะส่งมอบงาน',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ไม่แน่ใจ',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      editDataInsx(insxModel2);
                    },
                    child: Text(
                      'แน่ใจ',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> chooseCamera(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        file = File(object.path);
        uploadImage();
      });
    } catch (e) {}
  }

  Future<Null> uploadImage() async {
    String apiSaveFile = '${MyConstant().domain}/apipsinsx/saveFile.php';
    String fileName = 'insx${Random().nextInt(1000000)}${insxModel2.ca}.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: fileName);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveFile, data: data).then((value) {
        urlImage = '${MyConstant().domain}/apipsinsx/upload/$fileName';
        print('=== usrlImage == $urlImage');
        editDataInsx(insxModel2);
      });
    } catch (e) {}
  }

  Future<Null> editDataInsx(InsxModel2 insxModel2) async {
    await SQLiteHelper()
        .editValueWhereId(int.parse(insxModel2.id))
        .then((value) {
      print('####>>>>>> ${insxModel2.id}');
      Fluttertoast.showToast(msg: 'บันทึกแล้ว');
      Navigator.pop(context);
    });
  }
}
