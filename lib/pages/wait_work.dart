import 'package:flutter/material.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/widgets/show_text.dart';

class WaitWork extends StatefulWidget {
  const WaitWork({Key key}) : super(key: key);

  @override
  _WaitWorkState createState() => _WaitWorkState();
}

class _WaitWorkState extends State<WaitWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('สาถานะ: เลิกงานแล้ว')),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowText(
                text: 'คุณลงชื่อเลิกงานแล้ว นิ!',
                textStyle: MyConstant().h2Style(),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/homePage', (route) => false),
                child: Text('ขออนุญาติเข้าแอพอีกครั้ง',style: TextStyle(fontSize: 18),),
              ),
            ],
          ),
        ));
  }
}
