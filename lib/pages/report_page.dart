import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/insx_model.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/pages/insx_show_data_success.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool loadStatus = true; //โหลด
  bool status = true; //มีข้อมูล
  List<InsxModel> insxModels = List();
  List<InsxModel2> insxModel2s = [];
  List<Color> colorIcons = List();
  List<File> files = List();
  String urlImage;

  @override
  void initState() {
    super.initState();
    readInsx();
  }

  void setToOrigin() {
    loadStatus = true;
    status = true;
    insxModels.clear();
    insxModel2s.clear();
    colorIcons.clear();
    files.clear();
  }

  Future<Null> readInsx() async {
    if (insxModel2s.length != 0) {
      setToOrigin();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');

    String url =
        'https://www.pea23.com/apipsinsx/getInsxWhereUserSuccess.php?isAdd=true&worker_name=$workername';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          InsxModel2 insxModel2 = InsxModel2.fromMap(map);
          setState(() {
            insxModel2s.add(insxModel2);
            colorIcons.add(calculageHues(insxModel2.noti_date));
            files.add(null);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          loadStatus ? Center(child: MyStyle().showProgress()) : showContent(),
    );
  }

  Widget showContent() {
    return status
        ? showListInsx()
        : Container(
            child: Center(
              child: Text(
                'ไม่มีข้อมูลอัพโหลดเสร็จ',
                style: TextTheme().bodyText1,
              ),
            ),
          );
  }

  Color calculageHues(String notidate) {
    List<Color> colors = [Colors.green, Colors.yellow, Colors.blue, Colors.red];
    List<String> strings = notidate.split(" ");
    List<String> dateTimeInts = strings[0].split('-');
    DateTime notiDateTime = DateTime(
      int.parse(dateTimeInts[0]),
      int.parse(dateTimeInts[1]),
      int.parse(dateTimeInts[2]),
    );

    DateTime currentDateTime = DateTime.now();
    int diferDate = currentDateTime.difference(notiDateTime).inDays;
    Color result = colors[0];

    if (diferDate >= 7) {
      result = colors[3];
    } else if (diferDate >= 4) {
      result = colors[2];
    } else if (diferDate >= 2) {
      result = colors[1];
    }
    return result;
  }

  Widget showListInsx() => SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(
                  insxModel2s.length == 0
                      ? 'อัพโหลดสมบูรณ์ : ? รายการ'
                      : 'อัพโหลดสมบูรณ์ : ${insxModel2s.length} รายการ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: insxModel2s.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => InsxShowDataSuccess(
                      insxModel2: insxModel2s[index],
                    ),
                  );
                  Navigator.push(context, route);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.pin_drop,
                        size: 24,
                        color: colorIcons[index],
                      ),
                   
                      title: Text(
                        insxModel2s[index].cus_name,
                        style: TextStyle(
                          fontSize: 10,
                       
                        ),
                      ),
                      subtitle: Text(
                        ' สาย : ${insxModel2s[index].write_id} \n PAE : ${insxModel2s[index].pea_no} ',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
