import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psinsx/models/sub_model.dart';
import 'package:psinsx/models/user_model.dart';
import 'package:psinsx/pages/dashbord.dart';
import 'package:psinsx/pages/home_page.dart';
import 'package:psinsx/pages/oil_page.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddOutLay extends StatefulWidget {
  final SubModel subModel;
  AddOutLay({Key key, this.subModel}) : super(key: key);
  @override
  _AddOutLayState createState() => _AddOutLayState();
}

class _AddOutLayState extends State<AddOutLay> {
  SubModel subModel;
  String valueChoose,
      supplierName,
      details,
      number,
      priceUnit,
      sum,
      tax,
      referenceNumber,
      image;
  DateTime createdAt;
  DateTime createDate;
  TextEditingController dateCtl = TextEditingController();
  List listItem = ['แก็สโซฮอล91', 'แก็สโซฮอล95', 'ดีเซล'];
  File file;
  DateTime selectedDate = DateTime.now();

  var typeOiles = MyConstant.typeOils;
  var dropdownMenuItems = <DropdownMenuItem>[];

  @override
  void initState() {
    super.initState();
    subModel = widget.subModel;

    for (var item in typeOiles) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${subModel.supplierName}'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 20),
              buildImage(),
              SizedBox(height: 20),
              dataSub(),
              SizedBox(height: 20),
              //newTypeOil(),
              detailProductFrom(),
              SizedBox(height: 20),
              valumeFrom(),
              SizedBox(height: 20),
              unitPriceFrom(),
              SizedBox(height: 20),
              vatFrom(),
              SizedBox(height: 20),
              sumFrom(),
              SizedBox(height: 20),
              referNumberFrom(),
              SizedBox(height: 20),
              // dateFrom(),
              // SizedBox(height: 20),
              saveButton(),
              SizedBox(height: 400),
            ],
          ),
        ),
      ),
    );
  }

  Widget newTypeOil() => DropdownButton<String>(
        items: dropdownMenuItems,
        onChanged: (value) {},
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget buildImage() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            width: 200,
            height: 200,
            child: file == null
                ? Icon(
                    Icons.image,
                    size: 200,
                  )
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate_rounded),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
          SizedBox(width: 5),
        ],
      );

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  Widget saveButton() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red[900],
            ),
            onPressed: () {
              if (file == null) {
                normalDialog(context, 'กรุณาเลือรูปภาพก่อน');
              } else if (details == null ||
                  details.isEmpty ||
                  number == null ||
                  number.isEmpty ||
                  priceUnit == null ||
                  priceUnit.isEmpty ||
                  sum == null ||
                  sum.isEmpty ||
                  tax == null ||
                  tax.isEmpty ||
                  referenceNumber == null ||
                  referenceNumber.isEmpty) {
                normalDialog(context, 'กรุกณากรอข้อมูลให้ครบทุกช่อง');
              } else {
                uploadOutlayInserData();
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Future<Null> uploadOutlayInserData() async {
    String urlUpload = 'https://www.pea23.com/apipsinsx/saveFileOutlay.php';

    Random random = Random();

    int i = random.nextInt(1000000);

    String nameFile = 'outlay$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then((value) async {
        String urlPathImage = '${MyConstant().domain}/upload_outlay/$nameFile';
        print('urlPathHmage = ${MyConstant().domain}$urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String userId = preferences.getString('id');
        print('userId === $userId');
        String supplierAddress = subModel.supplierAddress;
        String supplierName = subModel.supplierName;
        String supplierTaxid = subModel.supplierTaxid;
        String branch = subModel.branch;
        DateTime createDate = DateTime.now();

        print('supplierAddress === $supplierAddress');
        print('supplierName === $supplierName');
        print(createDate.toString());

        String urlInsertData =
            'https://www.pea23.com/apipsinsx/addDataOutlay.php?isAdd=true&costType_id=1&supplier_name=$supplierName&supplier_address=$supplierAddress&supplier_taxid=$supplierTaxid&orderFrom_id=1&branch=$branch&user_id=$userId&details=$details&number=$number&priceUnit=$priceUnit&sum=$sum&tax=$tax&referenceNumber=$referenceNumber&image=$urlPathImage&createdAt=$createDate&outlay_status=NO&create_by=$userId&create_date=$createDate';
        await Dio().get(urlInsertData);
        showToast('อัพโหลดสำเร็จ', gravity: Toast.center);
        routeTuService();
      });
    } catch (e) {}
  }

  Future<Null> routeTuService() async {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => OilPage(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'โปรดตรวจสอบความถูกต้องก่อนบันทึกข้อมูล',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'โปรดตรวจสอบชื่อปั๊ม และเลขผู้เสียภาษีให้ถูกต้อง',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      //editDataInsx(insxModel2);
                    },
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget dataSub() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ชื่อซับพลาย : ${subModel.supplierName}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                'เลขภาษี : ${subModel.supplierTaxid}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                'สาขาที่ : ${subModel.branch}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                'ที่อยู่ : ${subModel.supplierAddress}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )),
      );

  Widget detailProductFrom() => Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: TextFormField(
          onChanged: (value) => details = value.trim(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'ชนิดน้ำมัน',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      );

  Widget vatFrom() => Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: TextFormField(
          onChanged: (value) => tax = value.trim(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'ภาษีมูลค่าเพิ่ม',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      );

  Widget unitPriceFrom() => Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: TextFormField(
          onChanged: (value) => priceUnit = value.trim(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'ราคาต่อหน่วย',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      );

  Widget valumeFrom() => Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: TextFormField(
          onChanged: (value) => number = value.trim(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'ปริมาณ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      );

  Widget sumFrom() => Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: TextFormField(
          onChanged: (value) => sum = value.trim(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'รวมเป็นเงิน',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      );

  Widget referNumberFrom() => Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: TextFormField(
          onChanged: (value) => referenceNumber = value.trim(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'เลขที่ใบเสร็จ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      );

  Widget dateFrom() => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "${selectedDate.toLocal()}".split(' ')[0],
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context), // Refer step 3
            child: Text(
              'เลือกวันที่',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
          ),
        ],
      );

  _selectDate(BuildContext context) async {
    final DateTime createdAt = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (createdAt != null && createdAt != selectedDate)
      setState(() {
        selectedDate = createdAt;
        print('createAt $createdAt');
      });
  }
}
