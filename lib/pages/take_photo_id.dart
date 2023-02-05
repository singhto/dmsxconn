import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psinsx/widgets/show_button.dart';
import 'package:psinsx/widgets/widget_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakePhotoId extends StatefulWidget {
  const TakePhotoId({Key key}) : super(key: key);

  @override
  State<TakePhotoId> createState() => _TakePhotoIdState();
}

class _TakePhotoIdState extends State<TakePhotoId> {
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลบัตร'),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return Center(
          child: Column(
            children: [
              SizedBox(height: 20),

               Text('กรุณาบันทึกภาพถ่ายบัตรประชาชน',
                  style: TextStyle(fontSize: 14)),
              
              Text('คำแนะนำ : ให้ถ่ายภาพให้อยู่ในกรอบที่กำหนด',
                  style: TextStyle(fontSize: 14)),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.yellow)),
                margin: const EdgeInsets.symmetric(vertical: 32),
                width: boxConstraints.maxWidth * 0.8,
                height: boxConstraints.maxWidth * 0.6,
                child: file == null
                    ? WidgetImage(path: 'assets/images/card.png')
                    : Image.file(
                        file,
                        fit: BoxFit.cover,
                      ),
              ),
              Row(
                mainAxisAlignment: file == null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceEvenly,
                children: [
                  ShowButton(
                    pressFunc: () {
                      processTakePhoto();
                    },
                    label: file == null ? 'ถ่ายภาพ' : 'ถ่ายใหม่',
                    colorLabel: file == null ? Colors.blue : Colors.red,
                  ),
                  file == null
                      ? const SizedBox()
                      : ShowButton(
                          pressFunc: () {
                            processUploadAndEdit();
                          },
                          label: 'บันทึก'),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  Future<void> processTakePhoto() async {
    var result = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (result != null) {
      file = File(result.path);
      setState(() {});
    }
  }

  Future<void> processUploadAndEdit() async {
    String urlUpload = 'https://pea23.com/apipsinsx/saveImageIdCard.php';

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String nameIdCard = preferences.getString('id');
    String id = nameIdCard;

    nameIdCard = '$nameIdCard${Random().nextInt(1000000)}.jpg';
    Map<String, dynamic> map = {};
    map['file'] = await MultipartFile.fromFile(file.path, filename: nameIdCard);
    FormData data = FormData.fromMap(map);
    await Dio().post(urlUpload, data: data).then((value) async {
      String urlIdCard = 'https://pea23.com/apipsinsx/imageIdCard/$nameIdCard';
      print('##26oct url Idcare $urlIdCard');

      String urlEdit =
          'https://pea23.com/apipsinsx/editStaffSurnameWhereId.php?isAdd=true&user_id=$id&staffsurname=$urlIdCard';

      await Dio().get(urlEdit).then((value) {
        Fluttertoast.showToast(
            msg: 'อัพโหลดสำเร็จ', toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
      });
    });
  }
}
