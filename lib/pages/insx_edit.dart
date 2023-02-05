import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:psinsx/utility/normal_dialog.dart';

class InsxEdit extends StatefulWidget {
  final InsxModel2 insxModel2;
  final bool fromMap;
  InsxEdit({Key key, this.insxModel2, this.fromMap}) : super(key: key);

  @override
  _InsxEditState createState() => _InsxEditState();
}

class _InsxEditState extends State<InsxEdit> {
  InsxModel2 insxModel2;
  File file;
  String urlImage;
  Location location = Location();
  double lat, lng;
  bool fromMap;
  String distanceStr;
  bool statusContinue = false; //ไม่สามารถไปต่อได้
  double distanceDou;
  String work_image = '';

  @override
  void initState() {
    super.initState();
    insxModel2 = widget.insxModel2;
    fromMap = widget.fromMap;
    findLatLng();
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
            file == null
                ? SizedBox(height: 80)
                : SizedBox(
                    height: 200,
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Stack(
                        children: [
                          Image.file(
                            file,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                processTakePhoto();
                              },
                              icon: Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            groupImage(),
          ],
        ),
      ),
    );
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

    double distanceDou =
        MyProcess().calculateDistance(lat, lng, lat2Dou, lng2Dou) * 1000;

    NumberFormat numberFormat = NumberFormat('#0.00', 'en_US');
    distanceStr = numberFormat.format(distanceDou);
  }

  void checkDistance(double distanceDou) {
    if (distanceDou > 200) {
      CustomDialog().actionDialog(
          context: context,
          title: 'เกินระยะ',
          subTitle: 'ระยะห่างเกิน $distanceStr เมตร',
          label: 'ลุยต่อ',
          pressFunc: () {
            Navigator.pop(context);
          },
          label2: 'กลับ',
          pressFucn2: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
    }
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

  Future<void> chooseImageForFindName() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'heic'],
    );

    File file = File(result.files.single.path);

    var strings = file.path.split('/');
    String nameImage = strings.last;

    //##################
    // หลอก
    //##################
    //nameImage = 'INSx020006650925_04062565_131036.png';

    nameImage = nameImage.substring(4, 16);

    String trueName = insxModel2.ca.substring(0, 12);

    print('##4june ชื่อภาพจากเครื่อง $nameImage');
    print('##4june ชื่อภาพ ca $trueName');

    if (nameImage == trueName) {
      confirmDialog();
    } else {
      normalDialog(context, 'รูปภาพไม่ถูกต้องครับ');
    }
  }

  Future<void> processTakePhoto() async {
    var result = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    file = File(result.path);
    statusContinue = true;
    setState(() {});
  }

  Widget groupImage() => ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      onPressed: () {
        if (double.parse(distanceStr) > 150) {
          //ถ่ายรูป
          if (!statusContinue) {
            CustomDialog().actionDialog(
                context: context,
                title: 'เนื่องจากระยะเกิน 150 เมตร',
                subTitle: 'กรุณาตรวจสอบความถูกต้องก่อนยืนยัน',
                label: 'ยกเลิก',
                pressFunc: () {
                  Navigator.pop(context);
                  // processTakePhoto();
                },
                label2: 'ยืนยัน',
                pressFucn2: () {
                  Navigator.pop(context);
                  statusContinue = true;
                  processChackHaveImage();
                });
          } else {
            confirmDialog();
          }
        } else {
          confirmDialog();
        }
        // chooseImageForFindName();

        // confirmDialog();
      },
      icon: Icon(
        Icons.save,
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
                      processChackHaveImage();
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

  Future<Null> editDataInsx(InsxModel2 insxModel2) async {
    CustomDialog().loadingDialog(context);

    Map<String, dynamic> map = insxModel2.toMap();

    map['invoice_status'] = MyConstant.valueInvoiceStatus;

    InsxModel2 newInsxModel2 = InsxModel2.fromMap(map);

    await MyProcess()
        .editDataInsx2(
            insxModel2: insxModel2,
            distance: distanceStr,
            work_image: work_image)
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  Future<void> processChackHaveImage() async {
    if (file == null) {
      editDataInsx(insxModel2);
    } else {
      String nameImage = 'image${insxModel2.id}.jpg';

      print('##8jun nameImage = $nameImage');

      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);
      await Dio()
          .post(MyConstant.apiUploadToWorkImage, data: formData)
          .then((value) {
        work_image = '${MyConstant.domainUploadinsx}$nameImage';
        print('##8jun Image === $work_image');
        editDataInsx(insxModel2);
      });
    }
  }
}
