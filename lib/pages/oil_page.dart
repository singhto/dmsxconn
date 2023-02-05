import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/outlay_model.dart';
import 'package:psinsx/pages/seach_outlay.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class OilPage extends StatefulWidget {
  @override
  _OilPageState createState() => _OilPageState();
}

class _OilPageState extends State<OilPage> {
  bool loadStatus = true; //Process Load
  bool status = true;
  List<OutlayModel> outLayModels = List();

  @override
  void initState() {
    super.initState();
    readOutlay();
  }

  void setToOrigin() {
    loadStatus = true;
    status = true;
    outLayModels.clear();
  }

  Future<Null> readOutlay() async {
    if (outLayModels.length != 0) {
      setToOrigin();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id');
    //print('idUser == ==.>> $idUser');

    String url =
        '${MyConstant().domain}/apipsinsx/getOutlayWhereUser.php?isAdd=true&user_id=$idUser';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        //print('result ==>> $result');

        for (var map in result) {
          OutlayModel outlayModel = OutlayModel.fromJson(map);
          setState(() {
            outLayModels.add(outlayModel);
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
        toolbarHeight: 100,
        title: Text(
          'ใบเสร็จ ${outLayModels.length} รายการ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: loadStatus ? MyStyle().showProgress() : showOutlay(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          routeToSeachOutlay();
        },
      ),
    );
  }

  void routeToSeachOutlay() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => SeachOutlay(),
    );
    Navigator.push(context, materialPageRoute).then((value) => readOutlay());
  }

  Widget showOutlay() {
    return status
        ? showListOutlay()
        : Center(
            child: Text('ไม่มีข้อมูล'),
          );
  }

  Future<Null> deleteOutlay(OutlayModel outlayModel) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'คุณต้องการลบรายการ',
                style: TextStyle(fontSize: 14),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        String url =
                            'https://www.pea23.com/apipsinsx/deleteOutlayWhereId.php?isAdd=true&id=${outlayModel.id}';
                        await Dio().get(url).then((value) => readOutlay());
                        showToast('ลบรายการ สำเร็จ', gravity: Toast.center);
                      },
                      child: Text('ยืนยัน'),
                    ),
                    MaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('ไม่'),
                    ),
                  ],
                )
              ],
            ));
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  Widget showListOutlay() => ListView.builder(
      itemCount: outLayModels.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onLongPress: () => deleteOutlay(outLayModels[index]),
            leading: 
            // Text('${MyConstant.domainImage}${outLayModels[index].image}'),
            
            Image.network(
              outLayModels[index].image,
           
              fit: BoxFit.cover,
              width: 60,
              height: 80,
            ),
            title: Text(
              outLayModels[index].supplierName,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เลขที่ ${outLayModels[index].referenceNumber}',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${outLayModels[index].createdAt} ${outLayModels[index].outlayStatus}',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '${outLayModels[index].sum} ฿',
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
}
