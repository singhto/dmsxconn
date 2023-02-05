import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/perpay_model.dart';
import 'package:psinsx/pages/creatPerPay.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerPay extends StatefulWidget {
  @override
  _PerPayState createState() => _PerPayState();
}

class _PerPayState extends State<PerPay> {
  List<PerPayModel> perPayModels = [];
  bool loadStatus = true; //โหลด
  bool status = true; //มีข้อมูล

  @override
  void initState() {
    super.initState();
    readPerPay();
  }

  void setToOrigin() {
    loadStatus = true;
    status = true;
    perPayModels.clear();
  }

  Future<Null> readPerPay() async {
    if (perPayModels.length != 0) {
      setToOrigin();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('id');
    print('userId= $userId');

    String url =
        'https://www.pea23.com/apipsinsx/getDataPerPay.php?isAdd=true&ref_user_id=$userId';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        print('result ==>> $result');

        for (var map in result) {
          PerPayModel perPayModel = PerPayModel.fromJson(map);
          setState(() {
            perPayModels.add(perPayModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Widget showPerPay() {
    return status
        ? showListPerPay()
        : Center(
            child: Text('ไม่มีข้อมูล'),
          );
  }

  Widget showListPerPay() => ListView.builder(
      itemCount: perPayModels.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.money),
            title: Text(
              perPayModels[index].prepayType,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สถานะ ${perPayModels[index].prepayStatus}',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${perPayModels[index].prepayDate}',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '${perPayModels[index].prepayAmount} ฿',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });

  void createPerPay() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => CreatPerPay(),
    );
    Navigator.push(context, materialPageRoute).then((value) => readPerPay());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการเบิกล่วงหน้า'),
      ),
      body: Center(
        child: loadStatus ? MyStyle().showProgress() : showPerPay(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          createPerPay();
        },
      ),
    );
  }
}
