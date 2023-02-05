import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psinsx/models/dmsx_model.dart';
import 'package:psinsx/pages/map_dmsx.dart';
import 'package:psinsx/utility/my_api.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_utility.dart';
import 'package:psinsx/widgets/show_proogress.dart';
import 'package:psinsx/widgets/show_tetle.dart';

import 'package:path/path.dart' as path;

class ShowCusnameDetail extends StatefulWidget {
  final Dmsxmodel dmsxmodel;
  const ShowCusnameDetail({Key key, @required this.dmsxmodel})
      : super(key: key);

  @override
  _ShowCusnameDetailState createState() => _ShowCusnameDetailState();
}

class _ShowCusnameDetailState extends State<ShowCusnameDetail> {
  Dmsxmodel dmsxmodel;
  Map<MarkerId, Marker> markers = {};

  bool checkAmountImagebol = true; //true show เลือกรูป
  String statusText;
  List<String> titleStatuss = [];
  List<Dmsxmodel> dmsxModels = [];
  bool showUpload = false; 
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildSetUp();
  }

  void buildSetUp() {
    dmsxmodel = widget.dmsxmodel;
    double hue = MyApi().calcuclatHue(dmsxmodel.statusTxt);

    MarkerId markerId = MarkerId('id');
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(dmsxmodel.lat.trim()),
        double.parse(
          dmsxmodel.lng.trim(),
        ),
      ),
      infoWindow: InfoWindow(
        onTap: () async {

            processAddImage(dmsxmodel);
          if (dmsxmodel.images.isNotEmpty) {
            checkAmountImage(dmsxmodel.images);
          }
          
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: ListTile(
          //         title: ShowTitle(
          //       title: dmsxmodel.cusName,
          //       textStyle: MyConstant().h2Style(),
          //     )),
          //   ),
          // );
        },
        title: '${dmsxmodel.employeeId}',
        snippet: 'PEA : ${dmsxmodel.peaNo}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
    );

    markers[markerId] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowTitle(
          title: dmsxmodel.cusName,
          textStyle: MyConstant().h4Style(),
        ),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {},
        initialCameraPosition: CameraPosition(
          zoom: 16,
          target: LatLng(
            double.parse(dmsxmodel.lat.trim()),
            double.parse(
              dmsxmodel.lng.trim(),
            ),
          ),
        ),
        markers: Set<Marker>.of(markers.values),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
      ),
    );
  }

    Future<void> processAddImage(Dmsxmodel dmsxmodel) async {
    print('# image ${dmsxmodel.images}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: Text(
            dmsxmodel.cusName,
            style: TextStyle(fontSize: 14),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'สถานะล่าสุด : ${dmsxmodel.statusTxt}',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              Text(
                'สาย : ${dmsxmodel.line}',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                'ca : ${dmsxmodel.ca}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'PEA : ${dmsxmodel.peaNo}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'ที่อยู่ : ${dmsxmodel.address}',
                style: TextStyle(fontSize: 12),
              ),
              dmsxmodel.images.isEmpty ? SizedBox() : showListImages(dmsxmodel),
            ],
          ),
        ),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     // Navigator.pop(context);
          //     // processTakePhoto(
          //     //     dmsxmodel: dmsxmodel, source: ImageSource.camera);
          //      Fluttertoast.showToast(msg: 'กรุณาแนบไฟล์');
          //   },
          //   child: Text('ถ่ายรูป'),
          // ),
          checkAmountImagebol
              ? TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    processTakePhoto(
                        dmsxmodel: dmsxmodel, source: ImageSource.gallery);
                  },
                  child: Text('เลือกรูป'),
                )
              : SizedBox(),
          TextButton(
            onPressed: () {
              checkAmountImagebol = true;
              Navigator.pop(context);
            },
            child: Text('ปิด'),
          ),
        ],
      ),
    );
  }

    void checkAmountImage(String images) {
    String string = images;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    if (strings.length >= 2) {
      setState(() {
        checkAmountImagebol = false;
      });
    }
    print('### checkAmountImagebol ล่าสุด ==> $checkAmountImagebol');
  }

    Widget showListImages(Dmsxmodel dmsxmodel) {
    print('##### image ==> ${dmsxmodel.images}');
    List<Widget> widgets = [];

    String string = dmsxmodel.images;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    print('### strings ==> $strings');

    for (var item in strings) {
      widgets.add(
        Container(
          height: 150,
          width: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CachedNetworkImage(
              imageUrl: '${MyConstant.domainImage}${item.trim()}',
              fit: BoxFit.cover,
              placeholder: (context, url) => ShowProgress(),
              errorWidget: (context, url, error) => SizedBox(),
            ),
          ),
        ),
      );
    }

    return Column(
      children: widgets,
    );
  }

   Future<void> processTakePhoto(
      {Dmsxmodel dmsxmodel, ImageSource source}) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
      );

      File file = File(result.path);

      switch (dmsxmodel.statusTxt.trim()) {
        case 'เริ่มงดจ่ายไฟ':
          titleStatuss = MyConstant.statusTextsNonJay;
          break;
        case 'ขอผ่อนผันครั้งที่ 1':
          titleStatuss = MyConstant.statusTextsWMST1;
          break;
           case 'ขอผ่อนผันครั้งที่ 2':
          titleStatuss = MyConstant.statusTextsWMST2;
          break;
        case 'ปลดสายแล้ว':
          titleStatuss = MyConstant.statusTextsFURM;
          break;
        case 'ถอดมิเตอร์แล้ว':
          titleStatuss = MyConstant.statusTextsWMMR;
          break;
        case 'ให้ต่อสาย':
          titleStatuss = MyConstant.statusTextsFUCM;
          break;

        default:
          titleStatuss = MyConstant.statusTextsJay;
          break;
      }

      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ชื่อ-สกุล: ${dmsxmodel.cusName}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'PEA: ${dmsxmodel.peaNo}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'สถานะล่าสุด: ${dmsxmodel.statusTxt}',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(file),
                  createListStatus(setState),
                ],
              ),
            ),
            actions: [
              showUpload ? buttonUpImage(context, file, dmsxmodel) : SizedBox(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          );
        }),
      );
    } catch (e) {}
  }

   Widget createListStatus(StateSetter mySetState) {
    List<Widget> widgets = [];

    for (var item in titleStatuss) {
      widgets.add(RadioListTile(
        title: Text(
          item,
          style: TextStyle(fontSize: 14),
        ),
        value: item,
        groupValue: statusText,
        onChanged: (value) {
          mySetState(() {
            statusText = value;
            print('statusText = $statusText');
          });
          setState(() {
            showUpload = true;
          });
        },
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

    Widget buttonUpImage(BuildContext context, File file, Dmsxmodel dmsxmodel) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context);

        String nameFile = path.basename(file.path);

        print('# nameFIle = $nameFile');

        String pathUpload = 'https://www.pea23.com/apipsinsx/saveImageCustomer.php';

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file.path, filename: nameFile);
        FormData data = FormData.fromMap(map);
        await Dio().post(pathUpload, data: data).then((value) async {
          print('# === value for upload ==>> $value');
          List<String> images = [];

          if (dmsxmodel.images.isEmpty) {
            images.add(nameFile);
          } else {
            String string = dmsxmodel.images;
            string = string.substring(1, string.length - 1);
            images = string.split(',');
            int index = 0;
            for (var item in images) {
              images[index] = item.trim();
              index++;
            }
            images.add(nameFile);
          }

          String readNumber = 'ดำเนินการแล้ว';

          if (dmsxmodel.readNumber.isEmpty) {
            readNumber = 'ดำเนินการแล้ว';
          } else {
            readNumber = 'ต่อกลับแล้ว';
          }

          String apiEditImages =
              'https://pea23.com/apipsinsx/editDmsxWhereId.php?isAdd=true&id=${dmsxmodel.id}&images=${images.toString()}&status_txt=$statusText&readNumber=$readNumber';

          await Dio().get(apiEditImages).then((value) {
            print('# value update == $value');
            //readDataApi();
          MaterialPageRoute(builder: (_) => Mapdmsx());
          });
        });
      },
      child: Text('อัพโหลด'),
    );
  }

    Future<void> readDataApi() async {

    print('#### readDataApi Work');

    if (markers.isNotEmpty) {
      markers.clear();
    }

    await MyUtility().findUserId().then((value) async {
      if (dmsxModels.isNotEmpty) {
        dmsxModels.clear();
      }

      String path =
          'https://pea23.com/apipsinsx/getDmsxWherUser.php?isAdd=true&user_id=$value';

      await Dio().get(path).then((value) {
        for (var item in json.decode(value.data)) {
          Dmsxmodel dmsxmodel = Dmsxmodel.fromMap(item);
          dmsxModels.add(dmsxmodel);
          //print('#id == ${dmsxmodel.id}');

          setState(() {
            procressAddMarker(dmsxmodel);
            load = false;
          });
        }
      });
    });
  }

    void procressAddMarker(Dmsxmodel dmsxmodel) {
    double hueDouble;

    switch (dmsxmodel.statusTxt) {
      case 'งดจ่ายไม่ได้':
        hueDouble = 0;
        break;
      case 'สั่งระงับการปฏิบัติงาน':
        hueDouble = 250;
        break;
      case 'สั่งระงับ (ชำระเงินระหว่างขอผ่อนผัน':
        hueDouble = 250;
        break;
      case 'รับทราบคำสั่งระงับ':
        hueDouble = 250;
        break;
      case 'ขอผ่อนผันครั้งที่ 1':
        hueDouble = 0;
        break;
      case 'ขอผ่อนผันครั้งที่ 2':
        hueDouble = 0;
        break;
      case 'ปลดสายแล้ว':
        hueDouble = 0;
        break;
      case 'ถอดมิเตอร์แล้ว':
        hueDouble = 0;
        break;
      case 'ให้ต่อสาย':
        hueDouble = 300;
        break;
      case 'ให้ต่อมิเตอร์':
        hueDouble = 300;
        break;
      case 'ต่อสายแล้ว':
        hueDouble = 60;
        break;
      case 'ต่อมิเตอร์แล้ว':
        hueDouble = 60;
        break;

      default:
        hueDouble = 120;
        break;
    }

    print('## hueDouble == $hueDouble');

    MarkerId markerId = MarkerId(dmsxmodel.id);
    Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(hueDouble),
      infoWindow: InfoWindow(
        onTap: () {
          processAddImage(dmsxmodel);
          if (dmsxmodel.images.isNotEmpty) {
            checkAmountImage(dmsxmodel.images);
          }
        },
        title: '${dmsxmodel.employeeId}',
        snippet: 'PEA : ${dmsxmodel.peaNo}',

      ),
      markerId: markerId,
      position: LatLng(
        double.parse(dmsxmodel.lat.trim()),
        double.parse(
          dmsxmodel.lng.trim(),
        ),
      ),
    );
    markers[markerId] = marker;
  }

}
