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

class WorkTime extends StatefulWidget {
  const WorkTime({Key key}) : super(key: key);

  @override
  _WorkTimeState createState() => _WorkTimeState();
}

class _WorkTimeState extends State<WorkTime> {
  final formKey = GlobalKey<FormState>();
  var startWork;
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
        title: Center(child: Text('ลงชื่อเข้างาน')),
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
                newStartWorkForm(),
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
          child: file == null
              ? IconButton(
                  onPressed: () => processTakePhoto(),
                  icon: Icon(Icons.add_a_photo,size: 180,),
                )
              : Image.file(file, fit: BoxFit.cover),
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

  ShowForm newStartWorkForm() {
    return ShowForm(
      label: 'เลขไมค์รถ',
      iconData: Icons.car_rental,
      textInputType: TextInputType.number,
      funcValidate: startWorkValidate,
      funcSave: startWorkSave,
    );
  }

  void startWorkSave(String string) {
    startWork = string.trim();
  }

  String startWorkValidate(String string) {
    if (string.isEmpty) {
      return 'กรุณาออกให้ครบ';
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
              // print(
              //     '@@@ date_work ==> $datWork, startWork ==> $startWork, startImage ==>> $nameFile, creatby ==> $createby');
              // print('@@ lat = $lat, lng == $lng');

              String pathInsert =
                  'https://www.pea23.com/apipsinsx/addWorkTime.php?isAdd=true&dat_work=$datWork&start_work=$startWork&start_work_image=$nameFile&create_by=$createby&start_work_lat=$lat&start_work_lng=$lng';
              await Dio().get(pathInsert).then((value) {
                if (value.toString() == 'true') {
                  // print('@@ Success Insert');

                  Fluttertoast.showToast(
                      msg: 'ลงเวลาเข้างานสำเร็จ', toastLength: Toast.LENGTH_LONG);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/homePage', (route) => false);
                } else {
                  normalDialog(context, 'Error กรุณาลองใหม่ครับ');
                }
              });
            });
          }
        }
      },
      child: Text(
        'ลงเวลาเข้างาน',
        style: MyConstant().h2Style(),
      ),
    );
  }
}
