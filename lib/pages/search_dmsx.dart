import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

import 'package:psinsx/models/dmsx_model.dart';
import 'package:psinsx/models/search_dmsx_model.dart';
import 'package:psinsx/pages/show_map_from_search.dart';
import 'package:psinsx/utility/my_dialog.dart';
import 'package:psinsx/widgets/show_button.dart';
import 'package:psinsx/widgets/show_form.dart';
import 'package:psinsx/widgets/show_text.dart';
import 'package:psinsx/widgets/widget_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchDmsx extends StatefulWidget {
  const SearchDmsx({
    Key? key,
    this.displayBackIcon,
  }) : super(key: key);

  final bool? displayBackIcon;

  @override
  State<SearchDmsx> createState() => _SearchDmsxState();
}

class _SearchDmsxState extends State<SearchDmsx> {
  final formStateKey = GlobalKey<FormState>();
  String? search;
  // var dmsxModels = <Dmsxmodel>[];

  var searchDmsxModels = <SearchDmsxModel>[];

  bool displayBackIcon = true;

  @override
  void initState() {
    super.initState();
    if (widget.displayBackIcon != null) {
      displayBackIcon = widget.displayBackIcon!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formStateKey,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: Center(
            child: ListView(
              children: [
                displayBackIcon
                    ? ListTile(
                        leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back)),
                        title: Text('ค้นหาพิกัด'),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 20,
                ),

                formSearch(),

                buttonSearch(),

                // Text('display Result Search'),

                searchDmsxModels.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: searchDmsxModels.length,
                        itemBuilder: (context, index) =>
                            newResultSearch(searchDmsxModel: searchDmsxModels[index]),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newResultSearch({required SearchDmsxModel searchDmsxModel}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 168, 165, 165)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          newTitle(head: 'วันที่สถานะ', value: searchDmsxModel.timestamp),
          newTitle(head: 'ชื่อ ผชฟ :', value: searchDmsxModel.cus_name),
          newTitle(head: 'สถานะ :', value: searchDmsxModel.status_txt),

          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShowButton(
                  pressFunc: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShowMapFromSearch(searchDmsxModel: searchDmsxModel),
                        ));
                  },
                  label: 'แสดงแผนที่ PEA'),
                  
              (((searchDmsxModel.latMobile == '0') || (searchDmsxModel.lngMobile == '0')) || ((searchDmsxModel.latMobile.isEmpty) || (searchDmsxModel.lngMobile.isEmpty))) ? SizedBox() : ShowButton(
                  pressFunc: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShowMapFromSearch(searchDmsxModel: searchDmsxModel, showMobile: true),
                        ));
                  },
                  label: 'แผนที่ มือถือ'),


            ],
          ),








        ],
      ),
    );
  }

  Row newTitle({required String head, required String value}) {
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
            if (formStateKey.currentState!.validate()) {
              formStateKey.currentState!.save();
              print('##6jun search === $search');

              searchDmsxModels.clear();

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
            funcValidate: (String? string) {
              if (string?.isEmpty ?? true) {
                return 'กรอกข้อมูลก่อนครับ';
              } else {
                return null;
              }
            },
            funcSave: (String? string) {
              search = string!.trim();
            }),
      ],
    );
  }

  Future<void> processReadSearch() async {
    // MyDialog(context: context).processDialog();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = await preferences.getString('token') ?? '';

    dio.Dio objDio = dio.Dio();
    objDio.options.headers['Content-Type'] = 'application/json';
    objDio.options.headers['apikey'] = token;

    String path =
        'https://www.dissrecs.com/api/tb_work_import_dmsx_data_ca.php?ca=$search';

    var resultSearch = await objDio.get(path);

    debugPrint('##14Oct resultSerch == $resultSearch');

    var data = resultSearch.data['data'];

    if (data.isEmpty) {
      // ไม่มี ca

      setState(() {
        
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ไม่พบ ca $search')));
    } else {
      // มี ca
      for (var element in data) {

        SearchDmsxModel model = SearchDmsxModel.fromMap(element);
      searchDmsxModels.add(model);
        
      }

      setState(() {


        for (var element in searchDmsxModels) {

          debugPrint('##14OctV2 latMobile = ${element.latMobile}, lngMobile = ${element.lngMobile}');
          
        }




      });
    }

    // if (dmsxModels.isNotEmpty) {
    //   dmsxModels.clear();
    // }

    // String path =
    //     'https://www.dissrecs.com/apipsinsx/getDmsxLocationWhereCa.php?isAdd=true&ca=$search';
    // await Dio().get(path).then((value) {
    //   Navigator.pop(context);
    //   if (value.toString() == 'null') {
    //     normalDialog(context, 'ไม่พบข้อมูล');
    //   } else {
    //     for (var element in json.decode(value.data)) {
    //       // print('##6jun element === $element');
    //       Dmsxmodel dmsxmodel = Dmsxmodel.fromMap(element);
    //       dmsxModels.add(dmsxmodel);
    //     }
    //   }

    //   setState(() {});

    // });
  }
}
