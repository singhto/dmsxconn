import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/image_insx_model.dart';
import 'package:psinsx/models/insx_model.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeaReport extends StatefulWidget {
  PeaReport({Key key}) : super(key: key);

  @override
  _PeaReportState createState() => _PeaReportState();
}

class _PeaReportState extends State<PeaReport> {
  bool loadStatus = true; //โหลด
  bool status = true; //มีข้อมูล
  List<InsxModel> insxModels = List();
  List<ImageInsxModel> imageInsxModels = [];
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
    imageInsxModels.clear();
    colorIcons.clear();
    files.clear();
  }

  Future<Null> readInsx() async {
    if (imageInsxModels.length != 0) {
      setToOrigin();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('id');

    String url =
        'https://www.pea23.com/apipsinsx/getImageSuccess.php?isAdd=true&user_id=$userId';


        print('url $url');

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        print('result $result');
        for (var map in result) {
          ImageInsxModel imageInsxModel = ImageInsxModel.fromJson(map);
          setState(() {
            imageInsxModels.add(imageInsxModel);
          
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
                'ไม่มีข้อมูล',
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
                  imageInsxModels.length == 0
                      ? 'รูปภาพ : ? รายการ'
                      : 'รูปภาพ : ${imageInsxModels.length} รายการ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: imageInsxModels.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  // MaterialPageRoute route = MaterialPageRoute(
                  //   builder: (context) => InsxShowDataSuccess(
                  //     imageInsxModel: imageInsxModels[index],
                  //   ),
                  // );
                  // Navigator.push(context, route);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(imageInsxModels[index].imageInsx),
                   
                      title: Text(
                        imageInsxModels[index].cusName,
                        style: TextStyle(
                          fontSize: 10,
                       
                        ),
                      ),
                      subtitle: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CA : ${imageInsxModels[index].ca}',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text('เวลา. : ${imageInsxModels[index].imgDate}',
                            style: TextStyle(fontSize: 10),),
                        ],
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
