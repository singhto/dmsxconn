import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/data_location_model.dart';
import 'package:psinsx/utility/my_dialog.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:psinsx/widgets/widget_icon_button.dart';
import 'package:psinsx/widgets/widget_text_rich.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<DataLocationModel> dataLocationModels = [];
  List<DataLocationModel> filterDataLocationModels = [];

  String? search;
  String nodata = 'กรุณากรอก ca ที่ต้องการค้นหา';

  @override
  void initState() {
    super.initState();
  }

  Future<Null> readAllData() async {
    if (dataLocationModels.length != 0) {
      dataLocationModels.clear();
    }
    String url =
        'https://www.dissrecs.com/apipsinsx/getAllDataLocationWhereCa.php?isAdd=true&ca=$search';

    // ProgressDialog pr = ProgressDialog(context, isDismissible: false);
    // pr.style(
    //     message: 'Loading...',
    //     progressWidget: Container(
    //       margin: EdgeInsets.all(10),
    //       child: CircularProgressIndicator(),
    //     ));

    try {
      // await pr.show();

      var response = await Dio().get(url);

      // await pr.hide();
      if (response.toString() == 'null') {
        setState(() {
          // pr.hide();
          nodata = 'ไม่พบ CA: $search';
        });
      } else {
        var result = json.decode(response.data);
        for (var map in result) {
          DataLocationModel dataLocationModel = DataLocationModel.fromJson(map);
          setState(() {
            dataLocationModels.add(dataLocationModel);
          });
        }
      }
    } catch (e) {}
  }

  Future<Null> launchURL() async {
    var url = 'https://www.google.co.th/maps';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        searchText(),
        dataLocationModels.length == 0
            ? Center(
                child: Text(
                nodata,
                style: TextStyle(
                  fontSize: 14,
                ),
              ))
            : showListView(),
      ],
    ));
  }

  Widget searchText() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'กรอก ca'),
              onChanged: (value) => search = value.trim(),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.search,
                size: 40,
              ),
              onPressed: () {
                if (search?.isEmpty ?? true) {
                  if (dataLocationModels.length != 0) {
                    dataLocationModels.clear();
                    setState(() {});
                  }
                  normalDialog(context, 'ห้ามมีช่องว่าง');
                } else {
                  readAllData();
                }
              }),
        ],
      ),
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
          itemCount: dataLocationModels.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                print('datalocation == ${dataLocationModels[index].toJson()}');
                MyDialog(context: context).normalDialot(
                  title: 'รายละเอียด',
                  subTitle: 'รายละเอียดรูปภาพสถานที่ใช้ไฟฟ้า',
                  contentWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        dataLocationModels[index].imageInsx!,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      WidgetTextRich(
                        head: 'Ca',
                        value: dataLocationModels[index].ca!,
                      ),
                      WidgetTextRich(
                        head: 'CusName',
                        value: dataLocationModels[index].cusName!,
                      ),
                    ],
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: () async => {
                      await launch('tel:${dataLocationModels[index].cusTel}'),
                      print('${dataLocationModels[index].cusTel}')
                    },
                  ),
                  leading: WidgetIconButton(
                    iconData: Icons.location_on_outlined,
                    pressFunc: () async {
                      String url = dataLocationModels[index].ptcInsx!;

                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'ไม่พบ $url';
                      }
                    },
                  ),
                  title: Text(dataLocationModels[index].ca!),
                  subtitle: Text(
                    '${dataLocationModels[index].cusName} \n ${dataLocationModels[index].imgDate}',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
