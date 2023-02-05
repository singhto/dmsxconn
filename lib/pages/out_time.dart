import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:psinsx/widgets/logo.dart';
import 'package:psinsx/widgets/show_form.dart';
import 'package:psinsx/widgets/show_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutTime extends StatefulWidget {
  const OutTime({Key key}) : super(key: key);

  @override
  _OutTimeState createState() => _OutTimeState();
}

class _OutTimeState extends State<OutTime> {
  final formKey = GlobalKey<FormState>();
  var outWork;
  File file;
  var showDate;
  var nameFile;
  var createby;
  var datWork;

  double lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentTime();
    findLatLng();
  }

  Future<void> findLatLng() async {
    Position position = await findPosition();
    lat = position.latitude;
    lng = position.longitude;
  }

  Future<Position> findPosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  Future<void> findCurrentTime() async {
    DateTime dateTime = DateTime.now();
    DateFormat datworkFormat = DateFormat('yyyy-MM-dd');
    DateFormat showDateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
    DateFormat nameFileFormat = DateFormat('yyMMdd_HHmmss');

    showDate = showDateFormat.format(dateTime);
    datWork = datworkFormat.format(dateTime);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    createby = preferences.getString('id');

    nameFile = nameFileFormat.format(dateTime);
    nameFile = createby + '_' + '$nameFile.jpg';
    print('nameFile $nameFile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('ลงเวลาเลิกงาน')),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusScopeNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShowText(
                        text: 'วันที่:',
                        textStyle: MyConstant().h2Style(),
                      ),
                      ShowText(text: showDate),
                    ],
                  ),
                ),
                newOutWorkForm(),
                newImage(),
                newCheckTime(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processTakePhoto() async {
    try {
      var result = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Stack newImage() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: 200,
          height: 200,
          child: file == null ? IconButton(
            onPressed: () => processTakePhoto(),
            icon: Icon(Icons.add_a_photo, size: 180,),
          ) : Image.file(file, fit: BoxFit.cover),
        ),
        // Positioned(
        //   right: 0,
        //   bottom: 0,
        //   child: IconButton(
        //     onPressed: () => processTakePhoto(),
        //     icon: Icon(Icons.add_a_photo),
        //   ),
        // ),
      ],
    );
  }

  ShowForm newOutWorkForm() {
    return ShowForm(
      label: 'เลขไมค์รถ',
      iconData: Icons.car_rental,
      textInputType: TextInputType.number,
      funcValidate: outWorkValidate,
      funcSave: outWorkSave,
    );
  }

  void outWorkSave(String string) {
    outWork = string.trim();
  }

  String outWorkValidate(String string) {
    if (string.isEmpty) {
      return 'กรุณากรอกให้ครบ';
    } else {
      return null;
    }
  }

  ElevatedButton newCheckTime() {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          //print('@@ startWork ==  $startWork');

          if (file == null) {
            normalDialog(context, 'กรุณาใส่รูปภาพด้วย');
          } else {
            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(file.path, filename: nameFile);
            FormData formData = FormData.fromMap(map);

            var path = 'https://www.pea23.com/saveImage.php';
            await Dio().post(path, data: formData).then((value) async {
              //inseart value to DB
              print(
                  '@@@ date_work ==> $datWork, outWork ==> $outWork, startImage ==>> $nameFile, creatby ==> $createby');
              print('@@ lat = $lat, lng == $lng');

              String pathEdit =
                  'https://www.pea23.com/apipsinsx/editWorkTimeWhereDatWork.php?isAdd=true&dat_work=$datWork&out_work=$outWork&out_work_image=$nameFile&out_work_lat=$lat&out_work_lng=$lng&create_by=$createby';

              await Dio().get(pathEdit).then((value) {
                if (value.toString() == 'true') {
                  Fluttertoast.showToast(
                      msg: 'เลิกงานสำเร็จ', toastLength: Toast.LENGTH_LONG);
                  exit(0);
                } else {
                  normalDialog(context, 'Have Error');
                }
              });
            });
          }
        }
      },
      child: Text(
        'บันทึกเวลาเลิกงาน',
        style: MyConstant().h2Style(),
      ),
    );
  }
}
