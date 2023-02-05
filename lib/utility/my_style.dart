import 'package:flutter/material.dart';

class MyStyle {




  
  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(
        // backgroundColor: Colors.redAccent,
        // strokeWidth: 10,
        // valueColor: AlwaysStoppedAnimation(Colors.blue),
      ),
    );
  }

    Widget showProgressWithTitle(int timeEdit) {
    return Center(
      child: Row(
        children: [
          CircularProgressIndicator(
          ),
          Text('เวลาที่เหลือ $timeEdit'),
        ],
      ),
    );
  }

  Widget showLogo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 140,
            child: Image.asset('assets/images/logo.png',),
          ),
        ],
      ),
    );
  }
  
}
