import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/dmsx_model.dart';
import 'package:psinsx/pages/show_map_from_search.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_dialog.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:psinsx/widgets/show_button.dart';
import 'package:psinsx/widgets/show_form.dart';
import 'package:psinsx/widgets/show_text.dart';

class SearchDmsx extends StatefulWidget {
  const SearchDmsx({Key key}) : super(key: key);

  @override
  State<SearchDmsx> createState() => _SearchDmsxState();
}

class _SearchDmsxState extends State<SearchDmsx> {
  final formStateKey = GlobalKey<FormState>();
  String search;
  var dmsxModels = <Dmsxmodel>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหาพิกัดงดจ่ายไฟ'),
      ),
      body: Form(
        key: formStateKey,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                formSearch(),
                buttonSearch(),
                dmsxModels.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: dmsxModels.length,
                        itemBuilder: (context, index) =>
                            newResultSearch(dmsxmodel: dmsxModels[index]),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newResultSearch({@required Dmsxmodel dmsxmodel}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 168, 165, 165)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          newTitle(head: 'วันที่สถานะ', value: dmsxmodel.dataStatus),
          newTitle(head: 'ชื่อ ผชฟ :', value: dmsxmodel.cusName),
          newTitle(head: 'ที่อยู่ :', value: dmsxmodel.address),
          ShowButton(
              pressFunc: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShowMapFromSearch(dmsxmodel: dmsxmodel),
                    ));
              },
              label: 'แสดงแผนที่')
        ],
      ),
    );
  }

  Row newTitle({@required String head, @required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: ShowText(text: head)),
        Expanded(child: ShowText(text: value)),
      ],
    );
  }

  Widget buttonSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (formStateKey.currentState.validate()) {
              formStateKey.currentState.save();
              print('##6jun search === $search');

              processReadSearch();
            }
          },
          child: Text('ค้นหา'),
        ),
      ],
    );
  }

  Widget formSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowForm(
            textInputType: TextInputType.number,
            label: 'ค้นหา ca',
            iconData: Icons.search,
            funcValidate: (String string) {
              if (string?.isEmpty ?? true) {
                return 'กรอกข้อมูลก่อนครับ';
              } else {
                return null;
              }
            },
            funcSave: (String string) {
              search = string.trim();
            }),
      ],
    );
  }

  Future<void> processReadSearch() async {
    MyDialog(context: context).processDialog();

    if (dmsxModels.isNotEmpty) {
      dmsxModels.clear();
    }

    String path =
        'https://www.pea23.com/apipsinsx/getDmsxLocationWhereCa.php?isAdd=true&ca=$search';
    await Dio().get(path).then((value) {
      Navigator.pop(context);
      if (value.toString() == 'null') {
        normalDialog(context, 'ไม่พบข้อมูล');
      } else {
        for (var element in json.decode(value.data)) {
          // print('##6jun element === $element');
          Dmsxmodel dmsxmodel = Dmsxmodel.fromMap(element);
          dmsxModels.add(dmsxmodel);
        }
      }

      setState(() {});
    });
  }
}
