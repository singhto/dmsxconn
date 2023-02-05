import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psinsx/models/user_model.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInformationUser extends StatefulWidget {
  @override
  _AddInformationUserState createState() => _AddInformationUserState();
}

class _AddInformationUserState extends State<AddInformationUser> {
  UserModel userModel;
  File file;
  String userAddress,
      userEmail,
      userPhone,
      userBankName,
      userBankNumber,
      userImg;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/apipsinsx/getUserWhereId.php?isAdd=true&user_id=$id';
    Response response = await Dio().get(url);

    var result = json.decode(response.data);

    for (var map in result) {
      setState(() {
        userModel = UserModel.fromJson(map);
        userAddress = userModel.userAdress;
        userEmail = userModel.userEmail;
        userPhone = userModel.userPhone;
        userBankName = userModel.userBankName;
        userBankNumber = userModel.userBankNumber;
        userImg = userModel.userImg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContent(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100,
          title: Center(
            child: Text('แก้ไขข้อมูลส่วนตัว'),
          ),
        ),
      ),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            showImage(),
            eamilFrom(),
            addressFrom(),
            phoneFrom(),
            nameBankFrom(),
            numberBankFrom(),
            SizedBox(height: 20),
            editButton(),
            SizedBox(height: 60),
          ],
        ),
      );

  Widget numberBankFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            width: 300,
            child: TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) => userBankNumber = value,
              initialValue: userBankNumber,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'เลขบัญชี'),
            ),
          ),
        ],
      );

  Widget nameBankFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            width: 300,
            child: TextFormField(
              onChanged: (value) => userBankName = value,
              initialValue: userBankName,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ธนาคาร'),
            ),
          ),
        ],
      );

  Widget editButton() {
    return Container(
      width: 300,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () => confirmDialog(),
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          ' อัพเดทข้อมูล',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ยืนยันการอัพเดทข้อมูล?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        children: [
          Column(
            children: [
              Icon(
                Icons.person_pin,
                size: 60,
                color: Colors.red[200],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ไม่',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('click...');
                      Navigator.pop(context);
                      editThread();
                    },
                    child: Text(
                      'ใช่',
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

  Future<Null> editThread() async {
    if (file != null) {
      Random random = Random();
      int i = random.nextInt(100000);
      String nameFile = 'staff$i.jpg';
      
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);
      
      String urlUpload = '${MyConstant().domain}/apipsinsx/saveFile.php';
      await Dio().post(urlUpload, data: formData).then((value) async {
        userImg = '${MyConstant().domain}/apipsinsx/upload/$nameFile';
      
        await processEditDatabase();
      });
    }else{
      await processEditDatabase();
    }
  }

  Future processEditDatabase() async {
    String id = userModel.userId;
    
    String url =
        'https://www.pea23.com/apipsinsx/editUserWhereId.php?isAdd=true&user_id=$id&user_email=$userEmail &user_phone=$userPhone&user_adress=$userAddress&user_bank_name=$userBankName&user_bank_number=$userBankNumber&user_img=$userImg';
    
    Response response = await Dio().get(url);
    
    if (response.toString() == 'true') {

      await readCurrentInfo().then((value) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('id', userModel.userId);
      preferences.setString('staffname', userModel.staffname);
      preferences.setString('user_email', userModel.userEmail);
      preferences.setString('user_img', userModel.userImg);
    
      Navigator.pop(context);
      });


    } else {
      normalDialog(context, 'อัพเดทไม่ได้ กรุณาลองใหม่');
    }
  }

  Widget showImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.camera_alt,
            color: Colors.grey,
          ),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          width: 100,
          height: 100,
          child: file == null
              ? CircularProfileAvatar(
                  '${userModel.userImg}',
                  borderWidth: 4.0,
                )
              : Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
        ),
        IconButton(
          icon: Icon(
            Icons.photo_album_rounded,
            color: Colors.grey,
          ),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget phoneFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            width: 300,
            child: TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) => userPhone = value,
              initialValue: userPhone,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'เบอร์มือถือ'),
            ),
          ),
        ],
      );

  Widget eamilFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            width: 300,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => userEmail = value,
              initialValue: userEmail,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
            ),
          ),
        ],
      );

  Widget addressFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            width: 300,
            child: TextFormField(
              onChanged: (value) => userAddress = value,
              initialValue: userAddress,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่'),
            ),
          ),
        ],
      );
}
