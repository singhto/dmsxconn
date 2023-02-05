import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/dmsx_model.dart';
import 'package:psinsx/models/insx_model.dart';
import 'package:psinsx/pages/map_dmsx.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DmsxPage extends StatefulWidget {
  DmsxPage({Key key}) : super(key: key);

  @override
  _DmsxPageState createState() => _DmsxPageState();
}

class _DmsxPageState extends State<DmsxPage> {
  bool loadStatus = true; //โหลด
  bool status = true; //มีข้อมูล
  List<InsxModel> insxModels = List();
  List<Dmsxmodel> dmsxModels = List();
  //List<Color> colorIcons = List();

  @override
  void initState() {
    super.initState();
    readInsx();
  }

  Future<Null> readInsx() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');
    print('workername === $workername');
    String userId = preferences.getString('id');
    print('id ===== $userId');

    String url =
        'https://www.pea23.com/apipsinsx/getDmsxWherUser.php?isAdd=true&user_id=$userId';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        print('value ====>>> $value');

        var result = json.decode(value.data);

        print('result ===>>> $result');

        for (var map in result) {
          Dmsxmodel dmsxModel = Dmsxmodel.fromJson(map);
          setState(() {
            dmsxModels.add(dmsxModel);
            print('map ====== $map');
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
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
              
              },
              icon: Icon(Icons.map_outlined)),
          SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Colors.purple,
        title: Text(
          'ข้อมูลงดจ่ายไฟ ${dmsxModels.length} รายการ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          loadStatus ? MyStyle().showProgress() : showContent(),
        ],
      ),
       floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         
        },
        label: const Text('แผนที่'),
        icon: const Icon(Icons.map_outlined),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Widget showContent() {
    return status
        ? showListDmsx()
        : Center(
            child: Text('ไม่มีข้อมูล'),
          );
  }

  Widget showListDmsx() => SingleChildScrollView(
        child: Column(
          children: [
            //searchText(),

            ListView.builder(
              itemCount: dmsxModels.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, int index) => GestureDetector(
                onTap: () {
                  // MaterialPageRoute route = MaterialPageRoute(
                  //   builder: (context) => InsxEdit2(
                  //     insxModel2: filterInsxModel2s[index],
                  //   ),
                  // );
                  // Navigator.push(context, route).then(
                  //   (value) => readInsx(),
                  // );
                },

                //=> confirmDialog(insxModel2s[index], colorIcons[index], index),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.pin_drop,
                        size: 26,
                        //color: colorIcons[index],
                      ),
                      title: Text(
                        dmsxModels[index].cusName,
                        style: TextStyle(
                          fontSize: 12,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'ca: ${dmsxModels[index].ca} PEA: ${dmsxModels[index].peaNo} \nสาย : ${dmsxModels[index].line}',
                        style: TextStyle(fontSize: 12),
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
