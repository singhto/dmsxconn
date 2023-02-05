import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/get_date_model.dart';
import 'package:psinsx/models/insx_check_model.dart';
import 'package:psinsx/models/insx_model.dart';
import 'package:psinsx/pages/insx_showdata_check.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocPage extends StatefulWidget {
  DocPage({Key key}) : super(key: key);

  @override
  _DocPageState createState() => _DocPageState();
}

class _DocPageState extends State<DocPage> {
  bool loadStatus = true; //โหลด
  bool status = true; //มีข้อมูล
  List<InsxModel> insxModels = List();
  List<InsxCheckModel> insxCheckModels = [];
  List<GetDatModel> getDateModels = [];
  List<Color> colorIcons = List();
  List<File> files = List();
  String urlImage;
   TextEditingController ctrReportDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    readInsx();
  }

  void setToOrigin() {
    loadStatus = true;
    status = true;
    insxCheckModels.clear();
    getDateModels.clear();
    colorIcons.clear();
    files.clear();
  }


  Future<Null> readInsx() async {
    if (insxCheckModels.length != 0) {
      setToOrigin();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('id');
    String stafName = preferences.getString('staffname');
    //print('userId === $userId');
    //print('staffName === $stafName');

    String url =
        'https://www.pea23.com/apipsinsx/getDocWhereUserSuccess.php?isAdd=true&user_id=$userId';

    print('url ====>>> $url');
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          //print('map  ====>>> $map');
          InsxCheckModel insxCheckModel = InsxCheckModel.fromJson(map);

          setState(() {
            insxCheckModels.add(insxCheckModel);
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
          loadStatus ? Center(child: MyStyle().showProgress()) : showListInsx(),
    );
  }

  Widget showListInsx() => SingleChildScrollView(
        child: Column(
          children: [
            Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            child: Text('สรุปผลการตรวจสอบประจำวัน',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),

   Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: TextFormField(
            controller: ctrReportDate,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'ข้อมูล ณ วันที่',
                hintText: 'dd/mm/yyyy',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime selectedDate = await showDatePicker(
                        context: (context),
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 30)),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            child: child,
                            data: ThemeData.light().copyWith(
                                accentColor: Colors.red[600],
                                colorScheme: ColorScheme.light(
                                  primary: Colors.red,
                                ),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary)),
                          );
                        });

                
                  },
                )),
          ),
        ),
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: FlutterLogo(),
                    title: Text('One-line with both widgets'),
                    trailing: Icon(Icons.more_vert),
                  )),
            ),
          ],
        ),
      );
}
