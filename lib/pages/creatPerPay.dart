import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatPerPay extends StatefulWidget {
  @override
  _CreatPerPayState createState() => _CreatPerPayState();
}

class _CreatPerPayState extends State<CreatPerPay> {
  String  prePayType, prePayAmount, prePayStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250.0,
              child: TextFormField(
                onChanged: (value) => prePayType = value.trim(),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.departure_board_rounded,
                    color: Color(0xff9c4dcc),
                  ),
                  hintText: 'เบิกอะไร',
                  hintStyle: TextStyle(color: Color(0xff9c4dcc), fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              width: 250.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => prePayAmount = value.trim(),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.money_off_rounded,
                    color: Color(0xff9c4dcc),
                  ),
                  hintText: 'จำนวนเงิน',
                  hintStyle: TextStyle(color: Color(0xff9c4dcc), fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget saveButton() => Container(
        width: 250,
        child: MaterialButton(
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          color: Color(0xff6a1b9a),
          onPressed: () {
            if (prePayType == null ||
                prePayType.isEmpty ||
                prePayAmount == null ||
                prePayAmount.isEmpty) {
              normalDialog(context, 'กรุณากรอกให้ครบ');
            } else {
              print('Working');
              saveThread();

            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save),
              SizedBox(width: 20),
              Text(
                'บันทึก',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );

      Future<Null> saveThread()async{

         SharedPreferences preferences = await SharedPreferences.getInstance();
          String rfUserId = preferences.getString('id');

        String url = 'https://www.pea23.com/apipsinsx/addDataPerPay.php?isAdd=true&ref_user_id=$rfUserId&prepay_type=$prePayType&prepay_amount=$prePayAmount&prepay_status=รออนุมัติ';
        try {
          Response response = await Dio().get(url);
          print('response = $response');
          if (response.toString() == 'true') {
            Navigator.pop(context);
          } else {
            normalDialog(context, 'เกิดข้อผิดพลาด กรุณาลองใหม่');
          }
        } catch (e) {
        }
      }
}
