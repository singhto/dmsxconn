import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/sub_model.dart';
import 'package:psinsx/pages/add_outlay.dart';
import 'package:psinsx/utility/normal_dialog.dart';

class SeachOutlay extends StatefulWidget {
  @override
  _SeachOutlayState createState() => _SeachOutlayState();
}

class _SeachOutlayState extends State<SeachOutlay> {
  List<SubModel> subModels = [];
  List<SubModel> filterSubModels = List();

  String search;
  String nodata = 'กรุณากรอกเลขภาษี';

  @override
  void initState() {
    super.initState();
  }

  Future<Null> readAllData() async {
    if (subModels.length != 0) {
      subModels.clear();
    }
    String url =
        'https://www.pea23.com/apipsinsx/getAllDataLocationWhereTexid.php?isAdd=true&supplier_taxid=$search';

    var response = await Dio().get(url);

    print('response ===>>> $response');

    if (response.toString() == 'null') {
      setState(() {
        nodata = 'ไม่พบข้อมูลเลขภาษี: $search';
      });
    } else {
      var result = json.decode(response.data);
      print('result ====>>> $result');
      for (var map in result) {
        SubModel subModel = SubModel.fromJson(map);
        print('name ====>>> ${subModel.supplierTaxid}');
        setState(() {
          subModels.add(subModel);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            toolbarHeight: 100,
            title: Text('ค้นหา'),
          ),
        ),
        body: Column(
          children: [
            searchText(),
            subModels.length == 0
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
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'กรอกเลขภาษี'),
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
          itemCount: subModels.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                print('click  ${subModels[index].supplierId}');
                MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (context) => AddOutLay(subModel: subModels[index],),
                );
                Navigator.push(context, materialPageRoute);
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.money),
                  title: Text(
                    '${subModels[index].supplierTaxid} สาขา ${subModels[index].branch}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    '${subModels[index].supplierName} \n${subModels[index].supplierAddress}',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
