import 'dart:convert';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/user_model.dart';
import 'package:psinsx/pages/add_information_user.dart';
import 'package:psinsx/utility/custom_clipper.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationUser extends StatefulWidget {
  InformationUser({Key key}) : super(key: key);

  @override
  _InformationUserState createState() => _InformationUserState();
}

class _InformationUserState extends State<InformationUser> {
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    readUserInfo();
  }

  Future<Null> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('id');
    String url =
        '${MyConstant().domain}/apipsinsx/getUserWhereId.php?isAdd=true&user_id=$userId';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      for (var map in result) {
        userModel = UserModel.fromJson(map);

        setState(() {
          if (userModel.userAdress.isEmpty) {}
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'บริษัท สดุดียี่สิบสาม จำกัด',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            userModel == null
                ? MyStyle().showProgress()
                : userModel.userAdress.isEmpty
                    ? showNoData()
                    : showDataUser(),
            editButton(),
          ],
        ),
      ),
    );
  }

  Widget showDataUser() => SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'ที่ตั้ง 83/1 หมู่ 5 ต.หนองไขว่ อ.หล่มสัก จ.เพชรบูรณ์ 67110',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'เลขภาษี 0675560000081',
              style: TextStyle(fontSize: 12),
            ),
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                height: 50,
                color: Colors.yellow[800],
              ),
            ),
            align(),
            SizedBox(height: 20),
            showUserName(),
            SizedBox(height: 20),
            showAdress(),
            SizedBox(height: 20),
            showPhone(),
            SizedBox(height: 20),
            showBank(),
            SizedBox(height: 20),
          ],
        ),
      );

  Widget showUserName() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: Colors.yellow[800],
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'รหัสพนังาน : PS${userModel.userId}',
                    style: TextStyle(fontSize: 12),
                  ),
                  userModel.userAdress.isEmpty
                      ? Text('User')
                      : Text(
                          'User : ${userModel.username}',
                          style: TextStyle(fontSize: 12),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showBank() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Row(
          children: [
            Icon(
              Icons.monetization_on_outlined,
              color: Colors.yellow[800],
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  userModel.userAdress.isEmpty
                      ? Text('บัญชีธนาคาร')
                      : Text(
                          '${userModel.userBankName}',
                          style: TextStyle(fontSize: 12),
                        ),
                  Text(
                    '${userModel.userBankNumber}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showPhone() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Row(
          children: [
            Icon(
              Icons.mobile_friendly_rounded,
              color: Colors.yellow[800],
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'เบอร์มือถือ',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '${userModel.userPhone}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showAdress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Icon(
              Icons.home_filled,
              color: Colors.yellow[800],
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${userModel.userAdress}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget align() {
    return Align(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProfileAvatar(
            '${userModel.userImg}',
            borderWidth: 4.0,
          ),
          Text('${userModel.staffname}'),
          Text(
            '${userModel.userEmail}',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget showNoData() => Center(
        child: Text('ข้อมูลไม่สมบูรณ์'),
      );

  Row editButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16, bottom: 16),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: FloatingActionButton(
                    child: Image.asset("assets/images/pea.png"),
                    onPressed: () {}),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 45, right: 16),
            //   child: FloatingActionButton(
            //       child: Icon(Icons.edit),
            //       onPressed: () {
            //         routeToAddInfo();
            //       }),
            // ),
          ],
        ),
      ],
    );
  }

  void routeToAddInfo() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddInformationUser(),
    );
    Navigator.push(context, materialPageRoute).then((value) => readUserInfo());
  }
}
